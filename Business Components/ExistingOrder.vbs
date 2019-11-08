'#######################################################################################################################
'Script Description		: ExistingOrder Business Components 
'Test Tool/Version		: HP Quick Test Professional 11+
'Test Tool Settings		: N.A.
'Application Automated	: Flight Application
'Author					: Cognizant
'Date Created			: 30/07/2008
'#######################################################################################################################
Option Explicit	'Forcing Variable declarations

'#######################################################################################################################
'Function Description   : Function to open an existing order
'Entry Point			: Logged into the application	
'Exit Point				: Specified order opened
'Input Parameters 		: None
'Return Value    		: None
'Author					: Cognizant
'Date Created			: 19/08/2008
'Status					: Completed
'#######################################################################################################################
Sub OpenExistingOrder()
	With Window("Flight Reservation")
		.Activate
		.WinButton("OpenOrder").Click
		With .Dialog("Open Order")
			.WinCheckBox("Order No.").Set "ON"
			.WinEdit("Edit").Set gobjDataTable.GetData("ExistingOrder_Data", "Order_No")
			.WinButton("OK").Click
		End With
	End With
	
	gobjReport.UpdateTestLog "Open Order", "Opening order corresponding to number: " &_
														gobjDataTable.GetData("ExistingOrder_Data", "Order_No"), "Done"
End Sub
'#######################################################################################################################

'#######################################################################################################################
'Function Description   : Function to verify whether the order was opened successfully
'Entry Point			: Specified order opened
'Exit Point				: Specified order opening verified
'Input Parameters 		: None
'Return Value    		: None
'Author					: Cognizant
'Date Created			: 19/08/2008
'Status					: Completed
'#######################################################################################################################
Sub VerifyOrderOpened()
	If Window("Flight Reservation").Dialog("Open Order").Dialog("Flight Reservations").Exist(1) Then
		Window("Flight Reservation").Dialog("Open Order").Dialog("Flight Reservations").WinButton("OK").Click
		Window("Flight Reservation").Dialog("Open Order").WinButton("Cancel").Click
		
		Err.Raise 7003, "Verify Open", "Order not opened successfully"	'Critical Error
	Else
		gobjReport.UpdateTestLog "Verify Open", "Order opened successfully", "Pass"
	End If
End Sub
'#######################################################################################################################

'#######################################################################################################################
'Function Description   : Function to delete the selected order
'Entry Point			: Logged into the application; Specified order opened
'Exit Point				: Specified order deleted
'Input Parameters 		: None
'Return Value    		: None
'Author					: Cognizant
'Date Created			: 18/08/2008
'Status					: Completed
'#######################################################################################################################
Sub DeleteOpenOrder()
	With Window("Flight Reservation")
		.Activate
		.WinButton("Delete Order").Click
		.Dialog("Flight Reservations").WinButton("Yes").Click
	End With
	
	gobjReport.UpdateTestLog "Delete Order", "Deleting the open order", "Done"
End Sub
'#######################################################################################################################

'#######################################################################################################################
'Function Description   : Function to verify whether the order was deleted successfully
'Entry Point			: Specified order deleted
'Exit Point				: Specified order deletion verified
'Input Parameters 		: None
'Return Value    		: None
'Author					: Cognizant
'Date Created			: 19/08/2008
'Status					: Completed
'#######################################################################################################################
Sub VerifyOrderDeleted()
	Dim blnCheckPoint
	blnCheckPoint = Window("Flight Reservation").WinEdit("Order Status").WaitProperty ("text", "Delete Done...", 10000)
	If blnCheckPoint = False Then
		gobjReport.UpdateTestLog "Verify Delete", "Order not deleted successfully", "Fail"
	Else
		gobjReport.UpdateTestLog "Verify Delete", "Order deleted successfully", "Pass"		
	End If
End Sub
'#######################################################################################################################
