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


#todo: determine the ScriptFlags use
#todo: verify each property, get names where it's needed
#todo: find out why groupscripts contains scripts not related to groups

SELECT
    CONCAT_WS(' - ', Groups.GroupID, Groups.Name)          AS `GroupName`
  , Groups.FullName                                        AS `GroupPath`
  , CONCAT_WS(' - ', Scripts.ScriptId, Scripts.ScriptName) AS `ScriptName`
  , Searches.Name                                          AS `SearchName`
  , ScheduledScripts.Priority
  , ScheduledScripts.Last_Date
  , ScheduledScripts.SkipOffline
  , ScheduledScripts.OfflineOnly
  , ScheduledScripts.WakeOffline
  , ScheduledScripts.WakeScript
  , ScheduledScripts.DisableTimeZone
  , ScheduledScripts.RunScriptOnProbe
  , ScheduledScripts.RunTime                               AS `NextRun`
  , ScheduledScripts.ScriptType
  , ScheduledScripts.Repeat
  , ScheduledScripts.DistributionWindowType
  , ScheduledScripts.DistributionWindowAmount
  , ScheduledScripts.ScheduleType
  , ScheduledScripts.Interval
  , ScheduledScripts.RepeatType
FROM groupscripts AS `ScheduledScripts`
  LEFT JOIN lt_scripts AS `Scripts` ON ScheduledScripts.ScriptID = Scripts.ScriptId
  LEFT JOIN mastergroups AS `Groups` ON ScheduledScripts.GroupID = Groups.GroupID
  LEFT JOIN sensorchecks AS `Searches` ON ScheduledScripts.SearchID = Searches.SensID
WHERE (Scripts.ScriptFlags & 128) <> 128 AND (Scripts.ScriptFlags & 64) <> 64
ORDER BY Groups.FullName ASC;


