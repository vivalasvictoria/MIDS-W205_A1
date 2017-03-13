--Victoria Baker
--The following code transforms the data from the .csv file tables into a model as outlined
--in the entity relationship diagram. Each table only includes the relevant fields for analysis.
DROP TABLE IF EXISTS readmissionsdimstaging;
DROP TABLE IF EXISTS readmissionsDim;

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
	--original score field
	CASE 
	WHEN (r.score = 'Not Available' OR r.score = NULL) THEN 0.0
	ELSE CAST(r.score AS FLOAT) END AS score,
	--score compared to national rate
	CASE
	WHEN r.comparedToNational = "Not Available" OR r.comparedToNational = "Number of Cases Too Small" THEN 0.0
	WHEN CAST(r.lowerEstimate AS FLOAT) > rn.nationalRate THEN CAST(r.lowerEstimate AS FLOAT) 
	WHEN CAST(r.higherEstimate AS FLOAT) < rn.nationalRate THEN CAST(r.higherEstimate AS FLOAT) 
	ELSE r.score END AS comparisonScore
FROM
readmissions AS r
LEFT JOIN readmissionsNat AS rn ON r.measureId = rn.measureId;

--readmissions 
CREATE TABLE readmissionsDim
as
SELECT
	providerId,
	measureId,
	comparedToNational,
	score,
	comparisonScore,
	--score ranking by measure, descending. 
	--so, best scores get the greatest number rank
	CASE
	WHEN measureId = NULL THEN 0
	ELSE DENSE_RANK() OVER(PARTITION BY measureId ORDER BY score DESC) 
	END AS ScoreRank,
	--comparison score ranking by measure, descending. 
	--so, best scores get greatest rank
	CASE
	WHEN measureId = NULL THEN 0
	ELSE DENSE_RANK() OVER(PARTITION BY measureId ORDER BY comparisonScore DESC) 
	END AS comparisonScoreRank
FROM
readmissionsdimstaging;