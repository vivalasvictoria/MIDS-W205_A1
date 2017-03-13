--Victoria Baker
--The following code transforms the data from the .csv file tables into a model as outlined
--in the entity relationship diagram. Each table only includes the relevant fields for analysis.
DROP TABLE IF EXISTS hospitalDim;

--hospital dimension to hold hospital information and characteristics
CREATE TABLE hospitalDim AS
SELECT
	h.providerId,
	h.hospitalName,
	h.city,
	h.state
FROM
	hospital h;