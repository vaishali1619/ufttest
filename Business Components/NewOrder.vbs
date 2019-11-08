'#######################################################################################################################
'Script Description		: NewOrder Business Components
'Test Tool/Version		: HP Quick Test Professional 11+
'Test Tool Settings		: N.A.
'Application Automated	: Flight Application
'Author					: Cognizant
'Date Created			: 30/07/2008
'#######################################################################################################################
Option Explicit	'Forcing Variable declarations

'#######################################################################################################################
'Function Description   : Function to activate (initialize) the flight window
'Entry Point			: Logged into the application	
'Exit Point				: New order initialized
'Input Parameters 		: None
'Return Value    		: None
'Author					: Cognizant
'Date Created			: 30/07/2008
'Status					: Completed
'#######################################################################################################################
Sub InitializeOrder()
	With Window("Flight Reservation")
		.Activate
		.WinButton("NewOrder").Click
	End With
	
	gobjReport.UpdateTestLog "Initialize Order", "Initializing a new order", "Done"
End Sub
'#######################################################################################################################

'#######################################################################################################################
'Function Description   : Function to insert a new order
'Entry Point			: Logged into the application; New order initialized	
'Exit Point				: New order inserted
'Input Parameters 		: None
'Return Value    		: None
'Author					: Cognizant
'Date Created			: 30/07/2008
'Status					: Completed
'#######################################################################################################################
Sub InsertOrder()
	With Window("Flight Reservation")
		.WinEdit("Date of Flight:").Set gobjDataTable.GetData("NewOrder_Data", "Date_of_Flight")
		.WinEdit("Date of Flight:").Type  micTab
		.WinComboBox("Fly From:").Select gobjDataTable.GetData("NewOrder_Data", "Fly_From")
		.WinComboBox("Fly To:").Select gobjDataTable.GetData("NewOrder_Data", "Fly_To")
		.WinButton("FLIGHT").Click
		With .Dialog("Flights Table")
			.WinList("From").Select 0	'Select the first available flight
			.WinButton("OK").Click
		End With
		.Activate
		.WinEdit("Name:").Set gobjDataTable.GetData("NewOrder_Data", "Name")
		.WinRadioButton(gobjDataTable.GetData("NewOrder_Data", "Class")).Set
		.WinEdit("Tickets:").SetSelection 0,1
		.WinEdit("Tickets:").Set gobjDataTable.GetData("NewOrder_Data", "nTickets")
		.WinButton("Insert Order").Click
		.Activate
	End With
	
	gobjReport.UpdateTestLog "Insert Order", "Inserting a new order", "Screenshot"
End Sub
'#######################################################################################################################

'#######################################################################################################################
'Function Description   : Function to verify whether the order was inserted successfully
'Entry Point			: New order inserted
'Exit Point				: New order insertion verified
'Input Parameters 		: None
'Return Value    		: None
'Author					: Cognizant
'Date Created			: 30/07/2008
'Status					: Completed
'#######################################################################################################################
Sub VerifyOrderInserted()
	Dim blnCheckPoint
	blnCheckPoint = Window("Flight Reservation").WinEdit("Order Status").WaitProperty ("text", "Insert Done...", 10000)
	If blnCheckPoint = false Then
		gobjReport.UpdateTestLog "Verify Insert", "Order not inserted successfully", "Fail"
	Else
		gobjReport.UpdateTestLog "Verify Insert", "Order inserted successfully", "Pass"
		Dim intOrderNumber
		intOrderNumber = Window("Flight Reservation").WinEdit("Order No:").GetROProperty("text")
		gobjDataTable.PutData "NewOrder_Data", "Order_No", intOrderNumber
	End If
End Sub
'#######################################################################################################################