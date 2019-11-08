Option Explicit	'Forcing Variable declarations

''############    FUNCTIONS ##########################################
'fnRandomNumberWithDateTimeStamp
'fnRandomValueGenerator
'fnWaitForObject
'fnWaitForMultipleObjects
'fnWaitForPropertyStatus
'fnExist
'fnVerifyExist
'fnNotExist
'fnVerifyNotExist
'fnDisplayed
'fnVerifyDisplayed
'fnNotDisplayed
'fnVerifyNotDisplayed
'fnCheckBoxEnabled
'fnVerifyCheckBoxEnabled
'fnCheckBoxDisabled
'fnVerifyCheckBoxDisabled
'fnCheckBoxChecked
'fnVerifyCheckBoxChecked
'fnCheckBoxUnChecked
'fnVerifyCheckBoxUnChecked
'fnGetInnerText
'fnGetValue
'fnInString
'fnVerifyInString
'fnNotInString
'fnVerifyNotInString
'fnCompareString
'fnVerifyCompareString
'fnEnabled
'fnVerifyEnabled
'fnDisabled
'fnVerifyDisabled
'fnEditable
'fnVerifyEditable
'fnSendKeys
'fnClick
'fnClickIfExist
'fnClickLinkText
'fnClearText
'fnSetText
'fnSelectCheckBox
'fnUnSelectCheckBox
'fnSelectList
'fnSelectLinkInWebTable
'fnCheckWebElementValueExistInWebTable
'fnPageDown
'fnArrowDown
'fnVerifyFieldLength

'#######################################################################################################################
'Function Name          :	fnRandomNumberWithDateTimeStamp
'Function Description   : 	Generates the random number based on timestamp
'Input Parameters       : 	None
'Return Value               : 	Returns random value with current time stamp
'Author                       : Cognizant
'Date Created              :  
'Status                        : Completed
'#######################################################################################################################
Function fnRandomNumberWithDateTimeStamp()
'Find out the current date and time
Dim sDate : sDate = Day(Now)
Dim sMonth : sMonth = Month(Now)
Dim sYear : sYear = Year(Now)
Dim sHour : sHour = Hour(Now)
Dim sMinute : sMinute = Minute(Now)
Dim sSecond : sSecond = Second(Now)
'Create Random Number
fnRandomNumberWithDateTimeStamp = CStr(sDate & sMonth & sYear & sHour & sMinute & sSecond)
End Function
'#######################################################################################################################
'Function Name          :	fnRandomValueGenerator
'Function Description   : 	Generates the random number of four digit
'Input Parameters       : 	intNumOfDigits
'Return Value               : 	Returns random number
'Author                       : Cognizant
'Date Created              :  
'Status                        : Completed
'#######################################################################################################################
Function fnRandomValueGenerator(intNumOfDigits)
   Dim strResult,i
				For i = 1 to intNumOfDigits
					strResult = strResult & RandomNumber(0,9)
				Next
					fnRandomValueGenerator= CStr(strResult)
End Function
'#######################################################################################################################
'Function Name          :	fnWaitForObject
'Function Description   : 	Waits for an object  for the given time
'Input Parameters       : 	objWindow -  The parent object property, Seconds, Customized obj name for result
'Return Value               : 	None
'Author                       : Cognizant
'Date Created              :  
'Status                        : Completed
'#######################################################################################################################
Function fnWaitForObject(objWindow, intSeconds, strObjName)
	Dim intCurrentCount
	Dim blnRetVal
	intCurrentCount = 1
	blnRetVal = False

	Do
		'Exits the Do Loop if the Condition is satisfied
		If objWindow.Exist(1) Then
			blnRetVal = True
			Exit Do
		End If
		'Waits for 1 sec
		Wait (1)

		'Increments the intCurrentCount value by 1
		intCurrentCount = intCurrentCount + 1
	Loop Until intCurrentCount = intSeconds
	fnWaitForObject = blnRetVal

		If blnRetVal = False Then
			intSeconds = intSeconds * 20
		gobjReport.UpdateTestLog "Waiting for Object", "'"& strObjName &"' object not found after waiting '"& intSeconds &"' seconds", "Fail"
		gobjReport.UpdateTestLog "Screenshot", "'"&strObjName &"' object not found after waiting '"& intSeconds &"' seconds", "Screenshot"
	End If
End Function

'#######################################################################################################################
'Function Name          :	fnWaitForMultipleObjects
'Function Description   : 	Waits for an object s for the given time
'Input Parameters       : 	objWindow1 - 1st object,objWindow2 - 2nd object Seconds, Customized obj name for result
'Return Value               : 	None
'Author                       : Cognizant
'Date Created              : 
'Status                        : Completed
'#######################################################################################################################
Function fnWaitForMultipleObjects(objWindow1, objWindow2, intSeconds)
	Dim intCurrentCount
	Dim blnRetVal
	intCurrentCount = 1
	blnRetVal = False

	Do
		'Exits the Do Loop if the Condition is satisfied
		If objWindow1.Exist(1) Then
			blnRetVal = True
			Exit Do
		ElseIf objWindow2.Exist(1)  Then
			blnRetVal = False
			Exit Do
		End If
		'Waits for 1 sec
		Wait (1)

		'Increments the intCurrentCount value by 1
		intCurrentCount = intCurrentCount + 1
	Loop Until intCurrentCount = intSeconds
	fnWaitForMultipleObjects = blnRetVal

End Function

'#######################################################################################################################
'Function Name          :	fnWaitForPropertyStatus
'Function Description   : 	Waits for the Property of object for the time limit
'Input Parameters       : 	objWindow -  The parent object ,property - Property Name,Status -  Property Value, Seconds, Customized obj name for result
'Return Value               : 	None
'Author                       : Cognizant
'Date Created              : 
'Status                        : Completed
'#######################################################################################################################
Function fnWaitForPropertyStatus(objWindow, objProperty,objStatus,  intSeconds, strObjName)
	Dim intCurrentCount, intMilliSeconds
	Dim blnRetVal, blnFlag
	intMilliSeconds = 1000   ' Input will be in MilliSeconds
	intCurrentCount = 1
	blnRetVal = False

	Do
		'Exits the Do Loop if the Condition is satisfied
		If objWindow.WaitProperty (objProperty,objStatus,intMilliSeconds) Then
			blnRetVal = True
			Exit Do
		End If
		
		'Increments the intCurrentCount value by 1
		intCurrentCount = intCurrentCount + 1
		If intCurrentCount = intSeconds Then
			blnFlag = True
		End If
	Loop Until blnFlag = True
	fnWaitForPropertyStatus = blnRetVal

	If blnRetVal = False Then
		intSeconds=intSeconds*20
		gobjReport.UpdateTestLog "Waiting for Property", "Property not found after waiting '"& intSeconds &"' :: ObjectName: "& strObjName &",objProperty: "& objProperty &",objStatus: "& objStatus , "Fail"
	End If
End Function
'#######################################################################################################################
'Function Name          :	fnExist
'Function Description   : 	Waits for an object 30 Secs
'Input Parameters       : 	objName - Object, strObjName - Name of Object, blnOptionalVerify - Stops the iteration based on the boolean  value
'Return Value               : 	Boolean
'Author                       : Cognizant
'Date Created              :  
'Status                        : Completed
'#######################################################################################################################
Function fnExist(objName, strObjName, blnOptionalVerify)  ''' This exist is used for Internal function call

	 If objName.Exist(30) Then
		fnExist = True
	Else
		fnExist = False	

			' If blnOptionalVerify=True, then exit the iteration
			If blnOptionalVerify Then
					gobjReport.UpdateTestLog "Verify Exist", "'"& strObjName &"' doesn't exist" , "Fail"
					ExitTestIteration
			End If

	End If
End Function

'#######################################################################################################################
'Function Name          :	fnObjExist
'Function Description   : 	Waits for an object 30 Secs - ''' This exist is used for Internal function call
'Input Parameters       : 	objName - Object, strObjName - Name of Object, blnOptionalVerify - Stops the iteration based on the boolean  value
'Return Value               : 	Boolean
'Author                       : Cognizant
'Date Created              : 
'Status                        : Completed
'#######################################################################################################################
Function fnObjExist(objName, strObjName, blnOptionalVerify, intSeconds)  

	If intSeconds = "" Then
		intSeconds = 30
	End If

	 If objName.Exist(intSeconds) Then
		fnObjExist = True
	Else
		fnObjExist = False
		If blnOptionalVerify Then
				gobjReport.UpdateTestLog "Verify Exist", "'"& strObjName &"' doesn't exist" , "Fail"
				ExitTestIteration
		End If
	End If
End Function

'#######################################################################################################################
'Function Name          :	fnVerifyExist
'Function Description   : 	Waits for an object 30 Secs - -with reporting feature
'Input Parameters       : 	objName - Object, strObjName - Name of Object, blnOptionalVerify - Stops the iteration based on the boolean  value
'Return Value               : 	None
'Author                       : Cognizant
'Date Created              : 
'Status                        : Completed
'#######################################################################################################################
Function fnVerifyExist(objName, strObjName, blnOptionalVerify) 

	 If objName.Exist(30) Then
		 gobjReport.UpdateTestLog "Verify Exist", "'"& strObjName &"' exist" , "Pass"
		 fnVerifyExist = True
	Else			
		gobjReport.UpdateTestLog "Verify Exist", "'"& strObjName &"' doesn't exist" , "Fail"    
			' If blnOptionalVerify=True, then exit the iteration
				If blnOptionalVerify Then						
						ExitTestIteration
				End If
	End If
End Function
'#######################################################################################################################
'Function Name          :	fnNotExist
'Function Description   : 	Waits for 30 secs for an object  - not exits
'Input Parameters       : 	objName - Object, strObjName - Name of Object, blnOptionalVerify - Stops the iteration based on the boolean  value
'Return Value               : 	Boolean
'Author                       : Cognizant
'Date Created              : 
'Status                        : Completed
'#######################################################################################################################
Function fnNotExist(objName, strObjName, blnOptionalVerify)  
	 If objName.Exist(15) Then
		 fnNotExist = False
		 	' If blnOptionalVerify=True, then exit the iteration
					If blnOptionalVerify Then
						gobjReport.UpdateTestLog "Verify Doesn't Exist", "'"& strObjName &"'  exist" , "Fail"
							ExitTestIteration
					End If
	Else
		fnNotExist = True     			
	End If
End Function
'#######################################################################################################################
'Function Name          :	fnVerifyNotExist
'Function Description   : 	Waits for 30 secs for an object  - not exits -with reporting feature
'Input Parameters       : 	objName - Object, strObjName - Name of Object, blnOptionalVerify - Stops the iteration based on the boolean  value
'Return Value               : 	None
'Author                       : Cognizant
'Date Created              :  
'Status                        : Completed
'#######################################################################################################################
Function fnVerifyNotExist(objName, strObjName, blnOptionalVerify)  ''' This Exist is used for Internal call, Returns Boolean

	 If objName.Exist(15) Then
		 gobjReport.UpdateTestLog "Verify Doesn't Exist", "'"& strObjName &"'  exist" , "Fail"
		 	' If blnOptionalVerify=True, then exit the iteration
					If blnOptionalVerify Then						
							ExitTestIteration
					End If
	Else
		gobjReport.UpdateTestLog "Verify Doesn't Exist", "'"& strObjName &"' doesn't exist" , "Pass"  			
	End If
End Function
'#######################################################################################################################
'Function Name          :	fnDisplayed
'Function Description   : 	Checks object display
'Input Parameters       : 	objName - Object, strObjName - Name of Object, blnOptionalVerify - Stops the iteration based on the boolean  value
'Return Value               : 	Boolean
'Author                       : Cognizant
'Date Created              :  
'Status                        : Completed
'#######################################################################################################################
Function fnDisplayed(objName, strObjName, blnOptionalVerify) 

		If fnExist(objName,strObjName, False) Then
				If fnWaitForPropertyStatus(objName,"visible","True",30,strObjName) Then			
				fnDisplayed = True
				End If
		Else		
				fnDisplayed = False			

					' If blnOptionalVerify=True, then exit the iteration
					If blnOptionalVerify Then
						gobjReport.UpdateTestLog  "Verify Display", strObjName &" is not displayed" , "Fail"
							ExitTestIteration
					End If			
		End If
		
End Function
'#######################################################################################################################
'Function Name          :	fnVerifyDisplayed
'Function Description   : 	Checks object display -with reporting feature
'Input Parameters       : 	objName - Object, strObjName - Name of Object, blnOptionalVerify - Stops the iteration based on the boolean  value
'Return Value               : 	None
'Author                       : Cognizant
'Date Created              :  
'Status                        : Completed
'#######################################################################################################################
Function fnVerifyDisplayed(objName, strObjName, blnOptionalVerify)  

		If fnExist(objName,strObjName, False) Then
			If fnWaitForPropertyStatus(objName,"visible","True",30,strObjName) Then			
				fnVerifyDisplayed = True
				gobjReport.UpdateTestLog "Verify Display", strObjName &" is displayed" , "Pass"	
			End If
		Else
			fnVerifyDisplayed = False
			gobjReport.UpdateTestLog "Verify Display", strObjName &" is not displayed" , "Fail"	
				' If blnOptionalVerify=True, then exit the iteration
			If blnOptionalVerify Then	
					ExitTestIteration
			End If
			
		End If
		
End Function
'#######################################################################################################################
'Function Name          :	fnNotDisplayed
'Function Description   : 	Checks object  is not displayed
'Input Parameters       : 	objName - Object, strObjName - Name of Object, blnOptionalVerify - Stops the iteration based on the boolean  value
'Return Value               : 	None
'Author                       : Cognizant
'Date Created              :  
'Status                        : Completed
'#######################################################################################################################
Function fnNotDisplayed(objName, strObjName, blnOptionalVerify)

		If fnNotExist(objName,strObjName, False) Then		
				fnNotDisplayed = True
		Else 
				fnNotDisplayed = False				
					If blnOptionalVerify Then  '##Exit the iteration if object is displayed
						gobjReport.UpdateTestLog "Verify Non-Display ", strObjName &" is displayed" , "Fail"
						ExitTestIteration
					End If			
	 End If
		
End Function
'#######################################################################################################################
'Function Name          :	fnVerifyNotDisplayed
'Function Description   : 	Checks object  is not displayed -with reporting feature
'Input Parameters       : 	objName - Object, strObjName - Name of Object, blnOptionalVerify - Stops the iteration based on the boolean  value
'Return Value               : 	None
'Author                       : Cognizant
'Date Created              :  
'Status                        : Completed
'#######################################################################################################################
Function fnVerifyNotDisplayed(objName, strObjName, blnOptionalVerify)

		If fnNotExist(objName,strObjName, False) Then		
				gobjReport.UpdateTestLog "Verify Non-Display ", strObjName &" is not displayed" , "Pass"
		Else 		
				gobjReport.UpdateTestLog "Verify Non-Display ", strObjName &" is displayed" , "Fail"		
					If blnOptionalVerify Then  '##Exit the iteration if object is displayed
						ExitTestIteration
					End If			
	 End If		
End Function
'#######################################################################################################################
'Function Name          :	fnCheckBoxEnabled
'Function Description   : 	Verifies checkbox enabled
'Input Parameters       : 	objName - Object, strObjName - Name of Object, blnOptionalVerify - Stops the iteration based on the boolean  value
'Return Value               : 	Boolean
'Author                       : Cognizant
'Date Created              : 
'Status                        : Completed
'#######################################################################################################################
Function fnCheckBoxEnabled(objName, strObjName, blnOptionalVerify)
		Dim strValue
		If fnExist(objName,strObjName, blnOptionalVerify) Then
				If(objName.GetROProperty("disabled")) Then
					fnCheckBoxEnabled = False										
								If blnOptionalVerify Then		
									gobjReport.UpdateTestLog  "Verify Checkbox Enabled", strObjName &" is disabled" , "Fail"	
									' If blnOptionalVerify=True, then exit the iteration
									ExitTestIteration	
							End If
				Else
					fnCheckBoxEnabled = True					
				End If
		End If		
End Function
'#######################################################################################################################
'Function Name          :	fnVerifyCheckBoxEnabled
'Function Description   : 	Verifies checkbox enabled -with reporting feature
'Input Parameters       : 	objName - Object, strObjName - Name of Object, blnOptionalVerify - Stops the iteration based on the boolean  value
'Return Value               : 	None
'Author                       : Cognizant
'Date Created              :  
'Status                        : Completed
'#######################################################################################################################
Function fnVerifyCheckBoxEnabled(objName, strObjName, blnOptionalVerify)
		Dim strValue
		If fnExist(objName,strObjName, blnOptionalVerify) Then

				If(objName.GetROProperty("disabled")) Then
					gobjReport.UpdateTestLog  "Verify Checkbox Enabled", strObjName &" is disabled" , "Fail"
						If blnOptionalVerify Then											
							' If blnOptionalVerify=True, then exit the iteration
								ExitTestIteration	
						End If
				Else
						gobjReport.UpdateTestLog "Verify Checkbox Enabled", strObjName &" is enabled" , "Pass"      					
				End If

		End If		
End Function
'#######################################################################################################################
'Function Name          :	fnCheckBoxDisabled
'Function Description   : 	Verifies checkbox disabled
'Input Parameters       : 	objName - Object, strObjName - Name of Object, blnOptionalVerify - Stops the iteration based on the boolean  value
'Return Value               : 	Boolean
'Author                       : Cognizant
'Date Created              :  
'Status                        : Completed
'#######################################################################################################################
Function fnCheckBoxDisabled(objName, strObjName, blnOptionalVerify)

		If fnExist(objName,strObjName, blnOptionalVerify) Then
				If(objName.GetROProperty("disabled")) Then
					fnCheckBoxDisabled = True
				Else
					fnCheckBoxDisabled = False
						' If blnOptionalVerify=True, then exit the iteration
					If blnOptionalVerify Then
						gobjReport.UpdateTestLog  "Verify Checkbox Disabled", strObjName &" is enabled" , "Fail"
							ExitTestIteration
					End If
				End If
		End If
		
End Function
'#######################################################################################################################
'Function Name          :	fnVerifyCheckBoxDisabled
'Function Description   : 	Verifies checkbox disabled  -with reporting feature
'Input Parameters       : 	objName - Object, strObjName - Name of Object, blnOptionalVerify - Stops the iteration based on the boolean  value
'Return Value               : 	None
'Author                       : Cognizant
'Date Created              :  
'Status                        : Completed
'#######################################################################################################################
Function fnVerifyCheckBoxDisabled(objName, strObjName, blnOptionalVerify)

		If fnExist(objName,strObjName, blnOptionalVerify) Then
				If(objName.GetROProperty("disabled")) Then
						gobjReport.UpdateTestLog "Verify Checkbox Disabled", strObjName &" is disabled" , "Pass"
				Else
					gobjReport.UpdateTestLog  "Verify Checkbox Disabled", strObjName &" is enabled" , "Fail"
						If blnOptionalVerify Then  ' If blnOptionalVerify=True, then exit the iteration						
							ExitTestIteration
						End If
				End If
		End If
		
End Function
'#######################################################################################################################
'Function Name          :	fnCheckBoxChecked
'Function Description   : 	Verifies checkbox Selected
'Input Parameters       : 	objName - Object, strObjName - Name of Object, blnOptionalVerify - Stops the iteration based on the boolean  value
'Return Value               : 	Boolean
'Author                       : Cognizant
'Date Created              :  
'Status                        : Completed
'#######################################################################################################################
Function fnCheckBoxChecked(objName, strObjName, blnOptionalVerify)
		Dim strValue
	If fnExist(objName,strObjName, blnOptionalVerify) Then
				If(objName.GetROProperty("checked")) Then
					fnCheckBoxChecked = True
				Else
					fnCheckBoxChecked = False						
					' If blnOptionalVerify=True, then exit the iteration
					If blnOptionalVerify Then
							gobjReport.UpdateTestLog "Verify Checkbox Checked", strObjName &" is unchecked" , "Fail"
							ExitTestIteration
					End If
				End If			
		End If
		
End Function
'#######################################################################################################################
'Function Name          :	fnVerifyCheckBoxChecked
'Function Description   : 	Verifies checkbox Selected -with reporting feature
'Input Parameters       : 	objName - Object, strObjName - Name of Object, blnOptionalVerify - Stops the iteration based on the boolean  value
'Return Value               : 	None
'Author                       : Cognizant
'Date Created              :  
'Status                        : Completed
'#######################################################################################################################
Function fnVerifyCheckBoxChecked(objName, strObjName, blnOptionalVerify)

	If fnExist(objName,strObjName, blnOptionalVerify) Then
				If(objName.GetROProperty("checked")) Then
					fnVerifyCheckBoxChecked = True
						gobjReport.UpdateTestLog "Verify Checkbox Checked", strObjName &" is checked" , "Pass"
				Else
					fnVerifyCheckBoxChecked = False
						gobjReport.UpdateTestLog "Verify Checkbox Checked", strObjName &" is unchecked" , "Fail"
					' If blnOptionalVerify=True, then exit the iteration
					If blnOptionalVerify Then
							ExitTestIteration
					End If
				End If			
		End If
		
End Function
'#######################################################################################################################
'Function Name          :	fnCheckBoxUnChecked
'Function Description   : 	Verifies checkbox not Selected
'Input Parameters       : 	objName - Object, strObjName - Name of Object, blnOptionalVerify - Stops the iteration based on the boolean  value
'Return Value               : 	Boolean
'Author                       : Cognizant
'Date Created              :  
'Status                        : Completed
'#######################################################################################################################
Function fnCheckBoxUnChecked(objName, strObjName, blnOptionalVerify)
		Dim strValue
		If fnExist(objName,strObjName, blnOptionalVerify) Then
				If (objName.GetROProperty("checked")) Then
					fnCheckBoxUnChecked = False					
					If blnOptionalVerify Then				
						gobjReport.UpdateTestLog "Verify Checkbox UnChecked", strObjName &" is checked" , "Fail"
							' If blnOptionalVerify=True, then exit the iteration
							ExitTestIteration
					End If
				Else
					fnCheckBoxUnChecked = True
				End If			
		End If
		
End Function
'#######################################################################################################################
'Function Name          :	fnVerifyCheckBoxUnChecked
'Function Description   : 	Verifies checkbox not Selected -with reporting feature
'Input Parameters       : 	objName - Object, strObjName - Name of Object, blnOptionalVerify - Stops the iteration based on the boolean  value
'Return Value               : 	None
'Author                       : Cognizant
'Date Created              :  
'Status                        : Completed
'#######################################################################################################################
Function fnVerifyCheckBoxUnChecked(objName, strObjName, blnOptionalVerify)
		Dim strValue
		If fnExist(objName,strObjName, blnOptionalVerify) Then
				If (objName.GetROProperty("checked")) Then
					gobjReport.UpdateTestLog "Verify Checkbox UnChecked", strObjName &" is checked" , "Fail"
					If blnOptionalVerify Then						
							' If blnOptionalVerify=True, then exit the iteration
							ExitTestIteration
					End If
				Else
					gobjReport.UpdateTestLog "Verify Checkbox UnChecked", strObjName &" is unchecked" , "Pass"
				End If			
		End If
		
End Function
'#######################################################################################################################
'Function Name          :	fnGetInnerText
'Function Description   : 	Retrieve inner text property of an object
'Input Parameters       : 	objName - Object, strObjName - Name of Object
'Return Value               : 	String - Inner Text 
'Author                       : Cognizant
'Date Created              :  
'Status                        : Completed
'#######################################################################################################################
Function fnGetInnerText(objName,strObjName)
		Dim strInnerText
		If fnExist(objName,strObjName, True) Then
				strInnerText = Trim(objName.GetROProperty("innertext"))
						fnGetInnerText = strInnerText
		End If

End Function
'#######################################################################################################################
'Function Name          :	fnGetValue
'Function Description   : 	Retrieve value property of an object
'Input Parameters       : 	objName - Object, strObjName - Name of Object
'Return Value               : 	String - Value
'Author                       : Cognizant
'Date Created              :  
'Status                        : Completed
'#######################################################################################################################
Function fnGetValue(objName,strObjName)
		Dim strValue
		If  fnExist(objName,strObjName, True) Then
				strValue = Trim(objName.GetROProperty("value"))
						fnGetValue = strValue
		End If
End Function
'#######################################################################################################################
'Function Name          :	fnInString
'Function Description   : 	Verifies the sub string within string after retrieving inner text property of an object
'Input Parameters       : 	objName - Object, strObjName - Name of Object, blnOptionalVerify - Stops the iteration based on the boolean  value
'Return Value               : 	Boolean
'Author                       : Cognizant
'Date Created              :  
'Status                        : Completed
'#######################################################################################################################
Function fnInString(objName, strSubString, strObjName, blnOptionalVerify)

		Dim strActualString
		If  fnExist(objName,strObjName, blnOptionalVerify) Then
				strActualString = Trim(objName.GetROProperty("innertext"))
				strSubString = Trim(strSubString)	

				If InStr(strActualString, strSubString) <> 0 Then
						fnInString = True
				Else
						fnInString = False								
						If blnOptionalVerify Then		
							gobjReport.UpdateTestLog "Verify Substring Availability","Given Substring: '"& strSubString &"' is not within the ActualString:  '"& strActualString & "'" , "Fail" 
							' If blnOptionalVerify=True, then exit the iteration
							ExitTestIteration
						End If
			End If
		End If
End Function
'#######################################################################################################################
'Function Name          :	fnVerifyInString
'Function Description   : 	Verifies the sub string within string after retrieving inner text property of an object -with reporting feature
'Input Parameters       : 	objName - Object, strObjName - Name of Object, blnOptionalVerify - Stops the iteration based on the boolean  value
'Return Value               : 	None
'Author                       : Cognizant
'Date Created              :  
'Status                        : Completed
'#######################################################################################################################
Function fnVerifyInString(objName, strSubString, strObjName, blnOptionalVerify)

		Dim strActualString
		If  fnExist(objName,strObjName, blnOptionalVerify) Then
				strActualString = Trim(objName.GetROProperty("innertext"))
				strSubString = Trim(strSubString)	

				If InStr(strActualString, strSubString) <> 0 Then
						gobjReport.UpdateTestLog "Verify Substring Availability","Given Substring: '"& strSubString &"' is within the ActualString: '"& strActualString & "'", "Pass" 
				Else
				gobjReport.UpdateTestLog "Verify Substring Availability","Given Substring: '"& strSubString &"' is not within the ActualString:  '"& strActualString & "'" , "Fail" 
							If blnOptionalVerify Then						
								' If blnOptionalVerify=True, then exit the iteration
								ExitTestIteration
							End If						
			End If
		End If
End Function
'#######################################################################################################################
'Function Name          :	fnNotInString
'Function Description   : 	Verifies the sub string not within string after retrieving inner text property of an object
'Input Parameters       : 	objName - Object, strObjName - Name of Object, blnOptionalVerify - Stops the iteration based on the boolean  value
'Return Value               : 	Boolean
'Author                       : Cognizant
'Date Created              :  
'Status                        : Completed
'#######################################################################################################################
Function fnNotInString(objName, strSubString, strObjName, blnOptionalVerify)

		Dim strActualString
		strActualString = Trim(objName.GetROProperty("innertext"))
		strSubString = Trim(strSubString)	
		If  fnExist(objName,strObjName, blnOptionalVerify) Then
				If InStr(strActualString, strSubString) = 0 Then
						fnNotInString = True
				Else
						fnNotInString = False
						If blnOptionalVerify Then	
							gobjReport.UpdateTestLog "Verify Substring Non-Availability","Given Substring: '"& strSubString &"' is within the ActualString: '"& strActualString & "'" , "Fail" 
								' If blnOptionalVerify=True, then exit the iteration
								ExitTestIteration
							End If  
			End If
		End If

End Function
'#######################################################################################################################
'Function Name          :	fnVerifyNotInString
'Function Description   : 	Verifies the sub string not within string after retrieving inner text property of an object -with reporting feature
'Input Parameters       : 	objName - Object, strObjName - Name of Object, blnOptionalVerify - Stops the iteration based on the boolean  value
'Return Value               : 	None
'Author                       : Cognizant
'Date Created              :  
'Status                        : Completed
'#######################################################################################################################
Function fnVerifyNotInString(objName, strSubString, strObjName, blnOptionalVerify)

		Dim strActualString
		strActualString = Trim(objName.GetROProperty("innertext"))
		strSubString = Trim(strSubString)	
		If  fnExist(objName,strObjName, blnOptionalVerify) Then
				If InStr(strActualString, strSubString) = 0 Then
						gobjReport.UpdateTestLog "Verify Substring Non-Availability","Given Substring: '"& strSubString &"' is not within the ActualString:  '"& strActualString & "'" , "Pass" 
				Else
						gobjReport.UpdateTestLog "Verify Substring Non-Availability","Given Substring: '"& strSubString &"' is within the ActualString: '"& strActualString & "'" , "Fail" 
						If blnOptionalVerify Then
								' If blnOptionalVerify=True, then exit the iteration
								ExitTestIteration
							End If  
			End If
		End If

End Function
'#######################################################################################################################
'Function Name          :	fnCompareString
'Function Description   : 	Compares two string
'Input Parameters       : 	objName - Object, strObjName - Name of Object, blnOptionalVerify - Stops the iteration based on the boolean  value
'Return Value               : 	Boolean
'Author                       : Cognizant
'Date Created              :  
'Status                        : Completed
'#######################################################################################################################
Function fnCompareString(strActual, strExpected, blnOptionalVerify)

		Dim strActualString
		strActual = Trim(strActual)
		strExpected = Trim(strExpected) 		
				If strActual = strExpected Then
						fnCompareString = True
				Else
					fnCompareString = False		
						' If blnOptionalVerify=True, then exit the iteration
						If blnOptionalVerify Then
							gobjReport.UpdateTestLog  "Compare String","Actual: '"& strActual &"', Expected: '"& strExpected &"', Content doesn't match as expected" , "Fail" 
								ExitTestIteration
						End If
		End If

End Function
'#######################################################################################################################
'Function Name          :	fnVerifyCompareString
'Function Description   : 	Compares two string -with reporting feature
'Input Parameters       : 	objName - Object, strObjName - Name of Object, blnOptionalVerify - Stops the iteration based on the boolean  value
'Return Value               : 	None
'Author                       : Cognizant
'Date Created              :  
'Status                        : Completed
'#######################################################################################################################
Function fnVerifyCompareString(strActual, strExpected, blnOptionalVerify)

		Dim strActualString
		strActual = Trim(strActual)
		strExpected = Trim(strExpected) 		
				If strActual = strExpected Then
						gobjReport.UpdateTestLog "Compare String","Actual: '"& strActual &"', Expected: '"& strExpected &"', Content matches as expected" , "Pass" 
				Else
						gobjReport.UpdateTestLog  "Compare String","Actual: '"& strActual &"', Expected: '"& strExpected &"', Content doesn't match as expected" , "Fail" 
						' If blnOptionalVerify=True, then exit the iteration
						If blnOptionalVerify Then
								ExitTestIteration
						End If
		End If

End Function

'#######################################################################################################################
'Function Name          :	fnEnabled
'Function Description   : 	Verifies enabled state of an object
'Input Parameters       : 	objName - Object, strObjName - Name of Object
'Return Value               : 	Boolean
'Author                       : Cognizant
'Date Created              :  
'Status                        : Completed
'#######################################################################################################################
Function fnEnabled(objName, strObjName, blnOptionalVerify)

   Dim strPropertyName
    strPropertyName=Ucase(Mid(objName.GetTOProperty("micclass"),1,3))

	If  fnExist(objName,strObjName, blnOptionalVerify) Then

		Select Case strPropertyName
			Case "WIN"
				If  (objName.WaitProperty("enabled",True, 30)) Then
				fnEnabled = True
				Else
				fnEnabled = False
					' If blnOptionalVerify=True, then exit the iteration
						If blnOptionalVerify Then
							gobjReport.UpdateTestLog   "Verify Enabled", strObjName &" is not Enabled" , "Fail"
								ExitTestIteration
						End If
				
				End If	
			
			Case "WEB"
				If (objName.WaitProperty("disabled",0,30))  Then
				fnEnabled = True
				Else
				fnEnabled = False
				' If blnOptionalVerify=True, then exit the iteration
						If blnOptionalVerify Then
							gobjReport.UpdateTestLog   "Verify Enabled", strObjName &" is not Enabled" , "Fail"
								ExitTestIteration
						End If
				End If  	
		End Select

	End If
End Function
''#######################################################################################################################
'Function Name          :	fnVerifyEnabled
'Function Description   : 	Verifies enabled state of an object -with reporting feature
'Input Parameters       : 	objName - Object, strObjName - Name of Object
'Return Value               : 	None
'Author                       : Cognizant
'Date Created              :  
'Status                        : Completed
'#######################################################################################################################
Function fnVerifyEnabled(objName, strObjName, blnOptionalVerify)

   Dim strPropertyName
    strPropertyName=Ucase(Mid(objName.GetTOProperty("micclass"),1,3))

	If  fnExist(objName,strObjName, blnOptionalVerify) Then

		Select Case strPropertyName
			Case "WIN"
				If  (objName.WaitProperty("enabled",True, 30)) Then
				gobjReport.UpdateTestLog   "Verify Enabled", strObjName &" is Enabled" , "Pass"
				Else	
				gobjReport.UpdateTestLog   "Verify Enabled", strObjName &" is not Enabled" , "Fail"
					' If blnOptionalVerify=True, then exit the iteration
						If blnOptionalVerify Then
								ExitTestIteration
						End If
				End If	
			
			Case "WEB"
				If (objName.WaitProperty("disabled",0,30))  Then
				gobjReport.UpdateTestLog   "Verify Enabled", strObjName &" is Enabled" , "Pass"
				Else
				gobjReport.UpdateTestLog   "Verify Enabled", strObjName &" is not Enabled" , "Fail"
					' If blnOptionalVerify=True, then exit the iteration
						If blnOptionalVerify Then
								ExitTestIteration
						End If
				End If  	
		End Select

	End If
End Function
'#######################################################################################################################
'Function Name          :	fnDisabled
'Function Description   : 	Verifies disabled state of an object
'Input Parameters       : 	objName - Object, strObjName - Name of Object
'Return Value               : 	Boolean
'Author                       : Cognizant
'Date Created              :  
'Status                        : Completed
'#######################################################################################################################
Function fnDisabled(objName, strObjName, blnOptionalVerify)

					If  fnExist(objName,strObjName, True) Then
							If not objName.WaitProperty("disabled","0", 30) Then
									fnDisabled = True
							Else
									fnDisabled = False
										' If blnOptionalVerify=True, then exit the iteration
									If blnOptionalVerify Then
										gobjReport.UpdateTestLog "Verify Disabled", strObjName &" is not Disabled" , "Fail"
											ExitTestIteration
									End If
									
							End If	
					End If
End Function
'#######################################################################################################################
'Function Name          :	fnVerifyDisabled
'Function Description   : 	Verifies disabled state of an object -with reporting feature
'Input Parameters       : 	objName - Object, strObjName - Name of Object
'Return Value               : 	None
'Author                       : Cognizant
'Date Created              : 
'Status                        : Completed
'#######################################################################################################################
Function fnVerifyDisabled(objName, strObjName, blnOptionalVerify)

					If  fnExist(objName,strObjName, True) Then
							If not objName.WaitProperty("disabled","0", 30) Then
									gobjReport.UpdateTestLog  "Verify Disabled", strObjName &" is Disabled" , "Pass"
							Else
									gobjReport.UpdateTestLog "Verify Disabled", strObjName &" is not Disabled" , "Fail"
									' If blnOptionalVerify=True, then exit the iteration
									If blnOptionalVerify Then
											ExitTestIteration
									End If
							End If	
					End If
End Function
'#######################################################################################################################
'Function Name          :	fnEditable
'Function Description   : 	Verifies editable state of an object
'Input Parameters       : 	objName - Object, strObjName - Name of Object
'Return Value               : 	Boolean
'Author                       : Cognizant
'Date Created              : 
'Status                        : Completed
'#######################################################################################################################
Function fnEditable(objName, strObjName, blnOptionalVerify)  

 Dim strPropertyName
    strPropertyName=Ucase(Mid( objName.GetTOProperty("micclass"),1,3))

	If fnExist(objName,strObjName, blnOptionalVerify) Then
			If fnWaitForPropertyStatus(objName,"visible","True",30,strObjName) Then 
				Select Case strPropertyName
					Case "WIN"
						If  (objName.WaitProperty("enabled",True, 30)) Then
						fnEditable = True
						Else
						fnEditable = False
							' If blnOptionalVerify=True, then exit the iteration
									If blnOptionalVerify Then
										gobjReport.UpdateTestLog   "Verify Editable", strObjName &" is not Editable" , "Fail"
										ExitTestIteration
									End If						
						End If	
					
					Case "WEB"
						If (objName.WaitProperty("disabled",0,30))  Then
						fnEditable = True
						Else
						fnEditable = False
							' If blnOptionalVerify=True, then exit the iteration
									If blnOptionalVerify Then
										gobjReport.UpdateTestLog   "Verify Editable", strObjName &" is not Editable" , "Fail"
										ExitTestIteration
									End If		
						End If  	
				End Select

		End If
	End If
End Function
'#######################################################################################################################
'Function Name          :	fnVerifyEditable
'Function Description   : 	Verifies editable state of an object -with reporting feature
'Input Parameters       : 	objName - Object, strObjName - Name of Object
'Return Value               : 	None
'Author                       : Cognizant
'Date Created              :  
'Status                        : Completed
'#######################################################################################################################
Function fnVerifyEditable(objName, strObjName, blnOptionalVerify )  '''' Verify object is editable - Explicit call

Dim strPropertyName
    strPropertyName=Ucase(Mid( objName.GetTOProperty("micclass"),1,3))

	If  fnExist(objName,strObjName, blnOptionalVerify) Then

		Select Case strPropertyName
			Case "WIN"
				If  (objName.WaitProperty("enabled",True, 30)) Then
					gobjReport.UpdateTestLog  "Verify Editable", strObjName &" is Editable" , "Pass"
				Else			
					gobjReport.UpdateTestLog  "Verify Editable", strObjName &" is not Editable" , "Fail"
					' If blnOptionalVerify=True, then exit the iteration
									If blnOptionalVerify Then
										ExitTestIteration
									End If	
				End If	
			
			Case "WEB"
				If (objName.WaitProperty("disabled",0,30))  Then
					gobjReport.UpdateTestLog  "Verify Editable", strObjName &" is Editable" , "Pass"
				Else
					gobjReport.UpdateTestLog  "Verify Editable", strObjName &" is not Editable" , "Fail"
									' If blnOptionalVerify=True, then exit the iteration
									If blnOptionalVerify Then
										ExitTestIteration
									End If	
				End If  	
		End Select

	End If
End Function
'#######################################################################################################################
'Function Name          :	fnSendKeys
'Function Description   : 	sendkeys to an object
'Input Parameters       : 	objName - Object, strObjName - Name of Object
'Return Value               : 	None
'Author                       : Cognizant
'Date Created              :  
'Status                        : Completed
'#######################################################################################################################
Function fnSendKeys(objName, strText, strObjName)

					If  fnEditable(objName,strObjName, True) Then  ''' Checking the object is editable

						Dim objWShell
						Set objWShell = CreateObject("WScript.Shell")  ' Creating object 

						objName.Click  ' Clicking on Object to enter the text
						wait(1)
						objWShell.SendKeys "^A" 
						objWShell.SendKeys strText '' Sending text to the object
						wait(1)	
						objName.Click
						Set objWShell = Nothing
					End If
					
End Function
'#######################################################################################################################
'Function Name          :	fnClick
'Function Description   : 	Clicks an object
'Input Parameters       : 	objName - Object, strObjName - Name of Object
'Return Value               : 	None
'Author                       : Cognizant
'Date Created              :  
'Status                        : Completed
'#######################################################################################################################
Function fnClick(objName, strObjName)
					If  fnExist(objName,strObjName, True) Then
							objName.Click
					End If
End Function
'#######################################################################################################################
'Function Name          :	fnClickIfExist
'Function Description   : 	Clicks an object if exists
'Input Parameters       : 	objName - Object, strObjName - Name of Object
'Return Value               : 	None
'Author                       : Cognizant
'Date Created              :  
'Status                        : Completed
'#######################################################################################################################
Function fnClickIfExist(objName, strObjName)
					If  fnExist(objName,strObjName, False) Then
							objName.Click
					End If
End Function
'#######################################################################################################################
'Function Name          :	fnClickLinkText
'Function Description   : 	Clicks an link object  (with tag A)
'Input Parameters       : 	objName - Object, strObjName - Name of Object
'Return Value               : 	None
'Author                       : Cognizant
'Date Created              :  
'Status                        : Completed
'#######################################################################################################################
Function fnClickLinkText(objFrame, strObjName)
					If  fnExist(objFrame.Link("text:="& strObjName,"html tag:=A" ), strObjName, True) Then
							Call fnClick(objFrame.Link("text:="& strObjName,"html tag:=A" ), strObjName)
					Else
							gobjReport.UpdateTestLog  "Click on LinkText" ,"Click on "& strObjName, "Fail"
							ExitTestIteration
					End If
End Function
'#######################################################################################################################
'Function Name          :	fnClearText
'Function Description   : 	Clears the text present in an object
'Input Parameters       : 	objName - Object, strObjName - Name of Object
'Return Value               : 	None
'Author                       : Cognizant
'Date Created              :  
'Status                        : Completed
'#######################################################################################################################
Function fnClearText(objName, strObjName)

		If  fnEditable(objName, strObjName, True) Then  ''' Checking the object is editable
				objName.Set ""
		Else
			gobjReport.UpdateTestLog  "Clear Text", "Failed to clear textbox, "& strObjName& " is not editable", "Fail"
		End If

End Function
'#######################################################################################################################
'Function Name          :	fnSetText
'Function Description   : 	Enters the value in an object
'Input Parameters       : 	objName - Object, strObjName - Name of Object
'Return Value               : 	None
'Author                       : Cognizant
'Date Created              : 
'Status                        : Completed
'#######################################################################################################################
Function fnSetText(objName, strText, strObjName)

		If  fnEditable(objName,strObjName, True) Then  ''' Checking the object is editable
				objName.Click  ' Clicking on Object to enter the text
                wait(1)
				objName.Set strText '' Sending text to the object
		End If

End Function
'#######################################################################################################################
'Function Name          :	fnSelectCheckBox
'Function Description   : 	Selects checkbox
'Input Parameters       : 	objName - Object, strObjName - Name of Object
'Return Value               : 	None
'Author                       : Cognizant
'Date Created              :  
'Status                        : Completed
'#######################################################################################################################
Function fnSelectCheckBox(objName, strObjName)
		If  fnCheckBoxEnabled(objName,strObjName, True) Then  ''' Checking the object is enabled
			If fnCheckBoxUnChecked(objName,strObjName, True) Then
					objName.Click  ' Selecting the checkbox
			End If
		End If
End Function
'#######################################################################################################################
'Function Name          :	fnUnSelectCheckBox
'Function Description   : 	Unselects checkbox
'Input Parameters       : 	objName - Object, strObjName - Name of Object
'Return Value               : 	None
'Author                       : Cognizant
'Date Created              :  
'Status                        : Completed
'#######################################################################################################################
Function fnUnSelectCheckBox(objName, strObjName)
		If  fnCheckBoxEnabled(objName,strObjName, True) Then  ''' Checking the object is enabled
				If fnCheckBoxChecked(objName,strObjName, True) Then
					objName.Click  ' UnSelecting the checkbox
				End If
		End If
End Function
'#######################################################################################################################
'Function Name          :	fnSelectList
'Function Description   : 	Seletcs the value from the List
'Input Parameters       : 	objName - Object, strObjName - Name of Object, strValue -  Value to select
'Return Value               : 	None
'Author                       : Cognizant
'Date Created              :  
'Status                        : Completed
'#######################################################################################################################
Function fnSelectList(objName, strObjName, strValue)

Dim strXPath

      If fnExist(objName,strObjName, True) Then
      	objName.Select strValue       
      Else
        gobjReport.UpdateTestLog "Selecting value from List", strValue &" is not found in the list", "Fail"
      End If

End Function 

'#######################################################################################################################
'Function Name          :	fnSelectLinkInWebTable
'Function Description   : 	selects the link from the webtable
'Input Parameters       : 	objWebTable - Object, strHeaderVal - Name of Header, strLinkVal - Link value to select
'Return Value               : 	None
'Author                       : Cognizant
'Date Created              :  
'Status                        : Completed
'#######################################################################################################################  
Function fnSelectLinkInWebTable(objWebTable, strHeaderVal, strLinkVal)

	Dim intRowCnt, intRow, intColumnCnt, intCol, intRows
	Dim strWebTableHeader
	Dim objLink
	Dim blnLinkFound,blnRetVal

	blnLinkFound = False
	blnRetVal = fnWaitForObject(objWebTable,60,"Link" & strLinkVal)

	If blnRetVal Then

		'Get Row Count.
		intRowCnt = objWebTable.RowCount

		For intRow = 1 To intRowCnt

			'Get Column Count.
			intColumnCnt = objWebTable.ColumnCount(intRow)

			For intCol = 1 To intColumnCnt
				strWebTableHeader = objWebTable.GetCellData(intRow, intCol)

				If Trim(strWebTableHeader) = Trim(strHeaderVal) Then
					intRow = intRow + 1

					For intRows = intRow To intRowCnt
						Set objLink = objWebTable.ChildItem(intRows, intCol, "Link", 0)
                          	If Trim(objlink.GetROProperty("innertext")) = Trim(strLinkVal) Then
							objLink.FireEvent "onclick"
							fnSelectLinkInWebTable = True
							Set objLink = Nothing
							Exit Function
						End If

					Next

				End If

			Next

		Next

	Else
		gobjReport.UpdateTestLog "Search and select link in WebTable", "WebTable object is not available.", "Fail"
	End If

	Set objLink = Nothing
	fnSelectLinkInWebTable = blnLinkFound

End Function
'#######################################################################################################################
'Function Name          :	fnCheckWebElementValueExistInWebTable
'Function Description   : 	Checks for the value in the webtable
'Input Parameters       : 	objWebTable - Object, strHeaderVal - Name of Header, strExpectedValue - Value to select
'Return Value               : 	None
'Author                       : Cognizant
'Date Created              :  
'Status                        : Completed
'#######################################################################################################################  
Function fnCheckWebElementValueExistInWebTable(objWebTable, strHeaderVal, strExpectedValue)

	Dim intRowCnt, intRow, intColumnCnt, intCol, intRows
	Dim strWebTableHeader
	Dim blnEditValFound, blnRetVal

	'wait 2

	blnEditValFound = False
	blnRetVal = False
	blnRetVal = fnWaitForObject(objWebTable, 30, "WebTable" )
	
	If blnRetVal Then
	
		'Get Row Count.
		intRowCnt = objWebTable.RowCount

		For intRow = 1 To intRowCnt

			'Get Column Count.
			intColumnCnt = objWebTable.ColumnCount(intRow)

			For intCol = 1 To intColumnCnt
				strWebTableHeader = objWebTable.GetCellData(intRow, intCol)

				'Compare webtable header  with expected header value
				If Trim(strWebTableHeader) = Trim(strHeaderVal) Then

					'Some webtable has empty last row . In such case rowcount -1 value will used.
					If objWebTable.ColumnCount(intRow + 1) = intColumnCnt Then
						intRow = intRow + 1

						If objWebTable.ColumnCount(intRowCnt) = intColumnCnt Then

							For intRows = intRow To intRowCnt
								'Checking if the editbox value is matching with the expected value
'								If Trim(objWebTable.ChildItem(intRows, intCol, "WebElement", 0).GetRoProperty("innertext")) = Trim(strExpectedValue) Then
								If Trim(objWebTable.GetCelldata(intRows, intCol)) = Trim(strExpectedValue) Then  ''### GetCellData used because, issue in WebElement
									fnCheckWebElementValueExistInWebTable = True
									blnEditValFound = True
									Exit Function
								End If

							Next

						Else
							gobjReport.UpdateTestLog "fnCheckWebElementValueExistInWebTable","Failed to Check :"& strExpectedValue &".Web Table  Header Column:"& strHeaderVal,"Fail"
						End If

						fnCheckWebElementValueExistInWebTable = blnEditValFound
						Exit Function
					Else
'						gobjReport.UpdateTestLog "Row Count", "WebTable contains No Rows with Data", "Done"
						fnCheckWebElementValueExistInWebTable = blnEditValFound
						Exit Function
					End If

				End If

			Next

		Next

	Else
		gobjReport.UpdateTestLog "Check value exists in WebTable", "WebTable object is not available.", "Fail"
	End If
	fnCheckWebElementValueExistInWebTable = blnEditValFound

End Function 
''##########################################################################################################################
'Function Name          :	fnPageDown
'Function Description   : 	sendkeys to down the page
'Input Parameters       : 	Number of times to down the page, element as object
'Return Value               : 	None
'Author                       : Cognizant
'Date Created              :  
'Status                        : Completed
'#######################################################################################################################
Function fnPageDown(intNum, objElement)
						Dim objWShell						
						Dim i					
						Set objWShell = CreateObject("WScript.Shell")  ' Creating object 
						wait(1)
						objElement.Click
						For i=1 to intNum
							objWShell.SendKeys "{PGDN}" 
							wait(1)	
						Next
						Set objWShell = Nothing					
End Function
''##########################################################################################################################
'Function Name          :	fnArrowDown
'Function Description   : 	sendkeys to arrow down
'Input Parameters       : 	Number of times to down the arrow, element as object
'Return Value               : 	None
'Author                       : Cognizant
'Date Created              :  
'Status                        : Completed
'#######################################################################################################################
Function fnArrowDown(intNum, objElement)
						Dim objWShell
						Dim i						
						Set objWShell = CreateObject("WScript.Shell")  ' Creating object 
						wait(1)
                        objElement.Click
						For i=1 to intNum								
								objWShell.SendKeys "{DOWN}" 
						Next
						wait(1)	
						Set objWShell = Nothing					
End Function

'#######################################################################################################################
'Function Name          : fnSelectWebCheckboxInWebTable
'Function Description   :  Select Checkbox in s web table
'Input Parameters       :  objWebTable - Webtable as Object , strHeaderVal - Header name, strMatchVal - string to match for selection
'Return Value               : NA
'Author                       : Cognizant
'Date Created              :  
'Status                        : Completed
'#######################################################################################################################

Function fnSelectWebCheckboxInWebTable(objWebTable, strHeaderVal, strMatchVal)

	Dim intRowCnt, intRow, intColumnCnt, intCol, intRows
	Dim strWebTableHeader
	Dim blnWebElementFound, blnRetVal
	Dim objWebCheckbox
	blnWebElementFound = False
	blnRetVal = fnWaitForObject(objWebTable, 30, "WebTable" )

	If blnRetVal Then
		'Get Row Count.
		intRowCnt = objWebTable.RowCount
		For intRow = 1 To intRowCnt
				'Get Column Count.
				intColumnCnt = objWebTable.ColumnCount(intRow)
				For intCol = 1 To intColumnCnt
					strWebTableHeader = objWebTable.GetCellData(intRow, intCol)
					If Trim(strWebTableHeader) = Trim(strHeaderVal) Then
							intRow = intRow + 1
							For intRows = intRow To intRowCnt
									If Trim(objWebTable.GetCelldata(intRows, intCol)) = Trim(strMatchVal) Then
			
										Set objWebCheckbox = objWebTable.ChildItem(intRows, 1, "WebCheckbox", 0)
										objWebCheckbox.Set "ON"
										fnSelectWebCheckboxInWebTable = True
										Set objWebCheckbox = Nothing							
										Exit Function
									End If
							Next
					End If
				Next
		Next
	Else
		gobjReport.UpdateTestLog "Search and select checkbox in WebTable", "WebTable object is not available.", "Fail"
	End If

	Set objWebCheckbox = Nothing
	fnSelectWebCheckboxInWebTable = blnWebElementFound
End Function


'#######################################################################################################################
'Function Name          :	fnVerifyFieldLength
'Function Description   : 	Verifies  teh Field Length of the specified field
'Input Parameters       : 	objName - Object, strObjName - Name of Object, blnOptionalVerify - Stops the iteration based on the boolean  value
'Return Value               : 	Boolean
'Author                       : Cognizant
'Date Created              :  
'Status                        : Completed
'#######################################################################################################################
Function fnVerifyFieldLength(objName, strObjName, blnOptionalVerify)
		Dim strValue
		If fnExist(objName,strObjName, blnOptionalVerify) Then
				If(Len(objName.GetROProperty("value")))<=(objName.GetROProperty("max length"))Then
					fnVerifyFieldLength = True			
                 Else
				   If blnOptionalVerify Then		
					gobjReport.UpdateTestLog  "Verify Field Length", strObjName &" Field Length is not matched " , "False"	
					ExitTestIteration
					End If
					fnVerifyFieldLength = False					
				End If
		End If		
End Function

