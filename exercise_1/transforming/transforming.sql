--Victoria Baker
--The following code transforms the data from the .csv file tables into a model as outlined
--in the entity relationship diagram. Each table only includes the relevant fields for analysis.

--these are the tables getting created in this script, 
--if they already exist in this context, delete them
DROP TABLE IF EXISTS measureDim;
DROP TABLE IF EXISTS hospitalDim;
DROP TABLE IF EXISTS readmissionsdimstaging;
DROP TABLE IF EXISTS readmissionsDim;
DROP TABLE IF EXISTS caredimstaging;
DROP TABLE IF EXISTS careDim;
DROP TABLE IF EXISTS surveystaging;
DROP TABLE IF EXISTS surveyDim;

CREATE TABLE measureDim AS
SELECT
m.measureId AS measureId,
m.measureName AS measureName,
--include NationalRate for each measure where applicable, else cast so that 
--calculation errors will not occur
CASE
WHEN rn.nationalRate is null THEN CAST(en.nationalScore AS FLOAT)
ELSE rn.nationalRate
END as nationalScore

FROM
measures as m 
LEFT JOIN readmissionsNat as rn ON m.measureId = rn.measureId
LEFT JOIN effective_careNat as en ON m.measureId = en.measureId;


CREATE TABLE hospitalDim AS
SELECT
h.providerId,
h.hospitalName,
h.city,
h.state

FROM
hospital h;

--staging table for readmissions
--casting scores so that they can be ranked
--if there is an absence of a score or a null score, then
--the score is 0
CREATE TABLE readmissionsdimstaging
as
SELECT
r.providerId,
r.measureId,
r.comparedToNational,
CASE 
WHEN (r.score = 'Not Available' OR r.score = NULL) THEN 0.0
ELSE CAST(r.score AS FLOAT) END AS score,
CASE
WHEN r.comparedToNational = "Not Available" OR r.comparedToNational = "Number of Cases Too Small" THEN 0.0
WHEN CAST(r.lowerEstimate AS FLOAT) > rn.nationalRate THEN CAST(r.lowerEstimate AS FLOAT) 
WHEN CAST(r.higherEstimate AS FLOAT) < rn.nationalRate THEN CAST(r.higherEstimate AS FLOAT) 
ELSE r.score END AS comparisonScore
FROM
readmissions AS r
LEFT JOIN readmissionsNat AS rn ON r.measureId = rn.measureId;


CREATE TABLE readmissionsDim
as
SELECT
providerId,
measureId,
comparedToNational,
score,
comparisonScore,
CASE
WHEN measureId = NULL THEN 0
ELSE DENSE_RANK() OVER(PARTITION BY measureId ORDER BY score DESC) 
END AS ScoreRank,
CASE
WHEN measureId = NULL THEN 0
ELSE DENSE_RANK() OVER(PARTITION BY measureId ORDER BY comparisonScore DESC) 
END AS comparisonScoreRank

FROM
readmissionsdimstaging;


CREATE TABLE caredimstaging
as
SELECT
providerId,
measureId,
CASE 
WHEN (score = 'Not Available' OR score = NULL) THEN 0.0
ELSE CAST(score AS FLOAT) END AS score
FROM
effective_care;

CREATE TABLE careDim
as
SELECT
providerId,
measureId,
score,
CASE
WHEN measureId = NULL THEN 0
ELSE DENSE_RANK() OVER(PARTITION BY measureId ORDER BY score ASC) 
END AS ScoreRank
FROM
caredimstaging;

CREATE TABLE surveystaging
as
SELECT
providernumber,
dimension,
points
FROM
(SELECT
providernumber,
map(
"commNursesAchievement",
commNursesAchievement,                                                                                                   
"commNursesImprovement",
commNursesImprovement,
"commNursesDimension",
commNursesDimension,
"commDoctorsAchievement",
commDoctorsAchievement,	 
"commDoctorsImprovement",
commDoctorsImprovement,	 
"commDoctorsDimension",
commDoctorsDimension,
"ResponsivenessStaffAchievement",
ResponsivenessStaffAchievement,
"responsivenessStaffImprovement", 
responsivenessStaffImprovement,	 
"responsivenessStaffDimension",
responsivenessStaffDimension,
"painAchievement", 
painAchievement,	 
"painImprovement",
painImprovement,
"painDimension",
painDimension,
"commMedicinesAchievement",
commMedicinesAchievement,
"commMedicinesImprovement",
commMedicinesImprovement,
"commMedicinesDimension",
commMedicinesDimension,
"quietnessAchievement",
quietnessAchievement,
"quietnessImprovement",
quietnessImprovement,
"quietnessDimension",
quietnessDimension,
"dischargeAchievement",
dischargeAchievement,
"dischargeImprovement",
dischargeImprovement,
"dischargeDimension",
dischargeDimension,
"overallRatingAchievement",
overallRatingAchievement,
"overallRatingImprovement",
overallRatingImprovement,	 
"overallRatingDimension",   
overallRatingDimension,	 
"hcahpsBaseScore",
hcahpsBaseScore,
"hcahpsConsistencyScore",
	 hcahpsConsistencyScore) as map1 from responses) as t1
lateral view explode(map1) xyz as dimension, points;

CREATE TABLE surveyDim
as
SELECT
providerId,
dimension,
numerator,
denominator,
percentage,
DENSE_RANK() OVER(PARTITION BY dimension ORDER BY percentage ASC) as ScoreRank
FROM
( 
SELECT
providernumber as providerId,
dimension,
CASE 
WHEN dimension = 'hcahpsBaseScore' or dimension = 'hcahpsConsistencyScore' THEN points 
ELSE IFNULL(CAST(RTRIM(SUBSTRING(points, 1, 2)) AS INT),0) END as numerator,
CASE 
WHEN dimension = 'hcahpsBaseScore' or dimension = 'hcahpsConsistencyScore' THEN 1 
ELSE IFNULL(CAST(LTRIM(SUBSTRING(points, LENGTH(points)-1, 2)) AS INT),0) END as denominator,
CASE
WHEN dimension = 'hcahpsBaseScore' or dimension = 'hcahpsConsistencyScore' THEN CAST(SUBSTRING(points, 1, 2) AS INT) 
ELSE IFNULL(CAST(CAST(RTRIM(SUBSTRING(points, 1, 2)) AS INT)/CAST(LTRIM(SUBSTRING(points, LENGTH(points)-1, 2)) AS INT) AS FLOAT), 0.0)  END as percentage
FROM surveystaging) AS a;