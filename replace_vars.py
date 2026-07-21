import os
import re

def process_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # We look for: Text( (price|amount|balance|cost|value|rating|distance|time|fee)[^,]*, style: TextStyle(fontFamily: 'Inter'
    # and replace with IBM Plex Mono
    pattern = r"(Text\(\s*(price|amount|balance|cost|value|rating|distance|time|fee|total|subtotal)[^,]*,\s*(?:overflow:[^,]*,)?\s*style:\s*TextStyle\(\s*)fontFamily:\s*'Inter'"
    
    new_content = re.sub(pattern, r"\1fontFamily: 'IBM Plex Mono'", content, flags=re.IGNORECASE)
    
    if new_content != content:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(new_content)

for root, _, files in os.walk('.'):
    for file in files:
        if file.endswith('.dart'):
            process_file(os.path.join(root, file))

print("Var replacement complete.")
