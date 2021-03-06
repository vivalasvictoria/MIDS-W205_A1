--Victoria Baker
--The following code calculates the total survey scores and percentage by hospital

--these are the tables getting created in this script, 
--if they already exist in this context, delete them
DROP TABLE IF EXISTS surveyResults;
DROP TABLE IF EXISTS hospitals_and_patients_var;
DROP TABLE IF EXISTS hospitals_and_patients_qual;

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
	a.totalPercentage as totalPercentage
FROM
	(SELECT
		providerId,
		SUM(numerator) as numSum,
		SUM(denominator) as denomSum,
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
		numerator
	FROM
		surveyDim
	WHERE
		dimension = 'hcahpsBaseScore') b ON a.providerId = b.providerId
LEFT JOIN
--hcahpsConsistencyScore
	(SELECT
		providerId,
		numerator
	FROM
		surveyDim
	WHERE
		dimension = 'hcahpsConsistencyScore') c ON a.providerId = c.providerId
ORDER BY 
	totalPercentage;

--this table shows total survey scores percentage for the top 10 hospitals
CREATE TABLE hospitals_and_patients_qual AS
SELECT
	s.providerId,
	c.hospitalName,
	s.numerator,
	s.denominator,
	s.totalPercentage,
	c.totalScore
FROM best_hospitals c 
LEFT JOIN surveyResults s ON c.providerId = s.providerId
ORDER BY c.totalScore DESC
LIMIT 10;

SELECT * FROM hospitals_and_patients_qual ORDER BY totalScore DESC; 

--this table shows total survey scores percentage for the top 10 most variable hospitals
CREATE TABLE hospitals_and_patients_var AS
SELECT
	c.providerId,
	c.hospitalName,
	s.numerator,
	s.denominator,
	s.totalPercentage,
	c.scoreVar
FROM hospital_variability c 
LEFT JOIN surveyResults s ON c.providerId = s.providerId
ORDER BY c.scoreVar DESC;

SELECT * FROM hospitals_and_patients_var ORDER BY scoreVar DESC; 

  
