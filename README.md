# Ikarus Parkour Save Manager

A simple batch script tool for managing save files in the game *Ikarus Parkour*. It allows creating, restoring, viewing, deleting, and renaming backups of your game saves, with support for Casual and Normal difficulties. Also includes an option to launch the game and restore the last selected save (persisted across sessions).

Created by InfaReQt.

## Features
- **Create a new save**: Backup your current save files for the selected difficulty and name it.
- **Restore a save**: View and select a backup to restore to the game's save folder.
- **Manage saves**: View list of backups, with options to delete or rename a selected save.
- **Launch game**: Start the game via Steam (editable for non-Steam versions).
- **Restore last save**: Quickly restore the most recently selected save (remembers even after closing the tool, via a small text file).
- Color-coded interface for better usability (e.g., yellow title, green success messages, red errors).

## Requirements
- Windows OS (tested on Windows 10/11).
- The game *Ikarus Parkour* installed, with saves in `C:\Users\<YourUsername>\AppData\Local\PixelFPS\Saved\SaveGames`.
- No additional software needed—the script uses built-in Windows commands.

## How to Use
1. Download the `IkarusSaveManager.bat` file from this repository.
2. Double-click the .bat file to run it (or run via Command Prompt: `IkarusSaveManager.bat`).
3. The menu will appear:
   - [1] Create a new save: Select difficulty (1=Casual, 2=Normal), enter a name, and it backs up the files to a "Backups" folder.
   - [2] Restore a save: View list, select by number to overwrite the current save.
   - [3] Manage saves (view, delete, rename): Shows backups; then choose D to delete, R to rename, or B to go back.
   - [4] Launch game: Attempts to launch via Steam (edit the script's `:launch_game` section if needed, e.g., for a direct executable path).
   - [5] Restore last save: Restores the most recently restored save (if any).
   - [6] Exit: Closes the tool.
4. Follow on-screen prompts. Press Enter to continue after actions.

**Notes**:
- Backups are stored in `<base_path>\Backups` as folders named `<difficulty>_<name>`.
- The last restored save is stored in `<base_path>\Backups\last_restore.txt` for persistence across sessions.
- The script doesn't handle game restarts yet—test if needed after restoring saves.
- Edit the script (right-click > Edit) for customizations, like changing the launch command.
- Always back up your original saves manually before using!
- If colors don't display properly, run in Command Prompt.

## Troubleshooting
- **Path not found**: Ensure the game is installed and the save path matches.
- **Permission issues**: Run as administrator if file copying fails.
- **Game not launching**: Confirm Steam app ID (3167280) or replace with executable path in the script.
- **No previous restore**: The "Restore last save" option will show an error if no prior restore has been done.

For issues or suggestions, open an issue on this repo.
