--Victoria Baker
--The following code aggregates the care and readmissions scores per state to determine the state
--with the most effective care

--these are the tables getting created in this script, 
--if they already exist in this context, delete them
DROP TABLE IF EXISTS stateResults;
DROP TABLE IF EXISTS best_states;

--stateResults
--to determine best state, the scores are reaggregated by state instead of hospital
--from hospitalResults, then divided by the count of all hospitals in the state.
--The state with the most highly rated hospitals will be ranked highest
CREATE TABLE stateResults AS
SELECT
	a.state,
	--use added care and readmissions score from best_hospitals script
	SUM(a.totalscore) as totalScore,
	SUM(b.hospitalCount) as hospitalCount,
	SUM(a.totalscore)/SUM(b.hospitalCount) as stateResult
FROM
	--this gets the scores per state
	(SELECT 
		h.state,
		SUM(r.totalScore) as totalscore
	FROM hospitalResults r
	LEFT JOIN hospitalDim h ON r.providerId = h.providerId
	GROUP BY h.state) a
LEFT JOIN 
	--this gets the count of hospitals per state
	(SELECT COUNT(DISTINCT r.providerId) AS hospitalCount,
		h.state
		FROM hospitalResults r 
		LEFT JOIN hospitalDim h on r.providerId = h.providerId
		GROUP BY h.state) b ON a.state = b.state
GROUP BY a.state
ORDER BY stateResult DESC; 

CREATE TABLE best_states AS
SELECT *
FROM stateResults
ORDER BY stateResult DESC
LIMIT 10;

SELECT * FROM best_states ORDER BY stateResult DESC;