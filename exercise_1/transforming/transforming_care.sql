--Victoria Baker
--The following code transforms the data from the .csv file tables into a model as outlined
--in the entity relationship diagram. Each table only includes the relevant fields for analysis.
DROP TABLE IF EXISTS caredimstaging;
DROP TABLE IF EXISTS careDim;

--staging table for care
--casting scores so that they can be ranked
--if there is an absence of a score or a null score, then
--the score is 0
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

--care 
CREATE TABLE careDim
as
SELECT
	providerId,
	measureId,
	score,
	--score ranking by measure, ascending. 
	--so, best scores get the greatest number rank
	CASE
	WHEN measureId = NULL THEN 0
	ELSE DENSE_RANK() OVER(PARTITION BY measureId ORDER BY score ASC) 
	END AS ScoreRank
FROM
	caredimstaging
ORDER BY
	ScoreRank;