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
:: Last restore file
set "last_restore_file=%backups_path%\last_restore.txt"
:: Log file
set "log_file=%backups_path%\save_manager.log"
call :log "Script started."
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
echo [3] Manage saves (view, delete, rename)
echo [4] Launch game
echo [5] Restore last save
echo [6] Exit
:: White for input prompt
color 07
set /p choice=Enter your choice:
if "%choice%"=="1" goto create_save
if "%choice%"=="2" goto restore_save
if "%choice%"=="3" goto manage_saves
if "%choice%"=="4" goto launch_game
if "%choice%"=="5" goto restore_last
if "%choice%"=="6" goto end
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
set /p diff_choice=Select difficulty (1 for Casual, 2 for Hard):
if "%diff_choice%"=="1" (
    set "diff_folder=Casual"
    set "diff_display=Casual"
)
if "%diff_choice%"=="2" (
    set "diff_folder=Normal"
    set "diff_display=Hard"
)
if not defined diff_folder (
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
set "save_dir=%backups_path%\%diff_folder%_%name%"
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
call :log "Creating save: %diff_folder%_%name%"
set "source_dir=%base_path%\%diff_folder%"
if not exist "%source_dir%" (
    :: Red for error
    color 0C
    echo Source directory for %diff_display% does not exist.
    color 07
    call :log "Source directory %source_dir% does not exist."
    echo Press enter to continue...
    set /p _dummy=
    goto menu
)
call :log "Copying from %source_dir% to %save_dir%"
copy "%source_dir%\Level.sav" "%save_dir%" >> "%log_file%" 2>&1
copy "%source_dir%\Player.sav" "%save_dir%" >> "%log_file%" 2>&1
copy "%source_dir%\Slot.sav" "%save_dir%" >> "%log_file%" 2>&1
set copy_success=1
if not exist "%save_dir%\Level.sav" (
    set copy_success=0
    call :log "Failed to copy Level.sav"
)
if not exist "%save_dir%\Player.sav" (
    set copy_success=0
    call :log "Failed to copy Player.sav"
)
if not exist "%save_dir%\Slot.sav" (
    set copy_success=0
    call :log "Failed to copy Slot.sav"
)
if %copy_success%==0 (
    :: Red for error
    color 0C
    echo Failed to create save - some files could not be copied.
    color 07
    rd /s /q "%save_dir%"
    call :log "Failed to create save - removed directory."
) else (
    :: Green for success
    color 0A
    echo Save '%name%' for %diff_display% created successfully.
    color 07
    call :log "Save created successfully."
)
echo Press enter to continue...
set /p _dummy=
goto menu
:manage_saves
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
        set "display_diff=%%a"
        if /i "%%a"=="Normal" set "display_diff=Hard"
        echo [!count!] !display_diff!: %%b
    )
)
color 07
if %count%==0 echo No saves found.
echo.
:: Green for options
color 0A
echo Options:
echo [D] Delete a save
echo [R] Rename a save
echo [B] Back to menu
color 07
set /p manage_choice=Enter your choice (D/R/B):
if /i "%manage_choice%"=="B" goto menu
if /i "%manage_choice%"=="D" goto delete_save
if /i "%manage_choice%"=="R" goto rename_save
:: Red for error
color 0C
echo Invalid choice.
color 07
echo Press enter to continue...
set /p _dummy=
goto manage_saves
:delete_save
if %count%==0 (
    echo No saves to delete.
    echo Press enter to continue...
    set /p _dummy=
    goto manage_saves
)
set /p del_num=Enter the number of the save to delete (0 to cancel):
if "%del_num%"=="0" goto manage_saves
if %del_num% leq 0 goto invalid_del
if %del_num% gtr %count% goto invalid_del
set "selected=!saves[%del_num%]!"
call :log "Deleting save: !selected!"
rd /s /q "%backups_path%\!selected!" >> "%log_file%" 2>&1
:: Green for success
color 0A
echo Save '!selected!' deleted successfully.
color 07
echo Press enter to continue...
set /p _dummy=
goto manage_saves
:invalid_del
:: Red for error
color 0C
echo Invalid selection.
color 07
echo Press enter to continue...
set /p _dummy=
goto manage_saves
:rename_save
if %count%==0 (
    echo No saves to rename.
    echo Press enter to continue...
    set /p _dummy=
    goto manage_saves
)
set /p ren_num=Enter the number of the save to rename (0 to cancel):
if "%ren_num%"=="0" goto manage_saves
if %ren_num% leq 0 goto invalid_ren
if %ren_num% gtr %count% goto invalid_ren
set "selected=!saves[%ren_num%]!"
for /f "tokens=1 delims=_" %%a in ("!selected!") do set "diff_folder=%%a"
set /p new_name=Enter a new name for this save:
if "%new_name%"=="" (
    :: Red for error
    color 0C
    echo Name cannot be empty.
    color 07
    echo Press enter to continue...
    set /p _dummy=
    goto manage_saves
)
set "new_save_dir=%backups_path%\%diff_folder%_%new_name%"
if exist "%new_save_dir%" (
    :: Red for error
    color 0C
    echo A save with this name and difficulty already exists.
    color 07
    echo Press enter to continue...
    set /p _dummy=
    goto manage_saves
)
call :log "Renaming save: !selected! to %diff_folder%_%new_name%"
ren "%backups_path%\!selected!" "%diff_folder%_%new_name%" >> "%log_file%" 2>&1
:: Green for success
color 0A
echo Save '!selected!' renamed to '%new_name%' successfully.
color 07
echo Press enter to continue...
set /p _dummy=
goto manage_saves
:invalid_ren
:: Red for error
color 0C
echo Invalid selection.
color 07
echo Press enter to continue...
set /p _dummy=
goto manage_saves
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
        set "display_diff=%%a"
        if /i "%%a"=="Normal" set "display_diff=Hard"
        echo [!count!] !display_diff!: %%b
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
call :log "Restoring save: !selected!"
for /f "tokens=1 delims=_" %%a in ("!selected!") do set "diff_folder=%%a"
set "target_dir=%base_path%\!diff_folder!"
set "save_dir=%backups_path%\!selected!"
call :log "Target dir: %target_dir%"
call :log "Save dir: %save_dir%"
if not exist "%target_dir%" (
    mkdir "%target_dir%"
    call :log "Created target dir: %target_dir%"
)
call :log "Deleting existing files in target..."
del /q "%target_dir%\Level.sav" >> "%log_file%" 2>&1
del /q "%target_dir%\Player.sav" >> "%log_file%" 2>&1
del /q "%target_dir%\Slot.sav" >> "%log_file%" 2>&1
call :log "Copying files..."
copy "%save_dir%\Level.sav" "%target_dir%" >> "%log_file%" 2>&1
copy "%save_dir%\Player.sav" "%target_dir%" >> "%log_file%" 2>&1
copy "%save_dir%\Slot.sav" "%target_dir%" >> "%log_file%" 2>&1
set copy_success=1
if not exist "%target_dir%\Level.sav" (
    set copy_success=0
    call :log "Failed to copy Level.sav"
)
if not exist "%target_dir%\Player.sav" (
    set copy_success=0
    call :log "Failed to copy Player.sav"
)
if not exist "%target_dir%\Slot.sav" (
    set copy_success=0
    call :log "Failed to copy Slot.sav"
)
if %copy_success%==0 (
    :: Red for error
    color 0C
    echo Failed to restore some files for '!selected!'.
    color 07
    call :log "Restore failed."
) else (
    echo !selected! > "%last_restore_file%"
    call :log "Updated last_restore.txt with !selected!"
    :: Green for success
    color 0A
    echo Save '!selected!' restored successfully.
    color 07
    call :log "Restore successful."
)
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
:restore_last
cls
:: Gold/yellow for title/art
color 0E
echo =====================================
echo Ikarus Parkour Save Manager
echo Created by InfaReQt
echo =====================================
color 07
echo.
if not exist "%last_restore_file%" (
    :: Red for error
    color 0C
    echo No previous restore found.
    color 07
    call :log "No previous restore found."
    echo Press enter to continue...
    set /p _dummy=
    goto menu
)
for /f "delims=" %%a in ('type "%last_restore_file%"') do set "selected=%%a"
:rtrim_selected
if "!selected:~-1!"==" " (
    set "selected=!selected:~0,-1!"
    goto rtrim_selected
)
call :log "Restoring last save: !selected!"
set "save_dir=%backups_path%\!selected!"
if not exist "%save_dir%" (
    :: Red for error
    color 0C
    echo Last restored save '!selected!' no longer exists.
    color 07
    call :log "Last save directory does not exist: %save_dir%"
    echo Press enter to continue...
    set /p _dummy=
    goto menu
)
for /f "tokens=1 delims=_" %%a in ("!selected!") do set "diff_folder=%%a"
set "target_dir=%base_path%\!diff_folder!"
call :log "Target dir: %target_dir%"
call :log "Save dir: %save_dir%"
if not exist "%target_dir%" (
    mkdir "%target_dir%"
    call :log "Created target dir: %target_dir%"
)
call :log "Deleting existing files in target..."
del /q "%target_dir%\Level.sav" >> "%log_file%" 2>&1
del /q "%target_dir%\Player.sav" >> "%log_file%" 2>&1
del /q "%target_dir%\Slot.sav" >> "%log_file%" 2>&1
call :log "Copying files..."
copy "%save_dir%\Level.sav" "%target_dir%" >> "%log_file%" 2>&1
copy "%save_dir%\Player.sav" "%target_dir%" >> "%log_file%" 2>&1
copy "%save_dir%\Slot.sav" "%target_dir%" >> "%log_file%" 2>&1
set copy_success=1
if not exist "%target_dir%\Level.sav" (
    set copy_success=0
    call :log "Failed to copy Level.sav"
)
if not exist "%target_dir%\Player.sav" (
    set copy_success=0
    call :log "Failed to copy Player.sav"
)
if not exist "%target_dir%\Slot.sav" (
    set copy_success=0
    call :log "Failed to copy Slot.sav"
)
if %copy_success%==0 (
    :: Red for error
    color 0C
    echo Failed to restore some files for '!selected!'.
    color 07
    call :log "Restore last failed."
) else (
    :: Green for success
    color 0A
    echo Last save '!selected!' restored successfully.
    color 07
    call :log "Restore last successful."
)
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
call :log "Launching game."
echo Press enter to continue...
set /p _dummy=
goto menu
:log
echo [%date% %time%] %* >> "%log_file%"
goto :eof
:end
:: Reset color to default
color 07
echo Exiting...
call :log "Script ended."
endlocal
