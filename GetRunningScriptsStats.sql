USE labtech;

/*

 Description    : Get all Ticket Categories for the ConnectWise (CW) plugin, along with their Ticket Category mappings from LabTech.  Found on ##labtech.
 Source URL     : http://github.com/covenanttechnologysolutions/labtech-sql-library

 Returns        :
    TOTAL_RUNNING_SCRIPTS     :   Count of all running scripts
    Run_Script_ID             :   Script ID of highest count running script
    Run_ScriptID_Count        :   Number of Run_Script_ID scripts running
    TOTAL_WAITING_SCRIPTS     :   Count of all waiting scripts
    Waiting_ScriptsID         :   Script ID of highest count running script
    Waiting_ScriptID_Count    :   Number of Waiting_ScriptsID scripts waiting
    TOTAL_PENDING_SCRIPTS     :   Count of all pending scripts
    Pending_ScriptsID         :   Script ID of highest count pending script
    Pending_ScriptID_Count    :   Number of Pending_ScriptsID scripts pending

 Tested Versions:
  LabTech 2013.1, 10.0

 */

SELECT
    (SELECT COUNT(*) AS total
     FROM runningscripts
       JOIN computers USING (computerid)
     WHERE Running = 1)                                                               AS TOTAL_RUNNING_SCRIPTS
  , (SELECT Run_ScriptID
     FROM (SELECT
               scriptID        AS Run_ScriptID
             , COUNT(scriptID) AS Run_ScriptID_Count
           FROM runningscripts
           GROUP BY scriptID
           ORDER BY Run_ScriptID_Count DESC
           LIMIT 1) AS r)                                                             AS Run_Script_ID
  , (SELECT Run_ScriptID_Count
     FROM (SELECT
               scriptID        AS Run_ScriptID
             , COUNT(scriptID) AS Run_ScriptID_Count
           FROM runningscripts
           GROUP BY scriptID
           ORDER BY Run_ScriptID_Count DESC
           LIMIT 1) AS rct)                                                           AS Run_ScriptID_Count
  , (SELECT COUNT(*) AS total
     FROM runningscripts
       JOIN computers USING (computerid)
     WHERE Running = 0 AND TIMESTAMPDIFF(SECOND, Computers.Lastcontact, NOW()) < 300) AS TOTAL_WAITING_SCRIPTS
  , (SELECT Waiting_ScriptsID
     FROM (SELECT
               scriptID        AS Waiting_ScriptsID
             , COUNT(scriptID) AS Waiting_ScriptID_Count
           FROM runningscripts
             JOIN computers USING (computerid)
           WHERE Running = 0 AND TIMESTAMPDIFF(SECOND, Computers.Lastcontact, NOW()) < 300
           GROUP BY Waiting_ScriptsID
           ORDER BY Waiting_ScriptID_Count DESC
           LIMIT 1) AS WS)                                                            AS Waiting_ScriptsID
  , (SELECT Waiting_ScriptID_Count
     FROM (SELECT
               scriptID        AS Waiting_ScriptsID
             , COUNT(scriptID) AS Waiting_ScriptID_Count
           FROM runningscripts
             JOIN computers USING (computerid)
           WHERE Running = 0 AND TIMESTAMPDIFF(SECOND, Computers.Lastcontact, NOW()) < 300
           GROUP BY Waiting_ScriptsID
           ORDER BY Waiting_ScriptID_Count DESC
           LIMIT 1) AS WS)                                                            AS Waiting_ScriptID_Count
  , (SELECT COUNT(*) AS total
     FROM runningscripts
       JOIN computers USING (computerid)
     WHERE Running = 0 AND TIMESTAMPDIFF(SECOND, Computers.Lastcontact, NOW()) > 300) AS TOTAL_PENDING_SCRIPTS
  , (SELECT Pending_ScriptsID
     FROM (SELECT
               scriptID        AS Pending_ScriptsID
             , COUNT(scriptID) AS Pending_ScriptID_Count
           FROM runningscripts
             JOIN computers USING (computerid)
           WHERE Running = 0 AND TIMESTAMPDIFF(SECOND, Computers.Lastcontact, NOW()) > 300
           GROUP BY Pending_ScriptsID
           ORDER BY Pending_ScriptID_Count DESC
           LIMIT 1) AS WS)                                                            AS Pending_ScriptsID
  , (SELECT Pending_ScriptID_Count
     FROM (SELECT
               scriptID        AS Pending_ScriptsID
             , COUNT(scriptID) AS Pending_ScriptID_Count
           FROM runningscripts
             JOIN computers USING (computerid)
           WHERE Running = 0 AND TIMESTAMPDIFF(SECOND, Computers.Lastcontact, NOW()) > 300
           GROUP BY Pending_ScriptsID
           ORDER BY Pending_ScriptID_Count DESC
           LIMIT 1) AS WS)                                                            AS Pending_ScriptID_Count