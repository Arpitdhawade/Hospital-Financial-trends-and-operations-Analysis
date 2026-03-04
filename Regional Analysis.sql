--- To calculate net_revenue generated across diffrent cities in diffrent year ---

(
	WITH rev_per_year AS
	(
		SELECT  city
		       ,state
		       ,EXTRACT(YEAR
		FROM Admission_Date) AS year, ROUND(SUM(Total_Bill), 1) AS net_revenue
		FROM fact_encounter
		GROUP BY  year
		         ,City
		         ,state
		ORDER BY  year
		         ,net_revenue DESC
	), ranking AS
	(
		SELECT  *
		       ,DENSE_RANK()OVER(PARTITION BY year ORDER BY  net_revenue DESC) AS rank_
		FROM rev_per_year
	)
	SELECT  city
	       ,state
	       ,year
	       ,net_revenue
	FROM ranking
	WHERE rank_ <= 10); 

--- To Find out which cities has the largest  Patient Base ----

(
	WITH rev_per_year AS
	(
		SELECT  city
		       ,state
		       ,EXTRACT(YEAR
		FROM Admission_Date) AS year, ROUND(COUNT(Encounter_ID), 1) AS patient_count
		FROM fact_encounter
		GROUP BY  year
		         ,City
		         ,state
		ORDER BY  year
		         ,patient_count DESC
	), ranking AS
	(
		SELECT  *
		       ,DENSE_RANK()OVER(PARTITION BY year ORDER BY  patient_count DESC) AS rank_
		FROM rev_per_year
	)
	SELECT  city
	       ,state
	       ,year
	       ,patient_count
	FROM ranking
	WHERE rank_ <= 10 );