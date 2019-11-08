'#######################################################################################################################
'Script Description		: General Business Components
'Test Tool/Version		: HP Quick Test Professional 11+
'Test Tool Settings		: N.A.
'Application Automated	: Flight Application
'Author					: Cognizant
'Date Created			: 30/07/2008
'#######################################################################################################################
Option Explicit	'Forcing Variable declarations

'#######################################################################################################################
'Function Description   : Function to invoke the Flight Application
'Entry Point			: Nil	
'Exit Point				: Application is invoked
'Input Parameters 		: None
'Return Value    		: None
'Author					: Cognizant
'Date Created			: 30/07/2008
'Status					: Completed
'#######################################################################################################################
Sub InvokeFlightApp()
	gobjReport.UpdateTestLog "Invoke Application", "Invoking application present at " & Environment.Value("ApplicationPath"), "Done"
	
	Dim blnNeedInvoke
	blnNeedInvoke = True
	If Window("Flight Reservation").Exist(1) Then
		Window("Flight Reservation").Close
	Elseif Dialog ("Login").Exist(1) Then
		blnNeedInvoke = False
		gobjReport.UpdateTestLog "Verify Invoke", "Application already invoked", "Pass"
	End If
	
	If (blnNeedInvoke) Then
		On Error Resume Next
		SystemUtil.Run Environment.Value("ApplicationPath")
		Dim intErrorNumber: intErrorNumber = Err.Number
		On Error Goto 0
		
		If intErrorNumber <> 0 Then
			TestArgs("StopExecution") = True	'Super-critical error!
			Err.Raise 7001, "Verify Invoke", "Error while invoking the application!"
		Else
			gobjReport.UpdateTestLog "Verify Invoke", "Application invoked successfully", "Pass"
		End If
	End If
End Sub
'#######################################################################################################################

'#######################################################################################################################
'Function Description   : Function to login to the Flight Application
'Entry Point			: Application is invoked	
'Exit Point				: Logged into the application
'Input Parameters 		: None
'Return Value    		: None
'Author					: Cognizant
'Date Created			: 30/07/2008
'Status					: Completed
'#######################################################################################################################
Sub Login()
	With Dialog("Login")
		.Activate	
		.WinEdit("Agent Name:").Set gobjDatatable.GetData("General_Data", "Agent_Name")
		.WinEdit("Password:").SetSecure gobjDataTable.GetData("General_Data", "Password")
		.WinButton("OK").Click
	End With
	
	gobjReport.UpdateTestLog "Login to the application", "Login credentials entered for user: " &_
															gobjDataTable.GetData("General_Data", "Agent_Name"), "Done"
End Sub
'#######################################################################################################################

'#######################################################################################################################
'Function Description   : Function to verify whether the login was successful
'Entry Point			: Logged into the application	
'Exit Point				: Login verification done
'Input Parameters 		: None
'Return Value    		: None
'Author					: Cognizant
'Date Created			: 30/07/2008
'Status					: Completed
'#######################################################################################################################
Sub VerifyLogin()
	Dim blnCheckPoint
	blnCheckPoint = Window("Flight Reservation").WaitProperty ("text", "Flight Reservation", 10000)
	If blnCheckPoint = false Then
		Err.Raise 7002, "Verify Login", "Login failed"	'Critical error
	Else
		gobjReport.UpdateTestLog "Verify Login", "Login successful", "Pass"
	End If
End Sub
'#######################################################################################################################

'#######################################################################################################################
'Function Description   : Function to close the Flight Application
'Entry Point			: Nil	
'Exit Point				: Application is closed
'Input Parameters 		: None
'Return Value    		: None
'Author					: Cognizant
'Date Created			: 30/07/2008
'Status					: Completed
'#######################################################################################################################
Sub CloseFlightApp()
	SystemUtil.CloseProcessByName "flight4a.exe"
	gobjReport.UpdateTestLog "Close Application", "Application closed successfully", "Done"
End Sub
'#######################################################################################################################
Function fun1()
	msgBox "test"	
	
End Function

Function fun2()
	msgBox "check"
End Function 