'#######################################################################################################################
'Script Description		: Common Component Groups
'Test Tool/Version		: HP Quick Test Professional 11+
'Test Tool Settings		: N.A.
'Application Automated	: Flight Application
'Author					: Cognizant
'Date Created			: 08/03/2012
'#######################################################################################################################
Option Explicit	'Forcing Variable declarations

'#######################################################################################################################
'Function Description   : Insert and verify the order inserted
'Entry Point			: Logged into the application	
'Exit Point				: New order insertion verified
'Input Parameters 		: None
'Return Value    		: None
'Author					: Cognizant
'Date Created			: 08/03/2012
'Status					: Completed
'#######################################################################################################################
Sub InsertAndVerifyOrder()
	InitializeOrder()
	InsertOrder()
	VerifyOrderInserted()
End Sub
'#######################################################################################################################

'#######################################################################################################################
'Function Description   : Open an existing order
'Entry Point			: Logged into the application	
'Exit Point				: Specified order opening verified
'Input Parameters 		: None
'Return Value    		: None
'Author					: Cognizant
'Date Created			: 09/03/2012
'Status					: Completed
'#######################################################################################################################
Sub OpenOrderAndVerify()
	OpenExistingOrder()
	VerifyOrderOpened()
End Sub
'#######################################################################################################################