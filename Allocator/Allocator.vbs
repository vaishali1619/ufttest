'#######################################################################################################################
'Script Description		: Allocator Script to manage the batch execution of test cases
'Test Tool/Version		: HP Quick Test Professional 11+
'Test Tool Settings		: N.A.
'Application Automated	: N.A.
'Author					: Cognizant
'Date Created			: 06/12/2012
'#######################################################################################################################
Option Explicit	'Forcing Variable declarations

Dim gobjAllocator: Set gobjAllocator = New Allocator

'Associate required libraries
Dim gobjFso, gobjMyFile
Dim gstrRelativePath

Set gobjFso = CreateObject("Scripting.FileSystemObject")
gstrRelativePath = gobjFso.GetParentFolderName(WScript.ScriptFullName)

Set gobjMyFile = gobjFso.OpenTextFile(gstrRelativePath & "\Support Libraries\Framework_Reporting\ReportClasses.vbs", 1)	' 1 - For Reading
Execute gobjMyFile.ReadAll()

Set gobjMyFile = gobjFso.OpenTextFile(gstrRelativePath & "\Support Libraries\Framework_Reporting\ReportTypeClasses.vbs", 1)
Execute gobjMyFile.ReadAll()

Set gobjMyFile = gobjFso.OpenTextFile(gstrRelativePath & "\Support Libraries\Framework_Utilities\ExcelDataAccess.vbs", 1)
Execute gobjMyFile.ReadAll()

Set gobjMyFile = gobjFso.OpenTextFile(gstrRelativePath & "\Support Libraries\Framework_Utilities\GeneralUtility.vbs", 1)
Execute gobjMyFile.ReadAll()

Set gobjMyFile = gobjFso.OpenTextFile(gstrRelativePath & "\Support Libraries\Framework_Core\FrameworkParameters.vbs", 1)
Execute gobjMyFile.ReadAll()

Set gobjMyFile = gobjFso.OpenTextFile(gstrRelativePath & "\Support Libraries\Framework_Core\Settings.vbs", 1)
Execute gobjMyFile.ReadAll()

Set gobjMyFile = gobjFso.OpenTextFile(gstrRelativePath & "\Support Libraries\Framework_Core\TimeStamp.vbs", 1)
Execute gobjMyFile.ReadAll()

Set gobjMyFile = Nothing
Set gobjFso = Nothing

'#######################################################################################################################
'Class Description		: Class to manage the batch execution of test cases
'Author					: Cognizant
'Date Created			: 23/07/2012
'#######################################################################################################################
Class Allocator
	Private m_intTestBatchStatus, m_blnStopExecution
	Private m_dtmOverallStartTime, m_dtmOverallEndTime
	Private m_objQtpApp
	Private m_arrQtpAddins
	Private m_blnRelaunchQtpIfOpen, m_blnCloseQtpAfterExecution, m_blnAddFrameworkPathToQtpFolders
	Private m_blnAutoAssociateAddins
	
	
	'###################################################################################################################
	Public Property Let QtpAddins(arrQtpAddins)
		m_arrQtpAddins = arrQtpAddins
	End Property
	'###################################################################################################################
	
	'###################################################################################################################
	Public Property Let RelaunchQtpIfOpen(blnRelaunchQtpIfOpen)
		m_blnRelaunchQtpIfOpen = blnRelaunchQtpIfOpen
	End Property
	'###################################################################################################################
	
	'###################################################################################################################
	Public Property Let CloseQtpAfterExecution(blnCloseQtpAfterExecution)
		m_blnCloseQtpAfterExecution = blnCloseQtpAfterExecution
	End Property
	'###################################################################################################################
	
	'###################################################################################################################
	Public Property Let AddFrameworkPathToQtpFolders(blnAddFrameworkPathToQtpFolders)
		m_blnAddFrameworkPathToQtpFolders = blnAddFrameworkPathToQtpFolders
	End Property
	'###################################################################################################################
	
	'###################################################################################################################
	Public Property Let AutoAssociateAddins(blnAutoAssociateAddins)
		m_blnAutoAssociateAddins = blnAutoAssociateAddins
	End Property
	'###################################################################################################################
	
	
	'###################################################################################################################
	Private Sub Class_Initialize()
		Set m_objQtpApp = CreateObject("QuickTest.Application")
		
		m_intTestBatchStatus = 0
		m_blnStopExecution = False
		m_blnRelaunchQtpIfOpen = True
		m_blnCloseQtpAfterExecution = True
		m_blnAddFrameworkPathToQtpFolders = True
		m_blnAutoAssociateAddins = True
	End Sub
	'###################################################################################################################
	
	'###################################################################################################################
	'Function Description	: Function to launch QTP with the required add-ins
	'Input Parameters		: None
	'Return Value			: None
	'Author					: Cognizant
	'Date Created			: 24/04/2012
	'###################################################################################################################
	Public Sub LaunchQtp()
		If m_objQtpApp.Launched Then
			If m_blnRelaunchQtpIfOpen Then
				m_objQtpApp.Quit()
				OpenQtpWithAddins()
			Else
				m_objQtpApp.Visible = True
				m_objQtpApp.WindowState  = "Normal"
			End If
		Else
			OpenQtpWithAddins()
		End If
	End Sub
	'###################################################################################################################
	
	'###################################################################################################################
	Private Sub OpenQtpWithAddins()
		If Not IsArray(m_arrQtpAddins) Then
			Err.Raise 6001, "Allocator", "The list of add-ins to be loaded is not specified!"
		End If
		
		'Load required add-ins in QTP
		Dim blnActivateOK, strError
		blnActivateOK = m_objQtpApp.SetActiveAddins(m_arrQtpAddins, strError)
		If Not blnActivateOK Then	'If a problem occurs while loading the add-ins
			Err.Raise 6002, "Allocator", strError
		End If
		
		'Open QTP with the required add-ins loaded
		m_objQtpApp.Launch()
		m_objQtpApp.Visible = True
	End Sub
	'###################################################################################################################
	
	'###################################################################################################################
	'Function Description	: Function to set general QTP options as required
	'Input Parameters		: None
	'Return Value			: None
	'Author					: Cognizant
	'Date Created			: 24/09/2010
	'###################################################################################################################
	Public Sub SetQtpOptions()
		m_objQtpApp.Options.Run.ViewResults = False
		'm_objQtpApp.Options.Run.ImageCaptureForTestResults = "OnError"
		'm_objQtpApp.Options.Run.MovieCaptureForTestResults = "Never"
		'm_objQtpApp.Options.Run.RunMode = "Fast"
	End Sub
	'###################################################################################################################
	
	'###################################################################################################################
	'Function Description	: Function to set relative path
	'Input Parameters		: None
	'Return Value			: None
	'Author					: Cognizant
	'Date Created			: 24/04/2012
	'###################################################################################################################
	Public Sub SetRelativePath()
		Dim objFso : Set objFso = CreateObject("Scripting.FileSystemObject")
		gobjFrameworkParameters.RelativePath = objFso.GetParentFolderName(WScript.ScriptFullName)
		Set objFso = Nothing
		
		If m_blnAddFrameworkPathToQtpFolders Then
			AddPathToFoldersList gobjFrameworkParameters.RelativePath
		End If
	End Sub
	'###################################################################################################################
	
	'###################################################################################################################
	Private Sub AddPathToFoldersList(strPath)
		If m_objQtpApp.Folders.Find(strPath) <> -1 Then	' If the folder is already found in the collection
			m_objQtpApp.Folders.Remove strPath
		End If
		m_objQtpApp.Folders.Add strPath, 1	' Add the folder to the collection in position 1
	End Sub
	'###################################################################################################################
	
	'###################################################################################################################
	'Function Description	: Function to initialize the test batch execution
	'Input Parameters		: None
	'Return Value			: None
	'Author					: Cognizant
	'Date Created			: 24/04/2012
	'###################################################################################################################
	Public Sub InitializeTestBatch()
		m_dtmOverallStartTime = Now()
		
		If WScript.Arguments.Count > 0 Then
			gobjSettings.SetValue "RunConfiguration", WScript.Arguments.Item(0)
			gobjReportSettings.ReportPath = WScript.Arguments.Item(1)
		End If
		
		gobjFrameworkParameters.RunConfiguration = gobjSettings.GetValue("RunConfiguration")
	End Sub
	'###################################################################################################################
	
	'###################################################################################################################
	'Function Description	: Function to initialize summary report
	'Input Parameters		: None
	'Return Value			: None
	'Author					: Cognizant
	'Date Created			: 03/05/2012
	'###################################################################################################################
	Public Sub InitializeSummaryReport()
		InitializeReportSettings()
		
		gobjReport.InitializeReport()
		gobjReport.InitializeResultSummary()
		gobjReport.AddResultSummaryHeading gobjReportSettings.ProjectName + " - " + "Automation Execution Result Summary"
		gobjReport.AddResultSummarySubHeading "Date & Time", ": " & Now(), _
												"On Error", ": " & gobjSettings.GetValue("OnError")
		gobjReport.AddResultSummaryTableHeadings()
	End Sub
	'###################################################################################################################
	
	'###################################################################################################################
	Private Sub InitializeReportSettings()
		If gobjReportSettings.ReportPath = "" Then
			gobjReportSettings.ReportPath = gobjTimeStamp.GetInstance()
		End If
		gobjReportSettings.ProjectName = gobjSettings.GetValue("ProjectName")
		gobjReportSettings.ReportTheme = gobjSettings.GetValue("ReportsTheme")
		gobjReportSettings.ExcelReport = gobjSettings.GetValue("ExcelReport")
		gobjReportSettings.HtmlReport = gobjSettings.GetValue("HtmlReport")
		gobjReportSettings.LinkTestLogsToSummary = True
	End Sub
	'###################################################################################################################
	
	'###################################################################################################################
	'Function Description	: Function to execute the Test Batch Run
	'Input Parameters		: None
	'Return Value			: None
	'Author					: Cognizant
	'Date Created			: 27/04/2006
	'###################################################################################################################
	Public Sub DriveBatchExecution()
		Dim arrTestInstancesToRun, intRowCount
		Dim dtmStartTime, dtmEndTime, strExecutionTime
		Dim strTestStatus
		
		arrTestInstancesToRun = GetRunInfo()
		
		For intRowCount = 0 to Ubound(arrTestInstancesToRun, 2)
			dtmStartTime = Now()
			strTestStatus = InvokeTestScript(arrTestInstancesToRun(0, intRowCount), _
												arrTestInstancesToRun(1, intRowCount), _
												arrTestInstancesToRun(4, intRowCount), _
												arrTestInstancesToRun(5, intRowCount), _
												arrTestInstancesToRun(6, intRowCount))
			
			If strTestStatus = "Failed" Then
				m_intTestBatchStatus = 1	'Any non-zero outcome indicates a failure in vbscript
			End If
			
			dtmEndTime = Now()
			strExecutionTime = gobjUtil.GetTimeDifference(dtmStartTime, dtmEndTime)
			gobjReport.UpdateResultSummary arrTestInstancesToRun(0, intRowCount), _
											arrTestInstancesToRun(1, intRowCount), _
											arrTestInstancesToRun(2, intRowCount), _
											strExecutionTime, strTestStatus
		Next
	End Sub
	'###################################################################################################################
	
	'###################################################################################################################
	Private Function GetRunInfo()
		gobjExcelDataAccess.DatabasePath = gobjFrameworkParameters.RelativePath
		gobjExcelDataAccess.DatabaseName = "Run Manager"
		gobjExcelDataAccess.Connect()
		
		Dim strSheetName, strQuery, objTestData
		strSheetName = gobjFrameworkParameters.RunConfiguration
		Set objTestData = CreateObject("ADODB.Recordset")
		objTestData.CursorLocation = 3
		strQuery = "SELECT * from [" & strSheetName & "$] where Execute = 'Yes'"
		Set objTestData = gobjExcelDataAccess.ExecuteQuery(strQuery)
		gobjExcelDataAccess.Disconnect()
		
		If objTestData.RecordCount > 0 Then
			GetRunInfo = objTestData.GetRows()
		Else
			Err.Raise 6003, "Allocator", "No test cases flagged for execution in the specified run configuration!"
		End If
		
		objTestData.Close
		Set objTestData = Nothing
	End Function
	'###################################################################################################################
	
	'###################################################################################################################
	Private Function InvokeTestScript(strTestScenario, strTestCase, strIterationMode, intStartIteration, intEndIteration)
		Dim strTestStatus
		If m_blnStopExecution Then
			strTestStatus = "Aborted"
			gobjReportSettings.LinkTestLogsToSummary = False
		Else
			LoadScript strTestScenario, strTestCase
			
			Dim objQtpParamDefns	'As QuickTest.ParameterDefinitions
			Dim objQtpParams	'As QuickTest.Parameters
			Dim objQtpParam	'As QuickTest.Parameter
			Set objQtpParamDefns = m_objQtpApp.Test.ParameterDefinitions
			Set objQtpParams = objQtpParamDefns.GetParameters()
			
			Set objQtpParam = objQtpParams.Item("IterationMode")
			objQtpParam.Value = strIterationMode
			Set objQtpParam = objQtpParams.Item("StartIteration")
			If IsNull (intStartIteration) Then
				intStartIteration = 1
			End If
			objQtpParam.Value = intStartIteration
			
			Set objQtpParam = objQtpParams.Item("EndIteration")
			If IsNull (intEndIteration) Then
				intEndIteration = 1
			End If
			objQtpParam.Value = intEndIteration
			
			Set objQtpParam = objQtpParams.Item("ReportPath")
			objQtpParam.Value = gobjReportSettings.ReportPath
			
			'Create a separate folder for results of each test case
			Dim objFso, objResultsFolder
			Set objFso = CreateObject("Scripting.FileSystemObject")
			Set objResultsFolder = objFso.CreateFolder(gobjReportSettings.ReportPath & "\QTP Results\" &_
																		strTestScenario & "_" & strTestCase)
			
			'Run the test with changed results options and parameters
			Dim objQtpResultsOpt: Set objQtpResultsOpt = CreateObject("QuickTest.RunResultsOptions")
			objQtpResultsOpt.ResultsLocation = objResultsFolder
			m_objQtpApp.Test.Run objQtpResultsOpt, True, objQtpParams
			
			'Read the output parameter and the test status
			Set objQtpParam = objQtpParams.Item("StopExecution")
			m_blnStopExecution = objQtpParam.Value
			strTestStatus = m_objQtpApp.Test.LastRunResults.Status
			
			'Release all objects
			Set objQtpParam = Nothing
			Set objQtpParams = Nothing
			Set objQtpParamDefns = Nothing
			Set objQtpResultsOpt = Nothing
			Set objResultsFolder = Nothing
			Set objFso = Nothing
		End If
		
		InvokeTestScript = strTestStatus
	End Function
	'###################################################################################################################
	
	'###################################################################################################################
	Private Sub LoadScript(strTestScenario, strTestCase)
		m_objQtpApp.Open gobjFrameworkParameters.RelativePath & "\Test Scripts\" & strTestScenario & "\" & strTestCase
		
		If m_blnAutoAssociateAddins Then
			AssociateAddins()
		End If
		
		'If m_blnAutoAssociateRecoveryScenarios Then
			'AssociateRecoveryScenarios()
		'End If
	End Sub
	'###################################################################################################################
	
	'###################################################################################################################
	Private Sub AssociateAddins()
		If Not IsArray(m_arrQtpAddins) Then
			Err.Raise 6001, "Allocator", "The list of add-ins to be loaded is not specified!"
		End If
		
		Dim blnAddinsAssociated, strError
		blnAddinsAssociated = m_objQtpApp.Test.SetAssociatedAddins(m_arrQtpAddins, strError)
		If Not blnAddinsAssociated Then	'If a problem occurs while associating the add-ins
			Err.Raise 6004, "Allocator", strError
		End If
	End Sub
	'###################################################################################################################
	
	'###################################################################################################################
	Private Sub AssociateRecoveryScenarios()
		Dim objQtpSettings, objQtpTestRecovery
		Set objQtpSettings = m_objQtpApp.Test.Settings
		Set objQtpTestRecovery = objQtpSettings.Recovery
		objQtpTestRecovery.RemoveAll
		
		'Associate required recovery scenarios
		objQtpTestRecovery.Add "Recovery Scenarios\MyRecovery.qrs", "ObjNotFound"
		objQtpTestRecovery.Add "Recovery Scenarios\MyRecovery.qrs", "Any Error"
		objQtpTestRecovery.Enabled = True
		
		'Release all objects
		Set objQtpTestRecovery = Nothing
		Set objQtpSettings = Nothing
	End Sub
	'###################################################################################################################
	
	'###################################################################################################################
	'Function Description	: Function to do the wrap-up activities after completing the test batch execution
	'Input Parameters		: None
	'Return Value			: None
	'Author					: Cognizant
	'Date Created			: 10/07/2011
	'###################################################################################################################
	Public Sub WrapUp()
		m_objQtpApp.Test.Close()
		
		m_dtmOverallEndTime = Now()
		CloseSummaryReport()
		
		If m_blnCloseQtpAfterExecution Then
			m_objQtpApp.Quit()
		End If
		Set m_objQtpApp = Nothing
		
		If WScript.Arguments.Count = 0 Then
			LaunchHtmlSummaryReport()
		Else
			WScript.Quit m_intTestBatchStatus
		End If
	End Sub
	'###################################################################################################################
	
	'###################################################################################################################
	Private Sub CloseSummaryReport()
		Dim strTotalExecutionTime
		strTotalExecutionTime = gobjUtil.GetTimeDifference(m_dtmOverallStartTime, m_dtmOverallEndTime)
		gobjReport.AddResultSummaryFooter(strTotalExecutionTime)
	End Sub
	'###################################################################################################################
	
	'###################################################################################################################
	Private Sub LaunchHtmlSummaryReport()
		Dim objShell
		If gobjReportSettings.HtmlReport Then
			Set objShell = CreateObject("WScript.Shell")
			objShell.Run """" & gobjReportSettings.ReportPath & "\Html Results\Summary.html"""
			Set objShell = Nothing
		End If
	End Sub
	'###################################################################################################################
	
End Class
'#######################################################################################################################