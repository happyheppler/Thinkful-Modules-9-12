-- 1
-- Inspect schema of naep table
-- A schema comprises the names and data types of the columns
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'naep';

-- 2
-- Return first 50 records of naep table
SELECT *
FROM naep
LIMIT 50;

-- 3
-- Summary statistics for avg_math_4_score by state
SELECT state, 
	COUNT(avg_math_4_score) AS count_avg_math_4_score,
	AVG(avg_math_4_score) AS avg_avg_math_4_score,
	MIN(avg_math_4_score) AS min_avg_math_4_score,
	MAX(avg_math_4_score) AS max_avg_math_4_score
FROM naep
GROUP BY state
ORDER BY state;

-- 4
-- Diff between max and min scores greater than 30
WITH diff_score AS
(
	SELECT state, 
		COUNT(avg_math_4_score) AS count_avg_math_4_score,
		AVG(avg_math_4_score) AS avg_avg_math_4_score,
		MIN(avg_math_4_score) AS min_avg_math_4_score,
		MAX(avg_math_4_score) AS max_avg_math_4_score,
		MAX(avg_math_4_score) - MIN(avg_math_4_score) AS diff_avg_math_4_score
	FROM naep
	GROUP BY state
)

SELECT state, 
	count_avg_math_4_score,
	avg_avg_math_4_score,
	min_avg_math_4_score,
	max_avg_math_4_score
FROM diff_score
WHERE diff_avg_math_4_score > 30
ORDER BY state;

-- 5
-- States in bottom 10 for avg_math_4_score in 2000
SELECT state AS bottom_10_states
FROM naep
WHERE year = 2000
ORDER BY avg_math_4_score
LIMIT 10;

-- 6
-- Average avg_math_4_score rounded to 2 decimal places over all states in 2000
SELECT ROUND(AVG(avg_math_4_score), 2) AS avg_avg_math_4_score
FROM naep
WHERE year = 2000;

-- 7
-- States with below average avg_math_4_score in year 2000
SELECT state AS below_average_states_y2000
FROM naep
WHERE year = 2000
	AND avg_math_4_score <
		(SELECT ROUND(AVG(avg_math_4_score), 2)
		FROM naep
		WHERE year = 2000);

-- 8
-- States missing values for avg_math_4_score for year 2000
SELECT state AS scores_missing_y2000
FROM naep
WHERE avg_math_4_score IS NULL
	AND year = 2000;

-- 9
-- Correlation between avg_math_4_score and total_revenue for year 2000
WITH all_data AS
(
	SELECT naep.state,
		ROUND(avg_math_4_score, 2) AS round_avg_math_4_score,
		total_expenditure
	FROM naep LEFT OUTER JOIN finance
		ON naep.id = finance.id
	WHERE naep.year = 2000
	ORDER BY total_expenditure DESC
)

SELECT *
FROM all_data
WHERE round_avg_math_4_score IS NOT NULL;