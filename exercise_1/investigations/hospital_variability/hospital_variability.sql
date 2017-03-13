--Victoria Baker
--The following code transforms the data from the .csv file tables into a model as outlined

--these are the tables getting created in this script, 
--if they already exist in this context, delete them
DROP TABLE IF EXISTS varResults;
DROP TABLE IF EXISTS hospitalVarResults;
DROP TABLE IF EXISTS hospital_variability;

--measure variability
--score variance is calculated and grouped by measure 
CREATE TABLE measureVarResults AS
SELECT
	a.measureId,
	m.measureName,
	a.scoreVar
FROM
	(SELECT
		measureId,
		--population variance of score
		var_pop(score) as scoreVar
	FROM
	careDim
	GROUP BY
	measureId) a
LEFT JOIN measureDim m ON m.measureId = a.measureId
ORDER BY scoreVar DESC; 

--hospital variability
--score variance is calculated and grouped by hospital 
CREATE TABLE hospitalVarResults AS
SELECT
	a.providerId,
	h.hospitalName,
	a.scoreVar
FROM
	(SELECT
		providerId,
		--population variance of score
		var_pop(score) as scoreVar
	FROM
	careDim
	GROUP BY
	providerId) a
LEFT JOIN hospitalDim h ON h.providerId = a.providerId
ORDER BY scoreVar DESC; 

CREATE TABLE hospital_variability AS
SELECT *
FROM hospitalVarResults
LIMIT 10;

CREATE TABLE measure_variability AS
SELECT *
FROM measureVarResults
LIMIT 10;

--Since the question is asking for variability of procedures across hospitals, 
--measureVarResults is the table needed to provide the answer
SELECT * FROM measure_variability;