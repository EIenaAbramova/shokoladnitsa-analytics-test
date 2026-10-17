-- 1. Average salary of managers present in db.
-- EXISTS counts a manager once, regardless of direct-report count.
SELECT AVG(m.payment) AS average_manager_payment
FROM db AS m
WHERE EXISTS (
    SELECT 1 FROM db AS e
    WHERE e.boss_user_id = m.user_id
);

-- 2. Average number of direct reports per manager present in db.
WITH direct_reports AS (
    SELECT m.user_id, COUNT(*) AS report_count
    FROM db AS m
    JOIN db AS e ON e.boss_user_id = m.user_id
    GROUP BY m.user_id
)
SELECT AVG(1.0 * report_count) AS average_direct_reports
FROM direct_reports;

-- 3. Employees whose salary exceeds their direct manager's salary.
SELECT e.user_id, e.payment,
       m.user_id AS boss_user_id, m.payment AS boss_payment
FROM db AS e
JOIN db AS m ON m.user_id = e.boss_user_id
WHERE e.payment > m.payment
ORDER BY e.user_id;

-- Diagnostic: referenced managers missing from db.
-- This is data quality information, not a fourth task.
SELECT DISTINCT e.boss_user_id AS missing_manager_id
FROM db AS e
LEFT JOIN db AS m ON m.user_id = e.boss_user_id
WHERE e.boss_user_id IS NOT NULL AND m.user_id IS NULL;
