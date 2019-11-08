'#######################################################################################################################
'Script Description		: Framework Settings library
'Test Tool/Version		: HP Quick Test Professional 11+
'Test Tool Settings		: N.A.
'Application Automated	: N.A.
'Author					: Cognizant
'Date Created			: 30/07/2008
'#######################################################################################################################
Option Explicit	'Forcing Variable declarations

Dim gobjSettings: Set gobjSettings = New Settings

'#######################################################################################################################
'Class Description		: Class to encapsulate utility functions of the framework
'Author					: Cognizant
'Date Created			: 23/07/2012
'#######################################################################################################################
Class Settings
	
	'###################################################################################################################
	'Function Description	: Function to get configuration data from the Global Settings.xml
	'Input Parameters		: strKey
	'Return Value			: strValue
	'Author					: Cognizant
	'Date Created			: 02/04/2012
	'###################################################################################################################
	Public Function GetValue(strKey)
		Dim objQtpApp: Set objQtpApp = CreateObject("QuickTest.Application")
		Dim objXmlDoc: Set objXmlDoc = CreateObject("Microsoft.XMLDOM")
		Dim objAllnodes, objNode, objFirstNode, objValueNode, strQuery, strValue
		
		objXmlDoc.Load objQtpApp.Folders.Locate("Global Settings.xml")
		
		strQuery = "//Environment/Variable"
		Set objAllNodes = objXmlDoc.selectNodes(strQuery)
		If objAllNodes.length > 0 Then
			For Each objNode in objAllNodes
				Set objFirstNode = objNode.firstChild
				If objFirstNode.text = strKey Then
					Set objValueNode = objFirstNode.nextSibling
					strValue = objValueNode.Text
					Exit For
				End If
			Next
		End If
		
		Set objXmlDoc = Nothing
		Set objQtpApp = Nothing
		
		GetValue = CStr(strValue)
	End Function
	'###################################################################################################################
	
	'###################################################################################################################
	'Function Description	: Function to set configuration data to the Global Settings.xml
	'Input Parameters		: strKey, strValue
	'Return Value			: None
	'Author					: Cognizant
	'Date Created			: 02/04/2012
	'###################################################################################################################
	Public Sub SetValue(strKey, strValue)
		Dim objQtpApp: Set objQtpApp = CreateObject("QuickTest.Application")
		Dim objXmlDoc: Set objXmlDoc = CreateObject("Microsoft.XMLDOM")
		Dim objAllNodes, objNode, objFirstNode, objValueNode, strQuery
		
		objXmlDoc.Load objQtpApp.Folders.Locate("Global Settings.xml")
		
		strQuery = "//Environment/Variable"
		Set objAllNodes = objXmlDoc.selectNodes(strQuery)
		If objAllNodes.length > 0 Then
			For Each objNode in objAllNodes
				Set objFirstNode = objNode.firstChild
				If objFirstNode.text = strKey Then
					Set objValueNode = objFirstNode.nextSibling
					objValueNode.Text = strValue
					Exit For
				End If
			Next
			objXmlDoc.Save objQtpApp.Folders.Locate("Global Settings.xml")
		End If
		
		Set objXmlDoc = Nothing
		Set objQtpApp = Nothing
	End Sub
	'###################################################################################################################
	
End Class
'#######################################################################################################################