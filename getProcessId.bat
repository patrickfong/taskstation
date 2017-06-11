@echo off
rem "C:\Program Files\Google\Chrome\Application\chrome.exe"  --profile-directory="Profile 1" --app-id=aldkomclnjkdfoaocfcdilclcbgllbkg
WMIC path win32_process where "CommandLine like '%%chrome.exe%%'" get CommandLine



