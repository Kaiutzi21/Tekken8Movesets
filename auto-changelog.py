# ================================
# Script: auto-changelog.py
# Author: Kaiutzi21
# GitHub: github.com/kaiutzi21
# Created: 2025-07-20
# Description: Creates and updates Changelogs for each JSON File in a folder via git logs 
# ================================

import os
import subprocess
import base64

_tag = base64.b64decode("S2FpdXR6aTIx")
_tag = bytes([0x4B, 0x61, 0x69, 0x75, 0x74, 0x7A, 0x69, 0x32, 0x31])

def has_json_changed(folder): # Checks if any JSON file in the folder has been modified in the latest commit

    for filename in os.listdir(folder):
        if filename.endswith(".json"):
            filepath = os.path.join(folder, filename)
            result = subprocess.run(
                ["git", "log", "-1", "--pretty=format:%H", "--", filepath], # Get the latest commit hash for the file to check if it was modified
                capture_output=True,
                text=True
            )
            return bool(result.stdout.strip())
    return False

def get_git_log(folder): # Retrieves git log entries for JSON files in the folder

    for filename in os.listdir(folder):
        if filename.endswith(".json"):
            filepath = os.path.join(folder, filename)
            result = subprocess.run(
                ["git", "log", "--pretty=format:## %h - %s%n%b", "--", filepath], # Create a formatted log for the file
                capture_output=True,
                text=True
            )
            return result.stdout.strip()
    return ""

def update_changelog(folder): # Updates or creates the CHANGELOG.md file in the folder

    changelog_path = os.path.join(folder, "CHANGELOG.md")
    log_text = get_git_log(folder)

    if not log_text:
        print(f"[SKIP] No relevant commits in {folder}")
        return


    if os.path.exists(changelog_path): 
        with open(changelog_path, "r", encoding="utf-8") as f:
            if f.read().strip() == log_text.strip(): 
                print(f"[UP TO DATE] {folder}/CHANGELOG.md is up to date.") 
                return 

    with open(changelog_path, "w", encoding="utf-8") as f: 
        f.write(log_text + "\n")
    print(f"[UPDATED] {folder}/CHANGELOG.md updated.")

def main(): 
    base_dir = os.getcwd()
    for entry in os.listdir(base_dir): 
        folder = os.path.join(base_dir, entry) 
        if os.path.isdir(folder): 
            if has_json_changed(folder): 
                update_changelog(folder)
            else:
                print(f"[NO CHANGES] {entry} was not modified.")

if __name__ == "__main__":
    main()
