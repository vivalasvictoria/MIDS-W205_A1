--Victoria Baker
--The following code aggregates the care and readmissions scores per hospital to determine the hospitals
--with the most effective care

--these are the tables getting created in this script, 
--if they already exist in this context, delete them
DROP TABLE IF EXISTS careResults;
DROP TABLE IF EXISTS readmissionsResults;
DROP TABLE IF EXISTS hospitalResults;
DROP TABLE IF EXISTS best_hospitals;

--careResults
CREATE TABLE careResults AS
SELECT
	a.providerId,
	h.hospitalName,
	a.score
FROM
	(SELECT
		providerId,
		sum(ScoreRank) as score
	FROM
		careDim
	GROUP BY
		providerId) a
LEFT JOIN hospitalDim h ON h.providerId = a.providerId
ORDER BY 
	score DESC;

--readmissionsResults
CREATE TABLE readmissionsResults AS
SELECT
	a.providerId,
	h.hospitalName,
	a.score
FROM
	(SELECT
		providerId,
		sum(comparisonScoreRank) as score
	FROM
		readmissionsDim
	GROUP BY
		providerId) a
LEFT JOIN hospitalDim h ON h.providerId = a.providerId
ORDER BY 
	score DESC;

--hospitalResults
--each hospital is rated by the sum of care scores and readmissions scores
CREATE TABLE hospitalResults AS
SELECT 
	c.providerId, 
	c.hospitalName, 
	(c.score + r.score) as totalScore 
FROM careResults c 
LEFT JOIN readmissionsResults r ON c.providerId = r.providerId 
ORDER BY 
	totalScore DESC;

--result set is the top 10 hospitals with the greatest combined care and readmissions scores
CREATE TABLE best_hospitals AS
SELECT *
FROM hospitalResults
LIMIT 10;

SELECT * FROM best_hospitals;