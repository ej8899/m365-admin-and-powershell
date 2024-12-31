
REM                   _       _       _                                      
REM    ___ _ __ _ __ (_) ___ (_) ___ | |__  _ __  ___  ___  _ __    ___ __ _ 
REM   / _ \ '__| '_ \| |/ _ \| |/ _ \| '_ \| '_ \/ __|/ _ \| '_ \  / __/ _` |
REM  |  __/ |  | | | | |  __/| | (_) | | | | | | \__ \ (_) | | | || (_| (_| |
REM   \___|_|  |_| |_|_|\___|/ |\___/|_| |_|_| |_|___/\___/|_| |_(_)___\__,_|
REM                        |__/                                              
REM  erniejohnson.ca | 2024-12-31
REM  Use this to help reset identify conflicts in an M365 joined device.
REM 
REM  Make sure this saves as plain ASCII - if you get strange characters showing
REM  up, its due to improper encoding.  You dont want BOM encoding.

REM *
REM kill running processes that would interfere
REM *
tskill WINWORD
tskill EXCEL
tskill OUTLOOK
tskill MSACCESS
tskill MSPUB
tskill POWERPNT
tskill PROJIMPT
tskill VISIO
tskill WINPROJ
tskill msteams
tskill ms-teams
tskill msedge
tskill microsoft.sharepoint
tskill onedrive

REM *
REM REMOVE FOLDERS & FILES
REM *
rd /s /q "%localappdata%\Microsoft\OneAuth"
rd /s /q "%localappdata%\Microsoft\IdentityCache"
rd /s /q "%localappdata%\Microsoft\Credentials"
rd /s /q "%localappdata%\Microsoft\TokenBroker"

forfiles /P "%localappdata%\Packages" /M "Microsoft.AAD.*" /C "cmd /c rd /s /q @path"
forfiles /P "%localappdata%\Packages" /M "Microsoft.AccountsControl*" /C "cmd /c rd /s /q @path"
forfiles /P "%localappdata%\Packages" /M "Microsoft.Windows.CloudExperienceHost*" /C "cmd /c rd /s /q @path"

REM *
REM registry cleanup
REM *
reg delete "HKCU\Software\Microsoft\Office" /f
reg delete "HKCU\Software\Microsoft\Exchange" /f
reg delete "HKCU\Software\Microsoft\Onedrive" /f

for /F "tokens=1,2 delims= " %%G in ("cmdkey /list | findstr Target") do cmdkey /delete %%H

REM *
REM force a new login 
REM *
logoff
