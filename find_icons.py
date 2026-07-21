import os
import re

folders = ['customer_app/lib', 'rider_app/lib']
icons = set()

for folder in folders:
    for root, dirs, files in os.walk(folder):
        for f in files:
            if f.endswith('.dart'):
                path = os.path.join(root, f)
                with open(path, 'r') as file:
                    content = file.read()
                matches = re.findall(r'Icons\.([a-zA-Z0-9_]+)', content)
                for m in matches:
                    icons.add(m)

print("UNIQUE ICONS:", sorted(list(icons)))
