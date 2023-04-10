Set wshShell = CreateObject("Wscript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")
datadir = fso.GetParentFolderName(WScript.ScriptFullName)

' Use the FileSystemObject to search for the XML file in the %temp% folder
Set tempFolder = fso.GetFolder(fso.GetSpecialFolder(2))
Set files = tempFolder.Files
For Each file In files
    If LCase(fso.GetExtensionName(file.Name)) = "xml" Then
        xmlFile = file.Path
        Exit For
    End If
Next

' If an XML file was found, pass its path as a parameter to wac.exe
If Not IsEmpty(xmlFile) Then
    wshShell.Run datadir & "\wac.exe """ & xmlFile & """"
End If


wshShell.AppActivate "wac"
Wscript.Sleep 7000


' MAXIMIZE WAC WINDOW
wshShell.SendKeys "% "
wshShell.SendKeys "{DOWN 4}"
wshShell.SendKeys "{ENTER}"


' LOCATE & EXPAND BATTERY/PROJECTED RESULTS
wshShell.SendKeys "{TAB 12}"
wshShell.SendKeys "{DOWN}"
wshShell.SendKeys "{LEFT}"
wshShell.SendKeys "{DOWN 6}"
wshShell.SendKeys "{RIGHT}"
wshShell.SendKeys "{DOWN 9}"
wshShell.SendKeys "{RIGHT}"
wshShell.SendKeys "{UP 15}"
wshShell.SendKeys "{PGDN}"
