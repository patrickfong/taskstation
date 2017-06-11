@echo off
WMIC path win32_process where "CommandLine like '%%chrome.exe%%'" get CommandLine



