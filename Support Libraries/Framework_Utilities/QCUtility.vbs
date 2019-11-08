'#######################################################################################################################
'Script Description		: QCUtil class to manage integration with HP Quality Center/Application Lifecycle Management
'Test Tool/Version		: HP Quick Test Professional 11+
'Test Tool Settings		: N.A.
'Application Automated	: N.A.
'Author					: Cognizant
'Date Created			: 04/07/2011
'#######################################################################################################################
Option Explicit	'Forcing Variable declarations

Dim gobjQCUtility: Set gobjQCUtility = New QCUtility

'#######################################################################################################################
'Class Description		: Class to interact with QC/ALM
'Author					: Cognizant
'Date Created			: 23/09/2012
'#######################################################################################################################
Class QCUtility
	
	Private m_objQcConnection
	
	'###################################################################################################################
	Public Property Set QcConnection(objQcConnection)
		Set m_objQcConnection = objQcConnection
	End Property
	'###################################################################################################################
	
	
	'###################################################################################################################
	'Function Description	: Function to get the parent folder of the currently executing test
	'Input Parameters		: None
	'Return Value			: Parent folder of the currently executing test
	'Author					: Cognizant
	'Date Created			: 09/10/2012
	'###################################################################################################################
	Public Function GetCurrentTestParentFolder()
		Dim objCurrentTest: Set objCurrentTest = QCUtil.CurrentTest
		GetCurrentTestParentFolder = objCurrentTest.Field("TS_SUBJECT").Name
		Set objCurrentTest = Nothing
	End Function
	'###################################################################################################################
	
	'###################################################################################################################
	'Function Description	: Function to get the description of the currently executing test
	'Input Parameters		: None
	'Return Value			: Description of the currently executing test
	'Author					: Cognizant
	'Date Created			: 09/10/2008
	'###################################################################################################################
	Public Function GetCurrentTestDescription()
		Dim objCurrentTest: Set objCurrentTest = QCUtil.CurrentTest
		GetCurrentTestDescription = objCurrentTest.Field("TS_DESCRIPTION")
		Set objCurrentTest = Nothing
	End Function
	'###################################################################################################################
	
	'###################################################################################################################
	'Function Description	: Function to get the specified user field value of the currently executing test
	'Input Parameters		: None
	'Return Value			: User field value of the currently executing test
	'Author					: Cognizant
	'Date Created			: 17/07/2013
	'###################################################################################################################
	Public Function GetCurrentTestUserFieldValue(strUserField)
		Dim objCurrentTest: Set objCurrentTest = QCUtil.CurrentTest
		GetCurrentTestUserFieldValue = objCurrentTest.Field(strUserField)
		Set objCurrentTest = Nothing
	End Function
	'###################################################################################################################
	
	'###################################################################################################################
	'Function Description	: Function to update an existing file within the test resources module
	'Input Parameters		: strFileName, strResourceFolderPath
	'Return Value			: None
	'Author					: Cognizant
	'Date Created			: 11/10/2012
	'###################################################################################################################
	Public Sub UpdateFileInTestResources(strFileName, strResourceFolderPath)
		Dim objQcResourceFolder: Set objQcResourceFolder = GetResourceFolderByPath(strResourceFolderPath)
		
		Dim objQcConnection: Set objQcConnection = m_objQcConnection
		Dim objQcResourceFactory: Set objQcResourceFactory = objQcConnection.QCResourceFactory
		Dim objQcResourceFilter: Set objQcResourceFilter = objQcResourceFactory.Filter
		objQcResourceFilter.Filter("RSC_PARENT_ID") = objQcResourceFolder.id
		objQcResourceFilter.Filter("RSC_NAME") = "'" & strFileName & "'"
		
		Dim strResourceFolderClientPath, strResourceFileClientPath
		strResourceFileClientPath = PathFinder.Locate(strResourceFolderPath & "\" & strFileName)
		strResourceFolderClientPath = Left(strResourceFileClientPath, Len(strResourceFileClientPath) - Len(strFileName) - 1)
		
		Dim objQcResourceList, objQcResource
		Set objQcResourceList = objQcResourceFilter.NewList()
		If objQcResourceList.Count = 1 Then
			Set objQcResource = objQcResourceList.Item(1)
			objQcResource.Filename = strFileName
			objQcResource.Post
			objQcResource.UploadResource strResourceFolderClientPath, True
		Else
			Err.Raise 5003, "QCUtility", "The given resource was not found in the test resources module!"
		End If
		
		'Release all objects
		Set objQcResource = Nothing
		Set objQcResourceList = Nothing
		Set objQcResourceFilter = Nothing
		Set objQcResourceFactory = Nothing
		Set objQcResourceFolder = Nothing
		Set objQcConnection = Nothing
	End Sub
	'###################################################################################################################
	
	'###################################################################################################################
	Private Function GetResourceFolderByPath(strFolderPath)
		CheckQcConnection()
		
		Dim objQcConnection: Set objQcConnection = m_objQcConnection
		Dim objQcResourceFolderFactory: Set objQcResourceFolderFactory = objQcConnection.QCResourceFolderFactory
		Dim objQcResourceFolder: Set objQcResourceFolder = objQcResourceFolderFactory.Root
		
		'Navigate the resources tree to locate the datatable resource
		Dim intCurrentFolder, intCurrentResourceFolder
		intCurrentResourceFolder = 0
		Dim arrFolders
		arrFolders = Split(strFolderPath, "\")
		For intCurrentFolder = 0 To UBound(arrFolders)
			If Len(arrFolders(intCurrentFolder)) > 0 Then 'Skip over empty strings caused by leading/trailing "\"s as well as multiple "\"s
				For intCurrentResourceFolder = 1 To objQcResourceFolder.Count 'Iterate over the children of the current folder
					If objQcResourceFolder.Child(intCurrentResourceFolder).Type = 10 _
					And objQcResourceFolder.Child(intCurrentResourceFolder).Name = arrFolders(intCurrentFolder) Then
						Set objQcResourceFolder = objQcResourceFolder.Child(intCurrentResourceFolder)
						Exit For
					End If
				Next
			End If
		Next
		
		Set GetResourceFolderByPath = objQcResourceFolder
		
		If objQcResourceFolder.Name = objQcResourceFolderFactory.Root.Name Then
			Err.Raise 5002, "QCUtility", "The given folder was not found in the test resources module!"
		End If
		
		'Release all objects
		Set objQcResourceFolder = Nothing
		Set objQcResourceFolderFactory = Nothing
		Set objQcConnection = Nothing
	End Function
	'###################################################################################################################
	
	'###################################################################################################################
	Private Sub CheckQcConnection()
		If IsEmpty(m_objQcConnection) Then
			Err.Raise 5001, "QCUtility", "QC connection unavailable!"
		End If
	End Sub
	'###################################################################################################################
	
	'###################################################################################################################
	'Function Description	: Function to get the list of files and folders within the specified Test Resources folder
	'Input Parameters		: strFolderPath
	'Return Value			: None
	'Author					: Cognizant
	'Date Created			: 11/10/2012
	'###################################################################################################################
	Public Sub GetChildrenOfTestResourcesFolder(strFolderPath, arrChildFolderList(), arrChildFileList())
		Dim objQcResourceParentFolder: Set objQcResourceParentFolder = GetResourceFolderByPath(strFolderPath)
		Dim intFolderCount, intFileCount
		intFolderCount = 0
		intFileCount = 0
		
		Dim i, objQcResourceFolder, objQcResourceFile
		For i = 1 To objQcResourceParentFolder.Count	'Iterate over the children of the current folder
			If objQcResourceParentFolder.Child(i).Type = 10 Then
				Set objQcResourceFolder = objQcResourceParentFolder.Child(i)
				Redim Preserve arrChildFolderList(intFolderCount)
				arrChildFolderList(intFolderCount) = objQcResourceFolder.Name
				intFolderCount = intFolderCount + 1
			Else
				Set objQcResourceFile = objQcResourceParentFolder.Child(i)
				Redim Preserve arrChildFileList(intFileCount)
				arrChildFileList(intFileCount) = objQcResourceFile.FileName
				intFileCount = intFileCount + 1
			End If
		Next
		
		'Release all objects
		Set objQcResourceFolder = Nothing
		Set objQcResourceFile = Nothing
		Set objQcResourceParentFolder = Nothing
	End Sub
	'###################################################################################################################
	
	'###################################################################################################################
	'Function Description	: Function to attach all files within the given folder to the current test run (in test lab)
	'Input Parameters		: strFolderPath
	'Return Value			: None
	'Author					: Cognizant
	'Date Created			: 11/10/2012
	'###################################################################################################################
	Public Sub AttachFolderToTestRun(strFolderPath)
		Dim objFso: Set objFso = CreateObject("Scripting.FileSystemObject")
		Dim objFolder: Set objFolder = objFso.GetFolder(strFolderPath)
		Dim objFileList: Set objFileList = objFolder.Files
		Dim objFile
		For each objFile in objFileList
			AttachFileToTestRun objFile.Path
		Next
		
		'Release all objects
		Set objFile = Nothing
		Set objFileList = Nothing
		Set objFolder = Nothing
		Set objFso = Nothing
	End Sub
	'###################################################################################################################
	
	'###################################################################################################################
	'Function Description	: Function to attach the specified file to the current test run (in test lab)
	'Input Parameters		: strFilePath
	'Return Value			: None
	'Author					: Cognizant
	'Date Created			: 11/10/2012
	'###################################################################################################################
	Public Sub AttachFileToTestRun(strFilePath)
		Dim objFso: Set objFso = CreateObject("Scripting.FileSystemObject")
		If Not objFso.FileExists(strFilePath) Then
			Err.Raise 5004, "QCUtility", "The given file to be attached is not found!"
		End If
		Set objFso = Nothing
		
		Dim objFoldAttachments: Set objFoldAttachments =  QCUtil.CurrentRun.Attachments
		Dim objFoldAttachment: Set objFoldAttachment = objFoldAttachments.AddItem(Null)
		objFoldAttachment.FileName = strFilePath
		objFoldAttachment.Type = 1
		objFoldAttachment.Post
		
		Set objFoldAttachment = Nothing
		Set objFoldAttachments = Nothing
	End Sub
	'###################################################################################################################
	
End Class
'#######################################################################################################################