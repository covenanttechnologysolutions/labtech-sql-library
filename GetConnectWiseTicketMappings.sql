USE labtech;

/*

 Description    : Get all Ticket Categories for the ConnectWise (CW) plugin, along with their Ticket Category mappings from LabTech.
 Source URL     : http://github.com/covenanttechnologysolutions/labtech-sql-library

 Tested Versions:
  LabTech 2013.1, 10.0
  ConnectWise Plugin v6.0.x, v6.1.x, v6.2.x

 */

SELECT
  ic.CategoryName
  , pcsb.CWServiceBoardname
  , pcsp.CWServicePriorityName
  , pcst.CWServiceTypeName
  , pcsst.CWServiceSubTypeName
  , pcsi.CWServiceItemName
  , pcwt.CWWorkTypeName
FROM plugin_cw_categorymapping pcc
  JOIN infocategory ic ON pcc.CategoryID = ic.ID
  JOIN plugin_cw_serviceboards pcsb ON pcc.CWServiceBoardRecID = pcsb.CWServiceBoardRecID
  JOIN plugin_cw_servicepriorities pcsp ON pcc.CWPriorityRecID = pcsp.CWServicePriorityRecID
  JOIN plugin_cw_servicetypes pcst ON pcc.CWServiceTypeRecID = pcst.CWServiceTypeRecID
  JOIN plugin_cw_servicesubtypes pcsst ON pcc.CWSubTypeRecID = pcsst.CWServiceSubTypeRecID
  JOIN plugin_cw_serviceitems pcsi ON pcc.CWItemRecID = pcsi.CWServiceItemRecID
  JOIN plugin_cw_worktypes pcwt ON pcc.CWWorkTypeRecId = pcwt.CWWorkTypeRecID

ORDER BY ic.CategoryName