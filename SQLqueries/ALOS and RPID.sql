----To determine ALOS and Avg bill correlaation -------

(
WITH alos AS
	( (
		SELECT  ROUND(AVG(Total_Bill),1) AS avg_bill
		       ,(
		SELECT  ROUND(AVG(Total_Bill),1)
		FROM fact_encounter )AS ovr_avg_bill, ROUND(AVG(Length_of_Stay), 1)AS avg_length_of_stay, (
		SELECT  ROUND(AVG(Length_Of_Stay),1)
		FROM fact_encounter )AS ovr_avg_stay, EXTRACT(YEAR
		FROM Admission_Date) AS year, dd.Diagnosis_Name
		FROM fact_encounter fe
		LEFT JOIN dim_diagnosis dd
		ON fe.Diagnosis_Key = dd.Diagnosis_Key
		GROUP BY  dd.Diagnosis_Name
		         ,year ORDER BY  year
		         ,avg_bill DESC)
	), ranking AS
	(
		SELECT  *
		       ,DENSE_RANK()OVER(PARTITION BY year ORDER BY  avg_bill DESC)AS rank_
		FROM alos
	)
	SELECT  *
	FROM ranking
	WHERE rank_ <= 15);
	
----To calculate revenue per inpatient days-----

(
	WITH rpi AS
	(
		SELECT  Diagnosis_Name
		       , ROUND(SUM(Total_Bill), 1) AS total_revenue, ROUND(SUM(Length_of_Stay), 1) AS total_inpatient_day
			   ,(SELECT
			   ROUND(SUM(Total_Bill),1) / ROUND(SUM(Length_Of_Stay),1) AS avg_rev_per_inpatient_day
			   FROM fact_encounter) AS avg_rev_per_inpatient_day
		FROM fact_encounter fe
		LEFT JOIN dim_diagnosis di
		ON fe.Diagnosis_Key = di.Diagnosis_Key
		GROUP BY
		         Diagnosis_Name
		
	), rankings AS
	(
		SELECT  Diagnosis_Name
		       ,ROUND(total_revenue/total_inpatient_day,1)AS rev_per_inpatient_day
			   ,avg_rev_per_inpatient_day
		       ,DENSE_RANK()OVER( ORDER BY  total_revenue/total_inpatient_day DESC) AS rank_
		FROM rpi
	)
	SELECT  *
	FROM rankings
	WHERE rank_ <= 15);