--Victoria Baker
--The following code transforms the data from the .csv file tables into a model as outlined

--these are the tables getting created in this script, 
--if they already exist in this context, delete them
DROP TABLE IF EXISTS surveyResults;
DROP TABLE IF EXISTS hospitals_and_patients;

--surveyResults 
--all survey question scores and possible points are aggregated by hospital, then calculated to a percentage
--hcahpsBaseScore & hcahpsConsistencyScore are not included in the percentage
CREATE TABLE surveyResults AS
SELECT
	a.providerId,
	b.numerator as hcahpsBaseScore,
	c.numerator as hcahpsConsistencyScore,
	a.numSum as numerator,
	a.denomSum as denominator,
	a.totalPercentage as percentage
FROM
	(SELECT
		providerId,
		SUM(numerator) numSum,
		SUM(denominator) denomSum,
		SUM(numerator)/SUM(denominator) as totalPercentage
	FROM
		surveyDim
	WHERE
		dimension != 'hcahpsBaseScore'
		and dimension != 'hcahpsConsistencyScore'
	GROUP BY
		providerId) a 
LEFT JOIN
--hcahpsBaseScore
	(SELECT
		providerId,
		dimension,
		numerator
	FROM
		surveyDim
	WHERE
		dimension = 'hcahpsBaseScore'
	GROUP BY
		providerId) b ON a.providerId = b.providerId
LEFT JOIN
--hcahpsConsistencyScore
	(SELECT
		providerId,
		dimension,
		numerator
	FROM
		surveyDim
	WHERE
		dimension = 'hcahpsConsistencyScore'
	GROUP BY
		providerId) c ON a.providerId = c.providerId
ORDER BY 
	totalPercentage;

--this table shows total survey scores percentage for the top 10 hospitals
CREATE TABLE hospitals_and_patients AS
SELECT * 
FROM best_hospitals c 
LEFT JOIN surveyResults s ON c.providerId = s.providerId;

SELECT * 
FROM hospitals_and_patients;    

SELECT
	s.providerId,
	v.hospitalName,
	s.numSum,
	s.denomSum,
	s.totalPercentage
FROM surveyResults s 
LEFT JOIN hospitalVarResults v ON s.providerId = v.providerId 
LIMIT 10;  
