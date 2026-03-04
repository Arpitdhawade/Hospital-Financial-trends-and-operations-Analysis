(
	WITH Monthly_Revenue AS
	(
		SELECT  YEAR(Admission_Date)AS Year
		       ,MONTH(Admission_Date)AS Month
		       ,ROUND(SUM(Total_Bill),1) AS current_revenue
		FROM fact_encounter
		GROUP BY  Year
		         ,Month
		ORDER BY  Year
	)
	SELECT  Year
	       ,Month
	       ,current_revenue
	       ,ROUND((current_revenue - LAG(current_revenue,1)OVER(ORDER BY  Year ,Month)) 
		    /LAG(current_revenue,1)OVER(ORDER BY Year ,Month)* 100,1) AS Mom_Growth_Rate
	FROM Monthly_Revenue);


(
	WITH Yearly_Revenue AS
	(
		SELECT  YEAR(Admission_Date)AS Year
		       ,ROUND(SUM(Total_Bill),1) AS current_revenue
		FROM fact_encounter
		GROUP BY  Year
		ORDER BY  Year
	)
	SELECT  Year
	       ,current_revenue
	       ,ROUND((current_revenue - LAG(current_revenue,1)OVER(ORDER BY  Year))
		  /LAG(current_revenue,1)OVER(ORDER BY Year )* 100,1) AS YoY_Growth_Rate
	FROM Yearly_Revenue);


(
WITH roy AS
(
	SELECT  YEAR(Admission_Date)AS year
	       ,MONTH(Admission_Date)AS month
	       ,ROUND(SUM(Total_Bill),1) AS net_revenue
	FROM fact_encounter
	GROUP BY  year
	         ,month
	ORDER BY  year
)
SELECT  ROUND(AVG(net_revenue) OVER(ORDER BY  year ROWS BETWEEN 1 PRECEDING AND CURRENT ROW ),1)AS avg_net_rev
       ,month
       ,year
FROM roy
ORDER BY year ASc);



(
WITH roy AS
(
	SELECT  YEAR(Admission_Date)AS year
	       ,MONTH(Admission_Date)AS month
	       ,ROUND(SUM(Total_Bill),1) AS net_revenue
	FROM fact_encounter
	GROUP BY  year
	         ,month
	ORDER BY  year
)
SELECT  ROUND(AVG(net_revenue) OVER(ORDER BY  year ROWS BETWEEN 3 PRECEDING AND CURRENT ROW ),1)AS avg_net_rev
       ,month
       ,year
FROM roy
WHERE year = 2022
ORDER BY month ASc);


(
WITH roy AS
(
	SELECT  YEAR(Admission_Date)AS year
	       ,MONTH(Admission_Date)AS month
	       ,ROUND(SUM(Total_Bill),1) AS net_revenue
	FROM fact_encounter
	GROUP BY  year
	         ,month
	ORDER BY  year
)
SELECT  ROUND(AVG(net_revenue) OVER(ORDER BY  year ROWS BETWEEN 3 PRECEDING AND CURRENT ROW ),1)AS avg_net_rev
       ,month
       ,year
FROM roy
WHERE year = 2023
ORDER BY month ASc);


(
WITH roy AS
(
	SELECT  YEAR(Admission_Date)AS year
	       ,MONTH(Admission_Date)AS month
	       ,ROUND(SUM(Total_Bill),1) AS net_revenue
	FROM fact_encounter
	GROUP BY  year
	         ,month
	ORDER BY  year
)
SELECT  ROUND(AVG(net_revenue) OVER(ORDER BY  year ROWS BETWEEN 3 PRECEDING AND CURRENT ROW ),1)AS avg_net_rev
       ,month
       ,year
FROM roy
WHERE year = 2024
ORDER BY month ASc);