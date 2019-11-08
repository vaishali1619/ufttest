'#####################################################################################################################
'Script Description		: Initialization Script
'Test Tool/Version		: HP Quick Test Professional 11+
'Test Tool Settings		: N.A.
'Application Automated	: N.A.
'Author					: Cognizant
'Date Created			: 09/11/2012
'#####################################################################################################################
Option Explicit	'Forcing Variable declarations

'Associate required libraries
Dim gobjFso, gobjMyFile
Dim gstrRelativePath

Set gobjFso = CreateObject("Scripting.FileSystemObject")
gstrRelativePath = gobjFso.GetParentFolderName(WScript.ScriptFullName)

Set gobjMyFile = gobjFso.OpenTextFile(gstrRelativePath & "\Allocator\Allocator_QC.vbs", 1) ' 1 - For Reading
Execute gobjMyFile.ReadAll()

Set gobjMyFile = Nothing
Set gobjFso = Nothing

'Setup the required inputs to the Allocator
gobjAllocator.QtpAddins = Array("ActiveX","Visual Basic")
gobjAllocator.RelaunchQtpIfOpen = False
gobjAllocator.CloseQtpAfterExecution = False
gobjAllocator.AddFrameworkPathToQtpFolders = True
gobjAllocator.AutoAssociateAddins = False
gobjAllocator.TestCasesPath = "[ALM] Subject\CRAFT - Flight Application - Updated"
gobjAllocator.TestResourcesFrameworkPath = "C:\ACoE In-house tools\CRAFT - QTP - Flight Application"
gobjAllocator.TestSetPath = "Root\CRAFT - Flight Application - Updated"
gobjAllocator.TestSetName = "Sanity"

'Execute the test batch
On Error Resume Next
ExecuteTestBatch()
If Err.Number <> 0 Then
	WScript.Echo Err.Description
	WScript.Quit Err.Number
End If
'#######################################################################################################################


'#######################################################################################################################
'Function Description	: Function to execute the test batch
'Input Parameters		: None
'Return Value			: None
'Author					: Cognizant
'Date Created			: 09/11/2012
'#######################################################################################################################
Sub ExecuteTestBatch()
	gobjAllocator.LaunchQtp()
	gobjAllocator.SetQtpOptions()
	gobjAllocator.ConnectToQc "<qcurl>", "<username>", "<password>", "<domain>", "<project>"
	gobjAllocator.SetRelativePath()
	gobjAllocator.InitializeTestBatch()
	gobjAllocator.InitializeSummaryReport()
	gobjAllocator.DriveBatchExecution()
	gobjAllocator.WrapUp()
End Sub
'#######################################################################################################################