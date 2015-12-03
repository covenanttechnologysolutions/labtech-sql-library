/*

Description       : Misc snippets.
Source            : IRC Server: Freenode <chat.freenode.net>  Channel: ##labtech

*/

/*
Description       : Top 40 Noisiest Internal Monitors
Authors           : Martyn Keigher
*/
SELECT COUNT(*) AS total,Agentid,Agents.name FROM databasefails JOIN agents USING(agentid) GROUP BY agentid ORDER BY total DESC LIMIT 40;

/*
Description       : Top 40 Noisiest Remote Monitors
Authors           : Martyn Keigher
*/
SELECT Fails,Agents.name,Computers.name FROM h_agents  JOIN agents USING(agentid) JOIN computers USING(computerid) ORDER BY fails DESC LIMIT 40;