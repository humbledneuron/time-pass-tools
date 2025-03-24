# Git Status Checker

## Overview
This script scans all directories in the current location and checks their Git status. It generates a well-structured report (`git_status_report.txt`) that includes:
- Untracked, modified, or uncommitted files.
- Unpushed commits.
- Confirmation if all files are committed and pushed.

## Features
- Identifies all Git repositories in the current directory.
- Provides a detailed status of untracked, modified, or uncommitted files.
- Detects unpushed commits.
- Generates a neatly formatted report.

## Requirements
- Python 3.x
- Git installed and available in the system PATH

## Installation
1. Clone or download this repository.
2. Ensure Python and Git are installed on your system.

## Usage
1. Navigate to the directory where the script is located.
2. Run the script using:
   ```bash
   python check_git_status.py
   ```
3. View the generated `git_status_report.txt` file for the results.

## Example Output
```
Git Status Report
==================================================

Repository: my_project
--------------------------------------------------
Untracked/Modified/Uncommitted Files:
 M README.md

Unpushed Commits:
 abc1234 Fixed a bug in the authentication module

Repository: another_repo
--------------------------------------------------
✔ No untracked or modified files.
✔ All commits are pushed.
```

## License
This project is licensed under the MIT License.

## Contributions
Feel free to open an issue or submit a pull request for improvements!

