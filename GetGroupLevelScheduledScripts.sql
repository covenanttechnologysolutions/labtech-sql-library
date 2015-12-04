/*

Description       : Get scheduled scripts for each group in LabTech.
Source URL        : http://github.com/jesseconnr/labtech-sql-library

Tested Versions   :
  MySQL 5.7
  LabTech 10.0

Table Aliases     :
  Groups                - mastergroups
  ScheduledScripts      - groupscripts
  Scripts               - lt_scripts
  Searches              - sensorchecks

*/

#todo: combine repeat and schedule columns into single readable columns

SELECT
    CONCAT_WS(' - ', Groups.GroupID, Groups.Name)          AS `GroupName`
  , Groups.FullName                                        AS `GroupPath`
  , CONCAT_WS(' - ', Scripts.ScriptId, Scripts.ScriptName) AS `ScriptName`
  , Searches.Name                                          AS `SearchName`
  , ScheduledScripts.SkipOffline
  , ScheduledScripts.OfflineOnly
  , ScheduledScripts.Priority
  , ScheduledScripts.RunScriptonProbe
  , ScheduledScripts.Parameters
  , ScheduledScripts.Last_Date                             AS `LastDateRan`
  , ScheduledScripts.RunTime                               AS `NextRunDate`
  , CASE
    WHEN ScheduledScripts.ScheduleType = 1 THEN 'Once'
    WHEN ScheduledScripts.ScheduleType = 2 THEN 'Minute'
    WHEN ScheduledScripts.ScheduleType = 3 THEN 'Hourly'
    WHEN ScheduledScripts.ScheduleType = 4 THEN 'Daily'
    WHEN ScheduledScripts.ScheduleType = 5 THEN 'Weekly'
    WHEN ScheduledScripts.ScheduleType = 6 THEN 'Monthly'
    END                                                    AS `ScheduleType`
  , ScheduledScripts.Interval                              AS `RunEveryXScheduleType`
  , CASE
    WHEN ScheduledScripts.RepeatType = 0 THEN 'None'
    WHEN ScheduledScripts.RepeatType = 1 THEN 'Seconds'
    WHEN ScheduledScripts.RepeatType = 2 THEN 'Minutes'
    WHEN ScheduledScripts.RepeatType = 3 THEN 'Hours'
    END                                                    AS `RepeatType`
  , ScheduledScripts.RepeatAmount
  , ScheduledScripts.RepeatStopAfter                       AS `StopRepeatAfterXRepetitions`
FROM groupscripts AS `ScheduledScripts`
  LEFT JOIN lt_scripts AS `Scripts` ON ScheduledScripts.ScriptID = Scripts.ScriptId
  LEFT JOIN mastergroups AS `Groups` ON ScheduledScripts.GroupID = Groups.GroupID
  LEFT JOIN sensorchecks AS `Searches` ON ScheduledScripts.SearchID = Searches.SensID
ORDER BY Groups.FullName ASC;


