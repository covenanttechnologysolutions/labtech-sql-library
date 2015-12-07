/*

Description       : Get monitor stuck removing and installing.
Source URL        : http://github.com/jesseconnr/labtech-sql-library

Tested Versions   :
  MySQL 5.7
  LabTech 10.0, 10.5

*/

SELECT
  cmd.computerid
  , c.name
  , c.lastcontact   AS 'Agent last contact'
  , cmd.dateupdated AS ' cmd last updated'
  , COUNT(*)        AS 'cmdCount'
FROM commands cmd LEFT JOIN computers c ON (c.computerid = cmd.computerid)
WHERE cmd.status = 2
      AND cmd.DateUpdated > TIME(DATE_SUB(NOW(), INTERVAL 2 HOUR))
GROUP BY cmd.computerid
HAVING cmdCount > 25
ORDER BY COUNT(*) DESC