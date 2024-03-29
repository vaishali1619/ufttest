'#######################################################################################################################
'Script Description		: Databaes Business Components
'Test Tool/Version		: HP Quick Test Professional 11+
'Test Tool Settings		: N.A.
'Application Automated	: Putty
'Author					: Cognizant
'Date Created			: 25/06/2015
'#######################################################################################################################
Option Explicit	'Forcing Variable declarations

'#######################################################################################################################
'Function Description   : Function to Trigger Putty
'Input Parameters 		: None
'Return Value    		: None
'Author					: Cognizant
'Date Created			: 02/05/2019
'Status					: Completed
'#######################################################################################################################
Function LaunchPutty()
	Dim Shell
	Set Shell = CreateObject("WScript.Shell")
	Shell.Run "C:\Users\Public\Desktop\putty.exe"
	
	If Window("PuTTY Configuration").Exist Then	
		gobjReport.UpdateTestLog "Putty Launch","Putty Launched Successfully","Pass"
	Else	
		gobjReport.UpdateTestLog "Putty Launch","Putty Launch went Unsuccessfull","Fail"		
	End if
	
	
	
End Function

'#######################################################################################################################
'#######################################################################################################################
'Function Description   : Function to Login Putty
'Input Parameters 		: Host, Port, Connection Type details
'Return Value    		: None
'Author					: Cognizant
'Date Created			: 02/05/2019
'Status					: Completed
'#######################################################################################################################
Function LoginPutty()

	Dim strHostName,strPort,strConnectionType

		strHostName=gobjDataTable.GetData("Login", "HostName")
		strPort= gobjDataTable.GetData("Login", "Port")
		
		Window("PuTTY Configuration").WinEdit("Txt_HostName").Set strHostName
		Window("PuTTY Configuration").WinEdit("Txt_Port").Set strPort
		wait 10
		gobjReport.UpdateTestLog "Putty Login","Putty Login with Host: "&strHostName,"Screenshot"
	
End Function

'#######################################################################################################################
'#######################################################################################################################
'Function Description   : Function to Close Putty
'Input Parameters 		: None
'Return Value    		: None
'Author					: Cognizant
'Date Created			: 02/05/2019
'Status					: Completed
'#######################################################################################################################
Function ClosePutty()

	Window("PuTTY Configuration").WinButton("Btn_Cancel").Click

End Function
'#######################################################################################################################
