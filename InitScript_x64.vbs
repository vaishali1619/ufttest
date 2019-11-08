'#####################################################################################################################
'Script Description		: Initialization Script for 64 bit machines
'Test Tool/Version		: HP Quick Test Professional 11+
'Test Tool Settings		: N.A.
'Application Automated	: N.A.
'Author					: Cognizant
'Date Created			: 09/11/2013
'#####################################################################################################################
Option Explicit	'Forcing Variable declarations

Dim gobjFso, gstrRelativePath

Set gobjFso = CreateObject("Scripting.FileSystemObject")
gstrRelativePath = gobjFso.GetParentFolderName(WScript.ScriptFullName)

'Launch the Init Script using the 64 bit wscript.exe
Dim gobjShell: Set gobjShell = WScript.CreateObject("WScript.Shell")
gobjShell.Run "C:\Windows\SysWOW64\wscript " & Chr(34) & gstrRelativePath & "\InitScript.vbs" & Chr(34)

'Release all objects
Set gobjShell = Nothing
Set gobjFso = Nothing
'#######################################################################################################################