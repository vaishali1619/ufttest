'#######################################################################################################################
'Script Description		: Timestamp class for report
'Test Tool/Version		: HP Quick Test Professional 11+
'Test Tool Settings		: N.A.
'Application Automated	: N.A.
'Author					: Cognizant
'Date Created			: 04/07/2011
'#######################################################################################################################
Option Explicit	'Forcing Variable declarations

Dim gobjTimeStamp : Set gobjTimeStamp = New TimeStamp

'#######################################################################################################################
'Class Description		: Class to encapsulate utility functions of the framework
'Author					: Cognizant
'Date Created			: 23/07/2012
'#######################################################################################################################
Class TimeStamp
	
	Private m_strReportPathWithTimeStamp
	
	'###################################################################################################################
	'Function Description	: Function to calculate the execution time for the current iteration	
	'Input Parameters		: None
	'Return Value			: None	
	'Author					: Cognizant	
	'Date Created			: 07/11/2012
	'###################################################################################################################
	Public Function GetInstance()
		If m_strReportPathWithTimeStamp = "" Then
			Dim objFso : Set objFso = CreateObject("Scripting.FileSystemObject")
			
			Dim strRunConfigurationPath
			strRunConfigurationPath = gobjFrameworkParameters.RelativePath & "\Results\" &_
																				gobjFrameworkParameters.RunConfiguration
			If Not objFso.FolderExists(strRunConfigurationPath) Then
				objFso.CreateFolder(strRunConfigurationPath)
			End If
			
			Dim strTimeStamp
			strTimeStamp = "Run" & "_" & Replace(Date(),"/","-") & "_" & Replace(Time(),":","-")
			m_strReportPathWithTimeStamp = strRunConfigurationPath & "\" & strTimeStamp
			
			If Not objFso.FolderExists(m_strReportPathWithTimeStamp) Then
				objFso.CreateFolder(m_strReportPathWithTimeStamp)
			End If
			Set objFso = Nothing
		End If
		
		GetInstance = m_strReportPathWithTimeStamp
	End Function
	'###################################################################################################################
	
End Class
'#######################################################################################################################