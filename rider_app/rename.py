import os
import re
import shutil

replacements = {
    "Rider App": "Rider App",
    "rider_app": "rider_app",
    "com.example.riderApp": "com.example.riderApp",
    "com.example.rider_app": "com.example.riderApp",
    "com.example": "com.example",
    "riderApp": "riderApp"
}

def process_file(filepath):
    # skip binary files or git
    if '.git' in filepath or '.png' in filepath or '.jpg' in filepath or '.ttf' in filepath:
        return
    
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
            
        new_content = content
        for k, v in replacements.items():
            new_content = new_content.replace(k, v)
            
        if new_content != content:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(new_content)
    except:
        pass

for root, _, files in os.walk('.'):
    for file in files:
        process_file(os.path.join(root, file))

# Fix the kotlin directory
old_path = "android/app/src/main/kotlin/com/biosora/rider_app"
new_path = "android/app/src/main/kotlin/com/example/rider_app"
if os.path.exists(old_path):
    os.makedirs(new_path, exist_ok=True)
    for f in os.listdir(old_path):
        shutil.move(os.path.join(old_path, f), os.path.join(new_path, f))
    shutil.rmtree("android/app/src/main/kotlin/com/biosora")

print("Rename complete")
