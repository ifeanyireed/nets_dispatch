import os
import glob

search_text = "http://localhost:8080"
replace_text = "https://nets-logistics-api.onrender.com"

# Find all dart and js files
files = glob.glob('agent_app/src/**/*.js', recursive=True)

for filepath in files:
    if os.path.isfile(filepath):
        with open(filepath, 'r') as file:
            content = file.read()
        
        if search_text in content:
            content = content.replace(search_text, replace_text)
            with open(filepath, 'w') as file:
                file.write(content)
            print(f"Updated {filepath}")
