'#######################################################################################################################
'Script Description		: Driver class for the framework
'Test Tool/Version		: HP Quick Test Professional 11+
'Test Tool Settings		: N.A.
'Application Automated	: N.A.
'Author					: Cognizant
'Date Created			: 21/11/2012
'#######################################################################################################################
Option Explicit	'Forcing Variable declarations

Dim gobjDriverScript: Set gobjDriverScript = New DriverScript

'#######################################################################################################################
'Class Description		: Driver class which encapsulates the core logic of the CRAFT framework
'Author					: Cognizant
'Date Created			: 09/11/2012
'#######################################################################################################################
Class DriverScript
	
	Private m_dtmStartTime, m_dtmEndTime
	Private m_intCurrentIteration, m_intCurrentSubIteration
	Private m_arrBusinessFlowData()
	
	
	'###################################################################################################################
	'Function Description	: Function to drive the test execution
	'Input Parameters		: None
	'Return Value			: None
	'Author					: Cognizant
	'Date Created			: 11/10/2012
	'###################################################################################################################
	Public Sub DriveTestExecution()
		Startup()
		InitializeTestIterations()
		InitializeTestReport()
		InitializeDataTable()
		
		InitializeBusinessFlow()
		ExecuteTestIterations()
		
		WrapUp()
	End Sub
	'###################################################################################################################
	
	'###################################################################################################################
	Private Sub Startup()
		m_dtmStartTime = Now()
		
		LoadSupportLibraries()
		SetDefaultTestParameters()
		
		LoadFunctionalLibraries()
		LoadObjectRepositories()
	End Sub
	'###################################################################################################################
	
	'###################################################################################################################
	Private Sub LoadSupportLibraries()
		LoadFunctionLibrary "Support Libraries\Framework_Core\TestParameters.vbs"
		
		LoadFunctionLibrary "Support Libraries\Framework_DataTable\CraftDataTable.vbs"
		
		LoadFunctionLibrary "Support Libraries\Framework_Reporting\ReportClasses.vbs"
		LoadFunctionLibrary "Support Libraries\Framework_Reporting\ReportTypeClasses.vbs"
		
		LoadFunctionLibrary "Support Libraries\Framework_Utilities\ExcelDataAccess.vbs"
		LoadFunctionLibrary "Support Libraries\Framework_Utilities\GeneralUtility.vbs"
		
		Reporter.ReportEvent micDone, "Load support libraries", "Support libraries loaded successfully"
	End Sub
	'###################################################################################################################
	
	'###################################################################################################################
	Private Sub SetDefaultTestParameters()
		gobjTestParameters.CurrentScenario = GetCurrentTestParentFolder()
		gobjTestParameters.CurrentTestcase = Environment.Value("TestName")
		gobjTestParameters.IterationMode = TestArgs("IterationMode")
		gobjTestParameters.StartIteration = TestArgs("StartIteration")
		gobjTestParameters.EndIteration = TestArgs("EndIteration")
	End Sub
	'###################################################################################################################
	
	'###################################################################################################################
	Private Function GetCurrentTestParentFolder()
		Dim strScenarioFolder, arrSplitPath
		strScenarioFolder = Environment.Value("TestDir")
		arrSplitPath = Split(strScenarioFolder,"\")
		GetCurrentTestParentFolder = arrSplitPath(UBound(arrSplitPath)-1)
	End Function
	'###################################################################################################################
	
	'###################################################################################################################
	Private Sub LoadFunctionalLibraries()
		LoadLibrariesInFolder "Business Components"
		LoadLibrariesInFolder "Component Groups"
		
		Reporter.ReportEvent micDone, "Load functional libraries",_
														"Business components and component groups loaded successfully"
	End Sub
	'###################################################################################################################
	
	'###################################################################################################################
	Private Sub LoadLibrariesInFolder(strFolderName)
		Dim objFso, objLibraryFolder, objSubFolder, objFile
		
		Set objFso = CreateObject("Scripting.FileSystemObject")
		Set objLibraryFolder = objFso.GetFolder(PathFinder.Locate(strFolderName))
		
		For Each objSubFolder in objLibraryFolder.SubFolders
			LoadLibrariesInFolder strFolderName & "\" & objSubFolder.Name
		Next
		
		For Each objFile in objLibraryFolder.Files
			If Right(Ucase(objFile.Path), Len("VBS") + 1) = ".VBS" Then
				LoadFunctionLibrary strFolderName & "\" & objFile.Name
			End If
		Next
		
		Set objFile = Nothing
		Set objSubFolder = Nothing
		Set objLibraryFolder = Nothing
		Set objFso = Nothing
	End Sub
	'###################################################################################################################
	
	'###################################################################################################################
	Private Sub LoadObjectRepositories()
		Dim objFso, objRepositoryFolder, objQtpRepositories, objFile
		
		Set objFso = CreateObject("Scripting.FileSystemObject")
		Set objRepositoryFolder = objFso.GetFolder(PathFinder.Locate("Object Repository"))
		
		'RepositoriesCollection.RemoveAll()
		For each objFile in objRepositoryFolder.Files
			If Right(Ucase(objFile.Path), Len("TSR")+1) = ".TSR" Then
				RepositoriesCollection.Add "Object Repository\" & objFile.Name
			End If
		Next
		
		Reporter.ReportEvent micDone, "Load object repositories", "Object repositories loaded successfully"
		
		Set objFile = Nothing
		Set objRepositoryFolder = Nothing
		Set objFso = Nothing
	End Sub
	'###################################################################################################################
	
	'###################################################################################################################
	Private Sub InitializeTestIterations()
		Select Case gobjTestParameters.IterationMode
			Case "RunOneIterationOnly"
				gobjTestParameters.StartIteration = 1
				gobjTestParameters.EndIteration = 1
			Case "RunRangeOfIterations"
				If (gobjTestParameters.StartIteration) > (gobjTestParameters.EndIteration) Then
					Err.Raise 6002, "CRAFT", "StartIteration cannot be greater than EndIteration"
				End If
				If (gobjTestParameters.StartIteration = "") Then
					gobjTestParameters.StartIteration = 1
				End If
				If (gobjTestParameters.EndIteration = "") Then
					gobjTestParameters.EndIteration = 1
				End If
			Case "RunAllIterations"
				gobjExcelDataAccess.DatabasePath = PathFinder.Locate("Datatables")
				gobjExcelDataAccess.DatabaseName = gobjTestParameters.CurrentScenario
				gobjExcelDataAccess.Connect()
				
				Dim strCurrentTestCase, strTestDataSheet, strQuery, objTestData
				strCurrentTestCase = gobjTestParameters.CurrentTestcase
				strTestDataSheet = Environment.Value("DefaultDataSheet")
				Set objTestData = CreateObject("ADODB.Recordset")
				strQuery = "Select Distinct Iteration from [" & strTestDataSheet & "$]" &_
													" where TC_ID='" & strCurrentTestCase & "'"
				Set objTestData = gobjExcelDataAccess.ExecuteQuery(strQuery)
				gobjExcelDataAccess.Disconnect()
				
				Dim intIterationCount
				intIterationCount = objTestData.RecordCount
				If intIterationCount = 0 Then
					Err.Raise 6003, "CRAFT", "The specified test case " & strCurrentTestCase &_
													" is not found in the default test data sheet!"
				End If
				
				'Release all objects
				objTestData.Close
				Set objTestData = Nothing
				
				gobjTestParameters.StartIteration = 1
				gobjTestParameters.EndIteration = intIterationCount
		End Select
		
		m_intCurrentIteration = gobjTestParameters.StartIteration
	End Sub
	'###################################################################################################################
	
	'###################################################################################################################
	Private Sub InitializeTestReport()
		InitializeReportSettings()
		
		gobjReport.InitializeReport()
		gobjReport.InitializeTestLog()
		gobjReport.AddTestLogHeading(gobjReportSettings.ProjectName & " - " &_
										gobjReportSettings.ReportName & " - Automation Execution Results")
		gobjReport.AddTestLogSubHeading "Date & Time",  ": " & Now(), _
										"Iteration Mode", ": " & gobjTestParameters.IterationMode
		gobjReport.AddTestLogSubHeading "Start Iteration", ": " & gobjTestParameters.StartIteration, _
										"End Iteration",  ": " & gobjTestParameters.EndIteration
		gobjReport.AddTestLogTableHeadings()
	End Sub
	'###################################################################################################################
	
	'###################################################################################################################
	Private Sub InitializeReportSettings()
		If TestArgs("ReportPath") = "" Then
			InitializeFrameworkParameters()
			
			LoadFunctionLibrary "Support Libraries\Framework_Core\TimeStamp.vbs"
			gobjReportSettings.ReportPath = gobjTimeStamp.GetInstance()
		Else
			gobjReportSettings.ReportPath = TestArgs("ReportPath")
		End If
		gobjReportSettings.ReportName = gobjTestParameters.CurrentScenario & "_" & gobjTestParameters.CurrentTestcase
		gobjReportSettings.ProjectName = Environment.Value("ProjectName")
		gobjReportSettings.LogLevel = Environment.Value("LogLevel")
		gobjReportSettings.ExcelReport = Environment.Value("ExcelReport")
		gobjReportSettings.HtmlReport = Environment.Value("HtmlReport")
		gobjReportSettings.TakeScreenshotPassedStep = Environment.Value("TakeScreenshotPassedStep")
		gobjReportSettings.TakeScreenshotFailedStep = Environment.Value("TakeScreenshotFailedStep")
		gobjReportSettings.ConsolidateScreenshotsInWordDoc = Environment.Value("ConsolidateScreenshotsInWordDoc")
		gobjReportSettings.LinkScreenshotsToTestLog = True
		gobjReportSettings.ReportTheme = Environment.Value("ReportsTheme")
	End Sub
	'###################################################################################################################
	
	'###################################################################################################################
	Private Sub InitializeFrameworkParameters()
		LoadFunctionLibrary "Support Libraries\Framework_Core\FrameworkParameters.vbs"
		
		Dim objFso: Set objFso = CreateObject("Scripting.FileSystemObject")
		gobjFrameworkParameters.RelativePath = objFso.GetParentFolderName(PathFinder.Locate("Test Scripts"))
		gobjFrameworkParameters.RunConfiguration = Environment.Value("RunConfiguration")
		Set objFso = Nothing
	End Sub
	'###################################################################################################################
	
	'###################################################################################################################
	Private Sub InitializeDataTable()
		Dim strDataTablePath
		strDataTablePath = PathFinder.Locate("Datatables")
		
		If Environment.Value("IncludeTestDataInReport") Then
			Dim objFso : Set objFso = CreateObject("Scripting.FileSystemObject")
			
			Dim strRunTimeDataTablePath
			strRunTimeDataTablePath = gobjReportSettings.ReportPath & "\Datatables"
			If Not objFso.FolderExists(strRunTimeDataTablePath) Then
				objFso.CreateFolder(strRunTimeDataTablePath)
			End If
			
			Dim strRunTimeDataTable
			strRunTimeDataTable = strRunTimeDataTablePath & "\" & gobjTestParameters.CurrentScenario & ".xls"
			If Not objFso.FileExists(strRunTimeDataTable) Then
				Dim strDataTable
				strDataTable = strDataTablePath & "\" & gobjTestParameters.CurrentScenario & ".xls"
				objFso.CopyFile strDataTable, strRunTimeDataTable, True
			End If
			
			Dim strRunTimeCommonDataTable
			strRunTimeCommonDataTable = strRunTimeDataTablePath & "\Common Testdata.xls"
			If Not objFso.FileExists(strRunTimeCommonDataTable) Then
				Dim strCommonDataTable
				strCommonDataTable = strDataTablePath & "\" & "Common Testdata.xls"
				objFso.CopyFile strCommonDataTable, strRunTimeCommonDataTable, True
			End If
			
			Set objFso = Nothing
			
			gobjDataTable.DataTablePath = strRunTimeDataTablePath
			gobjDataTable.CommonDataTablePath = strRunTimeDataTablePath
		Else
			gobjDataTable.DataTablePath = strDataTablePath
			gobjDataTable.CommonDataTablePath = strDataTablePath
		End If
		
		gobjDataTable.DataTableName = gobjTestParameters.CurrentScenario
		gobjDataTable.DataReferenceIdentifier = Environment.Value("DataReferenceIdentifier")
		gobjDataTable.EnableOutputValuesAcrossTestcases = Environment.Value("EnableOutputValuesAcrossTestcases")
	End Sub
	'###################################################################################################################
	
	'###################################################################################################################
	Private Sub InitializeBusinessFlow()
		Dim strBusinessFlowSheet, strCurrentTestCase
		strBusinessFlowSheet = "Business_Flow"
		strCurrentTestCase = gobjTestParameters.CurrentTestcase
		
		gobjExcelDataAccess.DatabasePath = gobjDataTable.DataTablePath
		gobjExcelDataAccess.DatabaseName = gobjDataTable.DataTableName
		gobjExcelDataAccess.Connect()
		
		Dim strQuery, objTestData
		Set objTestData = CreateObject("ADODB.Recordset")
		objTestData.CursorLocation = 3
		strQuery = "Select * from [" & strBusinessFlowSheet & "$] where TC_ID='" & strCurrentTestCase & "'"
		Set objTestData = gobjExcelDataAccess.ExecuteQuery(strQuery)
		gobjExcelDataAccess.Disconnect()
		
		If objTestData.RecordCount = 0 Then
			Err.Raise 6004, "CRAFT", "Testcase '" & strCurrentTestCase & "' not found in the 'Business_Flow' sheet!"
		End If
		
		ReDim m_arrBusinessFlowData(126)	' Maximum size of a record fetched from Excel
		Dim intColumnCount
		For intColumnCount = 1 to (objTestData.Fields.Count - 1)
			If IsNull(objTestData(intColumnCount).Value) Or Trim(objTestData(intColumnCount).Value) = "" Then
				'ReDim Preserve m_arrBusinessFlowData(intColumnCount - 2)
				Exit For
			End If
			m_arrBusinessFlowData(intColumnCount - 1) = objTestData(intColumnCount).Value
		Next
		
		ReDim Preserve m_arrBusinessFlowData(intColumnCount - 2)
		
		'Release all objects
		objTestData.Close
		Set objTestData = Nothing
	End Sub
	'###################################################################################################################
	
	'###################################################################################################################
	Private Sub ExecuteTestIterations()
		Do While m_intCurrentIteration <= gobjTestParameters.EndIteration
			gobjReport.AddTestLogSection "Iteration: " & m_intCurrentIteration
			
			If Instr(Environment.Value("ResultDir"), "TempResults") = 0_
			And Environment.Value("OnError") <> "NextStep" Then
				On Error Resume Next
			End If
			
			ExecuteTestCase()
			
			ExceptionHandler()
			
			m_intCurrentIteration = m_intCurrentIteration + 1
		Loop
	End Sub
	'###################################################################################################################
	
	'###################################################################################################################
	Private Sub ExecuteTestCase()
		If Ubound(m_arrBusinessFlowData) < 0 Then
			Err.Raise 6005, "CRAFT", "The business flow for the testcase '" & strCurrentTestCase & "' is empty!"
		End If
		
		Dim objKeywordDirectory : Set objKeywordDirectory = CreateObject("Scripting.Dictionary")
		
		Dim intCurrentKeywordNum, intKeywordIterations, intCurrentKeywordIteration
		Dim arrCurrentFlowData, strCurrentKeyword
		
		For intCurrentKeywordNum = 0 to UBound(m_arrBusinessFlowData)
			arrCurrentFlowData = Split(m_arrBusinessFlowData(intCurrentKeywordNum), ",")
			strCurrentKeyword = arrCurrentFlowData(0)
			
			If UBound(arrCurrentFlowData) = 0 Then
				intKeywordIterations = 1
			Else
				intKeywordIterations = arrCurrentFlowData(1)
			End If
			
			For intCurrentKeywordIteration = 0 to (intKeywordIterations - 1)
				If objKeywordDirectory.Exists(strCurrentKeyword) Then
					objKeywordDirectory.Item(strCurrentKeyword) = objKeywordDirectory.Item(strCurrentKeyword) + 1
				Else
					objKeywordDirectory.Add strCurrentKeyword, 1
				End If
				m_intCurrentSubIteration = objKeywordDirectory.Item(strCurrentKeyword)		
				
				gobjDatatable.SetCurrentRow gobjTestParameters.CurrentTestCase,_
																m_intCurrentIteration,_
																m_intCurrentSubIteration
				
				Dim strSectionDescription
				If (m_intCurrentSubIteration > 1) Then
					gobjReport.AddTestLogSubSection strCurrentKeyword &_
														" (SubIteration : " & m_intCurrentSubIteration & ")"
				Else
					gobjReport.AddTestLogSubSection strCurrentKeyword
				End If
				
				InvokeBusinessComponent strCurrentKeyword
			Next
		Next
		
		objKeywordDirectory.RemoveAll()
		Set objKeywordDirectory = Nothing
	End Sub	
	'###################################################################################################################
	
	'###################################################################################################################
	Private Sub InvokeBusinessComponent(strCurrentKeyword)
		Execute strCurrentKeyword
	End Sub
	'###################################################################################################################
	
	'###################################################################################################################
	Private Sub ExceptionHandler()
		If (Err.Number <> 0) Then
			'Error Reporting
			Dim strErrorDescription
			strErrorDescription = Err.Description
			If strErrorDescription = "" Then
				strErrorDescription = DescribeResult(Err.Number)
			End If
			gobjReport.UpdateTestLog "Error", strErrorDescription, "Fail"
			
			'Error Response
			If TestArgs("StopExecution") Then
				gobjReport.UpdateTestLog "CRAFT Info", _
											"Test execution terminated by user! All subsequent tests aborted...", "Done"
				
				CustomErrorResponse()
				m_intCurrentIteration = gobjTestParameters.EndIteration
			Else
				Select Case Environment.Value("OnError")
					Case "NextStep"
						gobjReport.UpdateTestLog "CRAFT Info", _
													"Refer QTP Results for full details regarding the error...", "Warning"
					Case "NextIteration"
						gobjReport.UpdateTestLog "CRAFT Info", _
													"Test case iteration terminated by user! " &_
													"Proceeding to next iteration (if applicable)...", "Done"
						CustomErrorResponse()
					Case "NextTestCase"
						gobjReport.UpdateTestLog "CRAFT Info", _
													"Test case terminated by user! " &_
													"Proceeding to next test case (if applicable)...", "Done"
						
						CustomErrorResponse()
						m_intCurrentIteration = gobjTestParameters.EndIteration
					Case "Stop"
						TestArgs("StopExecution") = True
						gobjReport.UpdateTestLog "CRAFT Info", _
													"Test execution terminated by user! " &_
													"All subsequent tests aborted...", "Done"
						
						CustomErrorResponse()
						m_intCurrentIteration = gobjTestParameters.EndIteration
				End Select
			End If
			
			Err.Clear
		End If
	End Sub
	'###################################################################################################################
	
	'###################################################################################################################
	Private Sub CustomErrorResponse()
		gobjReport.AddTestLogSubSection "ErrorResponse"
		
		CloseFlightApp()
	End Sub
	'###################################################################################################################
	
	'###################################################################################################################
	Private Sub WrapUp()
		m_dtmEndTime = Now()
		CloseTestReport()
		
		ExitRun
	End Sub
	'###################################################################################################################
	
	'###################################################################################################################
	Private Sub CloseTestReport()
		Dim strExecutionTime
		strExecutionTime = gobjUtil.GetTimeDifference(m_dtmStartTime, m_dtmEndTime)
		gobjReport.AddTestLogFooter strExecutionTime
		
		If (gobjReportSettings.ConsolidateScreenshotsInWordDoc) Then
			gobjReport.ConsolidateScreenshotsInWordDoc()
		End If
	End Sub
	'###################################################################################################################
	
End Class
'#######################################################################################################################