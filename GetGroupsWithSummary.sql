/*

Description       : Get summary information for each group in LabTech.
Source URL        : http://github.com/jesseconnr/labtech-sql-library

Tested Versions   :
  MySQL 5.7
  LabTech 10.0

Table Aliases     :
  Groups                - mastergroups
  Searches              - sensorchecks
  MaintWindows          - maintenancewindow
  GroupMembers          - subgroups
  ScheduledScripts      - groupscripts
  InternalMonitors      - groupdagents
  RemoteMonitors        - groupagents
  ExtraDataFields       - extrafield
  ExtraDataFieldValues  - extrafielddata
  GroupTemplate         - templates

*/

SELECT *
FROM
  (SELECT
       CONCAT_WS(' - ', Groups.GroupID, Groups.Name)                     AS `Name`
     , Groups.FullName                                                   AS `Path`
     , Groups.depth                                                      AS `NestDepth`
     , CASE
       WHEN Groups.Master = 0 THEN 'Non Master'
       WHEN Groups.Master = 1 THEN 'Master'
       WHEN Groups.Master = 2 THEN 'Grayed Master'
       ELSE 'Unknown'
       END                                                               AS `MasterType`
     , IFNULL(Searches.Name, '')                                         AS `AutoJoinScript`
     , IF(Groups.LimitToParent = 1, 'True', 'False')                     AS `JoinLimitedToSearch`
     , IFNULL(GroupTemplate.Name, '')                                    AS `AppliedTemplate`
     , IF(GroupTemplate.Name IS NOT NULL, Groups.Priority, '')           AS `AppliedTemplatePriority`
     , CASE
       WHEN Groups.GroupType = 0 THEN 'Original'
       WHEN Groups.GroupType = 1 THEN 'Permissions'
       WHEN Groups.GroupType = 2 THEN 'Exclusions'
       WHEN Groups.GroupType = 3 THEN 'Patching'
       WHEN Groups.GroupType = 4 THEN 'Organizational'
       WHEN Groups.GroupType = 5 THEN 'Monitoring'
       WHEN Groups.GroupType = 6 THEN 'Automation'
       WHEN Groups.GroupType = 7 THEN 'Template'
       ELSE 'Unknown'
       END                                                               AS `Category`
     , IFNULL(MaintWindows.Name, '')                                     AS `MaintenancePlan`
     , IFNULL((SELECT COUNT(*)
               FROM `subgroups` AS GroupMembers
               WHERE GroupMembers.GroupID = Groups.GroupID
               GROUP BY GroupMembers.GroupID), 0)                        AS `MemberCount`
     , IFNULL((SELECT COUNT(*)
               FROM `groupscripts` AS ScheduledScripts
               WHERE ScheduledScripts.GroupID = Groups.GroupID
               GROUP BY ScheduledScripts.GroupID), 0)                    AS `ScheduledScriptCount`
     , IFNULL((SELECT COUNT(*)
               FROM `groupdagents` AS InternalMonitors
               WHERE Groups.GroupID = InternalMonitors.GroupID), 0)      AS `EnabledInternalMonitorsCount`
     , IFNULL((SELECT COUNT(*)
               FROM `groupagents` AS RemoteMonitors
               WHERE RemoteMonitors.GroupID = Groups.GroupID), 0)        AS `RemoteMonitorsCount`

     # MSP Contract Group
     , IFNULL((SELECT IF(ExtraDataFieldValues.Value = 1, 'True', 'False')
               FROM `extrafielddata` AS ExtraDataFieldValues
                 RIGHT JOIN `extrafield` AS ExtraDataFields
                   ON ExtraDataFields.ID = ExtraDataFieldValues.ExtraFieldID
                      AND ExtraDataFields.Name = 'MSP Contract Group'
               WHERE ExtraDataFieldValues.ID = Groups.GroupID), 'False') AS `MSPContractGroup`

     # Patch Contract Group
     , IFNULL((SELECT IF(ExtraDataFieldValues.Value = 1, 'True', 'False')
               FROM `extrafielddata` AS ExtraDataFieldValues
                 RIGHT JOIN `extrafield` AS ExtraDataFields
                   ON ExtraDataFields.ID = ExtraDataFieldValues.ExtraFieldID
                      AND ExtraDataFields.Name = 'Patching Covered Under Contract'
               WHERE ExtraDataFieldValues.ID = Groups.GroupID), 'False') AS `PatchContractGroup`

   FROM `mastergroups` AS Groups
     LEFT JOIN `sensorchecks` AS Searches ON Groups.AutoJoinScript = Searches.SensID
     LEFT JOIN `templates` AS GroupTemplate ON Groups.Template = GroupTemplate.TemplateID
     LEFT JOIN `maintenancewindow` AS MaintWindows ON Groups.MaintenanceID = MaintWindows.MaintenanceID
   ORDER BY `Path` ASC) AS `LabTechGroups`
WHERE
  # LabTechGroups Filtering
  (`AutoJoinScript` != 'No Agents - Auto Join Prevention') # Exclude Container Groups
  AND (`Path` != 'Network Devices' AND `Path` NOT LIKE 'Network Devices.%') # Exclude Network Device Groups
  AND (`Path` != 'Port Management' AND `Path` NOT LIKE 'Port Management.%') # Exclude Port Management Groups
  AND (`Path` != 'All Clients' AND `Path` NOT LIKE 'All Clients.%') # Exclude The 'All Clients' Group
  AND (`Path` != '_System Automation.Windows Updates Patch Window Control' AND
       `Path` NOT LIKE '_System Automation.Windows Updates Patch Window Control.%') # Exclude Patching Groups
