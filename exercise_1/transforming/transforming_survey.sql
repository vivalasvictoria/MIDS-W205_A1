--Victoria Baker
--The following code transforms the data from the .csv file tables into a model as outlined
--in the entity relationship diagram. Each table only includes the relevant fields for analysis.
DROP TABLE IF EXISTS surveystaging;
DROP TABLE IF EXISTS surveyDim;

CREATE TABLE surveystaging
as
SELECT
	providernumber,
	dimension,
	points
	FROM
	(SELECT
		providernumber,
		--pivot survey dimension columns so that scores can be aggregated
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

--survey
CREATE TABLE surveyDim
as
SELECT
	providerId,
	dimension,
	numerator,
	denominator,
	percentage,
	--score ranking by measure, ascending. 
	--so, best scores get the greatest number rank
	DENSE_RANK() OVER(PARTITION BY dimension ORDER BY percentage ASC) as ScoreRank
FROM
( 
SELECT
	providernumber as providerId,
	dimension,
	CASE 
	WHEN dimension = 'hcahpsBaseScore' or dimension = 'hcahpsConsistencyScore' THEN points 
	WHEN points = NULL THEN 0
	ELSE CAST(RTRIM(SUBSTRING(points, 1, 2)) AS INT) END as numerator,
	CASE 
	WHEN dimension = 'hcahpsBaseScore' or dimension = 'hcahpsConsistencyScore' THEN 1
	WHEN points = NULL THEN 0
	ELSE CAST(LTRIM(SUBSTRING(points, LENGTH(points)-1, 2)) AS INT) END as denominator,
	CASE
	WHEN dimension = 'hcahpsBaseScore' or dimension = 'hcahpsConsistencyScore' THEN CAST(SUBSTRING(points, 1, 2) AS INT) 
	WHEN points = NULL THEN 0.0
	ELSE CAST(CAST(RTRIM(SUBSTRING(points, 1, 2)) AS INT)/CAST(LTRIM(SUBSTRING(points, LENGTH(points)-1, 2)) AS INT) AS FLOAT)  END as percentage
FROM surveystaging) AS a;