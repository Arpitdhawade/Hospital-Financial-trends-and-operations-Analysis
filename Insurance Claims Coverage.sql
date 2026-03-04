---To determine Realization Rate/Percentage aacross Diffrent Insurance Provider---

(
	SELECT  Insurance_Provider
	       ,ROUND(SUM(Insurance_Amount)/SUM(Total_Bill)* 100,1) AS Realisation_rate
	       ,(
	SELECT  ROUND(AVG(Insurance_Amount)/AVG(Total_Bill)* 100,1) AS avg_realisation_rate
	FROM fact_encounter fe
	LEFT JOIN dim_insurance di
	ON fe.Encounter_ID = di.Encounter_ID
	 ) avg_realisation_rate
	 ,EXTRACT(YEAR
	FROM Admission_Date ) AS year
	FROM fact_encounter fe
	LEFT JOIN dim_insurance di
	ON fe.Encounter_ID = di.Encounter_ID
	WHERE NOT Insurance_Provider IN ( "None", "Other")
	GROUP BY  Insurance_Provider
	         ,year ORDER BY  year
	         ,Realisation_rate DESC);

---- To determine Average Out Of Pocket Cost By Diffrent Insurance Provider---

	(
	WITH t AS
	(
		SELECT  AVG(Total_Bill)       AS Total_Bill
		       ,AVG(Insurance_Amount) AS ins_amount
		       ,Insurance_Provider
		FROM fact_encounter fe
		LEFT JOIN dim_insurance di
		ON fe.Encounter_ID = di.Encounter_ID
		GROUP BY  Insurance_Provider
	)
	SELECT  Total_Bill - ins_amount AS avg_out_of_pocket_cost
	       ,Insurance_Provider
	FROM t
	WHERE NOT Insurance_Provider IN ("None", "Other")
	GROUP BY  Insurance_Provider ORDER BY  avg_out_of_pocket_cost DESC );