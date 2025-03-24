import os
import subprocess

output_file = "git_status_report.txt"

with open(output_file, "w") as f:
    f.write("Git Status Report\n")
    f.write("=" * 50 + "\n\n")

for dir_name in os.listdir():
    dir_path = os.path.join(os.getcwd(), dir_name)
    if os.path.isdir(dir_path) and os.path.isdir(os.path.join(dir_path, ".git")):
        with open(output_file, "a") as f:
            f.write(f"Repository: {dir_name}\n")
            f.write("-" * 50 + "\n")
        
        result = subprocess.run(["git", "status", "--short"], cwd=dir_path, capture_output=True, text=True)
        status_output = result.stdout.strip()
        
        if status_output:
            with open(output_file, "a") as f:
                f.write("Untracked/Modified/Uncommitted Files:\n")
                f.write(status_output + "\n\n")
        else:
            with open(output_file, "a") as f:
                f.write("No untracked or modified files.\n\n")
        
        result = subprocess.run(["git", "log", "--branches", "--not", "--remotes", "--simplify-by-decoration", "--oneline"], cwd=dir_path, capture_output=True, text=True)
        if result.stdout.strip():
            with open(output_file, "a") as f:
                f.write("Unpushed Commits:\n")
                f.write(result.stdout + "\n\n")
        else:
            with open(output_file, "a") as f:
                f.write("All commits are pushed.\n\n")

print(f"Report saved to {output_file}")
