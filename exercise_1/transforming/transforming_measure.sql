--Victoria Baker
--The following code transforms the data from the .csv file tables into a model as outlined
--in the entity relationship diagram. Each table only includes the relevant fields for analysis.
DROP TABLE IF EXISTS surveyDim;

--measure dimension to hold measure information and characteristics
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