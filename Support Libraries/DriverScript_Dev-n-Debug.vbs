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
	
	'###################################################################################################################
	'Function Description	: Function to setup the framework for performing development and debugging activities
	'Input Parameters		: None
	'Return Value			: None
	'Author					: Cognizant
	'Date Created			: 21/08/2013
	'###################################################################################################################
	Public Sub SetUpDevDebugFramework()
		LoadSupportLibraries()
		SetDefaultTestParameters()
		LoadFunctionalLibraries()
		LoadObjectRepositories()
		InitializeTestReport()
		InitializeDataTable()
	End Sub
	'###################################################################################################################
	
	'###################################################################################################################
	Private Sub LoadSupportLibraries()
		LoadFunctionLibrary "Support Libraries\Framework_Core\TestParameters.vbs"
		LoadFunctionLibrary "Support Libraries\Framework_DataTable\CraftDataTable.vbs"
		LoadFunctionLibrary "Support Libraries\Framework_Reporting\ReportClasses.vbs"
		LoadFunctionLibrary "Support Libraries\Framework_Utilities\ExcelDataAccess.vbs"
		
		Reporter.ReportEvent micDone, "Load support libraries", "Support libraries loaded successfully"
	End Sub
	'###################################################################################################################
	
	'###################################################################################################################
	Private Sub SetDefaultTestParameters()
		gobjTestParameters.CurrentScenario = TestArgs("TestScenario")
		gobjTestParameters.CurrentTestcase = TestArgs("TestCase")
	End Sub
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
	Private Sub InitializeTestReport()
		InitializeReportSettings()
		
		gobjReport.InitializeReport()
	End Sub
	'###################################################################################################################
	
	'###################################################################################################################
	Private Sub InitializeReportSettings()
		gobjReportSettings.ReportPath = SetUpTempResultFolder()
		gobjReportSettings.ReportName = gobjTestParameters.CurrentScenario & "_" & gobjTestParameters.CurrentTestcase
		gobjReportSettings.ProjectName = Environment.Value("ProjectName")
		gobjReportSettings.LogLevel = Environment.Value("LogLevel")
		gobjReportSettings.ExcelReport = False	'No Excel Report generated while debugging
		gobjReportSettings.HtmlReport = False	'No HTML Report generated while debugging
		gobjReportSettings.TakeScreenshotPassedStep = Environment.Value("TakeScreenshotPassedStep")
		gobjReportSettings.TakeScreenshotFailedStep = Environment.Value("TakeScreenshotFailedStep")
		gobjReportSettings.ConsolidateScreenshotsInWordDoc = False	'Screenshots not consolidated while debugging
		gobjReportSettings.LinkScreenshotsToTestLog = True
		gobjReportSettings.ReportTheme = Environment.Value("ReportsTheme")
	End Sub
	'###################################################################################################################
	
	'###################################################################################################################
	Private Function SetUpTempResultFolder()
		Dim objFso: Set objFso = CreateObject("Scripting.FileSystemObject")
		
		Dim strTempResultPath	'Using the Windows temp folder to store the results before uploading to QC
		strTempResultPath = objFso.GetSpecialFolder(2) & "\Run_mm-dd-yyyy_hh-mm-ss_XX"
		
		'Create Temp results folder if it does not exist
		If Not objFso.FolderExists (strTempResultPath) Then
			objFso.CreateFolder(strTempResultPath)
		End If
		
		strTempResultPath = strTempResultPath & "\" & gobjTestParameters.CurrentTestcase
		
		'Delete test case level result folder if it already exists
		If objFso.FolderExists(strTempResultPath) Then
			objFso.DeleteFolder(strTempResultPath)
			
			'Wait until the folder is successfully deleted
			Do While(1)
				If Not objFso.FolderExists(strTempResultPath) Then
					Exit Do
				End If
			Loop
		End If
		
		'Create separate folder with the test case name
		objFso.CreateFolder(strTempResultPath)
		
		SetUpTempResultFolder = strTempResultPath
		
		'Release all objects
		Set objFso = Nothing
	End Function
	'###################################################################################################################
	
	'###################################################################################################################
	Private Sub InitializeDataTable()
		gobjDataTable.DataTablePath = PathFinder.Locate("Datatables")
		gobjDataTable.CommonDataTablePath = gobjDataTable.DataTablePath
		gobjDataTable.DataTableName = gobjTestParameters.CurrentScenario
		gobjDataTable.DataReferenceIdentifier = Environment.Value("DataReferenceIdentifier")
		gobjDataTable.EnableOutputValuesAcrossTestcases = Environment.Value("EnableOutputValuesAcrossTestcases")
		gobjDataTable.SetCurrentRow gobjTestParameters.CurrentTestcase, 1, 1	'Assuming the first iteration and sub-iteration while debugging
	End Sub
	'###################################################################################################################
	
End Class
'#######################################################################################################################