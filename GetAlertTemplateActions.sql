/*

Description       : Get alert actions for each alert template in LabTech.
Source URL        : http://github.com/jesseconnr/labtech-sql-library

Tested Versions   :
  MySQL 5.7
  LabTech 10.0

Table Aliases     :
  AlertTemplates        - alerttemplate
  AlertActions          - alerttemplates
  Contacts              - contacts
  Scripts               - lt_scripts

*/

SELECT
    CONCAT_WS(' - ', AlertTemplates.AlertActionID, AlertTemplates.Name) AS                          `TemplateName`
  , AlertActions.AlertID
  , CONCAT_WS(', ', CASE WHEN (AlertActions.Alertaction & 0x00) = 0x00 AND
                              AlertActions.Message = 'DIVERSION!!!' THEN 'Suppress Alerts' END,
              CASE WHEN (AlertActions.Alertaction & 0x01) = 0x01 THEN 'Raise Alert' END,
              CASE WHEN (AlertActions.Alertaction & 0x02) = 0x02 THEN 'Email' END,
              CASE WHEN (AlertActions.Alertaction & 0x04) = 0x04 THEN 'Pager' END,
              CASE WHEN (AlertActions.Alertaction & 0x08) = 0x08 THEN 'Voice' END,
              CASE WHEN (AlertActions.Alertaction & 0x10) = 0x10 THEN 'Fax' END,
              CASE WHEN (AlertActions.Alertaction & 0x20) = 0x20 THEN 'Print' END,
              CASE WHEN (AlertActions.Alertaction & 0x40) = 0x40 THEN 'File' END,
              CASE WHEN (AlertActions.Alertaction & 0x80) = 0x80 THEN 'Messenger' END,
              CASE WHEN (AlertActions.Alertaction & 0x100) = 0x100 THEN 'Instant Messenger' END,
              CASE WHEN (AlertActions.Alertaction & 0x200) = 0x200 THEN 'Script' END,
              CASE WHEN (AlertActions.Alertaction & 0x400) = 0x400 THEN 'Ticket' END,
              CASE WHEN (AlertActions.Alertaction & 0x800) = 0x800 THEN 'Raise Warning' END,
              CASE WHEN (AlertActions.Alertaction & 0x1000) = 0x1000 THEN 'Raise Information' END,
              CASE WHEN (AlertActions.Alertaction & 0x2000) = 0x2000 THEN 'ConnectWise Ticket' END,
              CASE WHEN (AlertActions.Alertaction & 0x4000) = 0x4000 THEN 'ConnectWise Ticket 2' END,
              CASE WHEN (AlertActions.Alertaction & 0x8000) = 0x8000 THEN 'ConnectWise Opportunity' END,
              CASE WHEN (AlertActions.Alertaction & 0x10000) = 0x10000 THEN 'Ticket Comment' END,
              CASE WHEN (AlertActions.Alertaction & 0x20000) = 0x20000 THEN 'Ticket Response' END,
              CASE WHEN (AlertActions.Alertaction & 0x40000) = 0x40000 THEN 'Custom Alert 4' END,
              CASE WHEN (AlertActions.Alertaction & 0x80000) = 0x80000 THEN 'Custom Alert 5' END)   `Error Action`
  , CONCAT_WS(', ', CASE WHEN (AlertActions.WarningAction & 0x00) = 0x00 AND
                              AlertActions.Message = 'DIVERSION!!!' THEN 'Suppress Alerts' END,
              CASE WHEN (AlertActions.WarningAction & 0x01) = 0x01 THEN 'Raise Alert' END,
              CASE WHEN (AlertActions.WarningAction & 0x02) = 0x02 THEN 'Email' END,
              CASE WHEN (AlertActions.WarningAction & 0x04) = 0x04 THEN 'Pager' END,
              CASE WHEN (AlertActions.WarningAction & 0x08) = 0x08 THEN 'Voice' END,
              CASE WHEN (AlertActions.WarningAction & 0x10) = 0x10 THEN 'Fax' END,
              CASE WHEN (AlertActions.WarningAction & 0x20) = 0x20 THEN 'Print' END,
              CASE WHEN (AlertActions.WarningAction & 0x40) = 0x40 THEN 'File' END,
              CASE WHEN (AlertActions.WarningAction & 0x80) = 0x80 THEN 'Messenger' END,
              CASE WHEN (AlertActions.WarningAction & 0x100) = 0x100 THEN 'Instant Messenger' END,
              CASE WHEN (AlertActions.WarningAction & 0x200) = 0x200 THEN 'Script' END,
              CASE WHEN (AlertActions.WarningAction & 0x400) = 0x400 THEN 'Ticket' END,
              CASE WHEN (AlertActions.WarningAction & 0x800) = 0x800 THEN 'Raise Warning' END,
              CASE WHEN (AlertActions.WarningAction & 0x1000) = 0x1000 THEN 'Raise Information' END,
              CASE WHEN (AlertActions.WarningAction & 0x2000) = 0x2000 THEN 'ConnectWise Ticket' END,
              CASE WHEN (AlertActions.WarningAction & 0x4000) = 0x4000 THEN 'ConnectWise Ticket 2' END,
              CASE WHEN (AlertActions.WarningAction & 0x8000) = 0x8000 THEN 'ConnectWise Opportunity' END,
              CASE WHEN (AlertActions.WarningAction & 0x10000) = 0x10000 THEN 'Ticket Comment' END,
              CASE WHEN (AlertActions.WarningAction & 0x20000) = 0x20000 THEN 'Ticket Response' END,
              CASE WHEN (AlertActions.WarningAction & 0x40000) = 0x40000 THEN 'Custom Alert 4' END,
              CASE WHEN (AlertActions.WarningAction & 0x80000) = 0x80000 THEN 'Custom Alert 5' END) `Warning Action`
  , CONCAT_WS(', ', CASE WHEN (AlertActions.DayOfWeek & 0x01) = 0x01 THEN 'Sunday' END,
              CASE WHEN (AlertActions.DayOfWeek & 0x02) = 0x02 THEN 'Monday' END,
              CASE WHEN (AlertActions.DayOfWeek & 0x04) = 0x04 THEN 'Tuesday' END,
              CASE WHEN (AlertActions.DayOfWeek & 0x08) = 0x08 THEN 'Wednesday' END,
              CASE WHEN (AlertActions.DayOfWeek & 0x10) = 0x10 THEN 'Thursday' END,
              CASE WHEN (AlertActions.DayOfWeek & 0x20) = 0x20 THEN 'Friday' END,
              CASE WHEN (AlertActions.DayOfWeek & 0x40) = 0x40 THEN 'Saturday' END)                 `Days`
  , AlertActions.TimeStart                                              AS                          `Start Time`
  , AlertActions.TimeEnd                                                AS                          `End Time`
  , IF(AlertActions.ContactId < 0, IF(AlertActions.ContactId = -1, 'Location Contact', 'Computer Contact'),
       CONCAT(Contacts.Firstname, ' ', Contacts.Lastname))              AS                          `Contact`
  , AlertActions.UserID                                                 AS                          `User`
  , IF(AlertActions.Trump = 0, 'False', 'True')                         AS                          `Trump`
  , AlertActions.Message                                                AS                          `Message`
  , CONCAT_WS(' - ', Scripts.ScriptId, Scripts.ScriptName)              AS                          `ScriptName`
FROM alerttemplate AS `AlertTemplates`
  LEFT JOIN alerttemplates AS `AlertActions` ON AlertTemplates.AlertActionID = AlertActions.AlertActionID
  LEFT JOIN contacts AS `Contacts` ON AlertActions.ContactID = Contacts.ContactID
  LEFT JOIN lt_scripts AS `Scripts` ON AlertActions.ScriptID = Scripts.ScriptId
ORDER BY TemplateName