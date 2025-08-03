```batch
@echo off
setlocal enabledelayedexpansion
:: Set default color to white text on black background
color 07
:: Get username
set "username=%USERNAME%"
:: Base save path
set "base_path=C:\Users\%username%\AppData\Local\PixelFPS\Saved\SaveGames"
:: Backups path
set "backups_path=%base_path%\Backups"
if not exist "%backups_path%" mkdir "%backups_path%"
goto menu
:menu
cls
:: Gold/yellow for title/art
color 0E
echo =====================================
echo Ikarus Parkour Save Manager
echo Created by InfaReQt
echo =====================================
:: Green for menu options
color 0A
echo.
echo [1] Create a new save
echo [2] Restore a save
echo [3] View list of saves and delete
echo [4] Launch game
echo [5] Exit
:: White for input prompt
color 07
set /p choice=Enter your choice:
if "%choice%"=="1" goto create_save
if "%choice%"=="2" goto restore_save
if "%choice%"=="3" goto view_delete
if "%choice%"=="4" goto launch_game
if "%choice%"=="5" goto end
:: Red for error
color 0C
echo Invalid choice.
color 07
echo Press enter to continue...
set /p _dummy=
goto menu
:create_save
cls
:: Gold/yellow for title/art
color 0E
echo =====================================
echo Ikarus Parkour Save Manager
echo Created by InfaReQt
echo =====================================
color 07
echo.
set /p diff_choice=Select difficulty (1 for Casual, 2 for Normal):
if "%diff_choice%"=="1" set "diff=Casual"
if "%diff_choice%"=="2" set "diff=Normal"
if not defined diff (
    :: Red for error
    color 0C
    echo Invalid choice.
    color 07
    echo Press enter to continue...
    set /p _dummy=
    goto menu
)
set /p name=Enter a name for this save:
if "%name%"=="" (
    :: Red for error
    color 0C
    echo Name cannot be empty.
    color 07
    echo Press enter to continue...
    set /p _dummy=
    goto menu
)
set "save_dir=%backups_path%\%diff%_%name%"
if exist "%save_dir%" (
    :: Red for error
    color 0C
    echo A save with this name and difficulty already exists.
    color 07
    echo Press enter to continue...
    set /p _dummy=
    goto menu
)
mkdir "%save_dir%"
set "source_dir=%base_path%\%diff%"
copy "%source_dir%\Level.sav" "%save_dir%" >nul 2>&1
copy "%source_dir%\Player.sav" "%save_dir%" >nul 2>&1
copy "%source_dir%\Slot.sav" "%save_dir%" >nul 2>&1
:: Green for success
color 0A
echo Save '%name%' for %diff% created successfully.
color 07
echo Press enter to continue...
set /p _dummy=
goto menu
:view_delete
cls
:: Gold/yellow for title/art
color 0E
echo =====================================
echo Ikarus Parkour Save Manager
echo Created by InfaReQt
echo =====================================
color 07
echo.
echo List of saves:
set count=0
for /d %%d in ("%backups_path%\*") do (
    set /a count+=1
    set "saves[!count!]=%%~nxd"
    :: Cyan for list items
    color 0B
    for /f "tokens=1,2 delims=_" %%a in ("%%~nxd") do (
        echo [!count!] %%a: %%b
    )
)
color 07
if %count%==0 echo No saves found.
set /p del_choice=Do you want to delete a save? (y/n):
if /i not "%del_choice%"=="y" goto menu
set /p del_num=Enter the number of the save to delete (0 to cancel):
if "%del_num%"=="0" goto menu
if %del_num% leq 0 goto invalid_del
if %del_num% gtr %count% goto invalid_del
set "selected=!saves[%del_num%]!"
rd /s /q "%backups_path%\!selected!"
:: Green for success
color 0A
echo Save '!selected!' deleted successfully.
color 07
echo Press enter to continue...
set /p _dummy=
goto menu
:invalid_del
:: Red for error
color 0C
echo Invalid selection.
color 07
echo Press enter to continue...
set /p _dummy=
goto menu
:restore_save
cls
:: Gold/yellow for title/art
color 0E
echo =====================================
echo Ikarus Parkour Save Manager
echo Created by InfaReQt
echo =====================================
color 07
echo.
echo List of saves:
set count=0
for /d %%d in ("%backups_path%\*") do (
    set /a count+=1
    set "saves[!count!]=%%~nxd"
    :: Cyan for list items
    color 0B
    for /f "tokens=1,2 delims=_" %%a in ("%%~nxd") do (
        echo [!count!] %%a: %%b
    )
)
color 07
if %count%==0 (
    echo No saves found.
    echo Press enter to continue...
    set /p _dummy=
    goto menu
)
set /p res_num=Enter the number of the save to restore (0 to cancel):
if "%res_num%"=="0" goto menu
if %res_num% leq 0 goto invalid_res
if %res_num% gtr %count% goto invalid_res
set "selected=!saves[%res_num%]!"
for /f "tokens=1 delims=_" %%a in ("!selected!") do set "diff=%%a"
set "target_dir=%base_path%\!diff!"
set "save_dir=%backups_path%\!selected!"
copy "%save_dir%\Level.sav" "%target_dir%" >nul 2>&1
copy "%save_dir%\Player.sav" "%target_dir%" >nul 2>&1
copy "%save_dir%\Slot.sav" "%target_dir%" >nul 2>&1
:: Green for success
color 0A
echo Save '!selected!' restored successfully.
color 07
echo Press enter to continue...
set /p _dummy=
goto menu
:invalid_res
:: Red for error
color 0C
echo Invalid selection.
color 07
echo Press enter to continue...
set /p _dummy=
goto menu
:launch_game
cls
:: Gold/yellow for title/art
color 0E
echo =====================================
echo Ikarus Parkour Save Manager
echo Created by InfaReQt
echo =====================================
color 07
echo.
:: Assuming Steam launch; edit if needed
start steam://run/3167280
:: Green for action
color 0A
echo Launching game via Steam...
color 07
echo Press enter to continue...
set /p _dummy=
goto menu
:end
:: Reset color to default
color 07
echo Exiting...
endlocal
```