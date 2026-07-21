import os
import re

folder = 'customer_app/lib/screens'

for root, dirs, files in os.walk(folder):
    for f in files:
        if f.endswith('.dart'):
            path = os.path.join(root, f)
            with open(path, 'r') as file:
                content = file.read()
            
            # Pattern: find BoxDecoration that contains gradient or color for buttons, 
            # and change its borderRadius to BorderRadius.circular(100)
            
            # Since buttons in this app often have gradient: const LinearGradient(colors: [AppTheme.redGradientStart...])
            # or color: ... followed by borderRadius: BorderRadius.circular(16) or (12)
            # A safer way is to match the BoxDecoration blocks for buttons specifically.
            # Buttons are often wrapped in GestureDetector(onTap: ...) or InkWell, and they contain 'double.infinity' or explicit heights like 56.
            
            # Let's replace BorderRadius.circular(16) with BorderRadius.circular(100)
            # ONLY inside BoxDecorations that have the red gradient.
            
            def replacer(match):
                block = match.group(0)
                # replace BorderRadius.circular(...) with BorderRadius.circular(100) inside this block
                new_block = re.sub(r'BorderRadius\.circular\([0-9]+\)', 'BorderRadius.circular(100)', block)
                return new_block

            # Regex to match BoxDecoration(...) that contains AppTheme.redGradientStart
            # We match from BoxDecoration( to the matching closing bracket or a reasonable length.
            # A simpler way is to just find all occurrences of the red gradient button styling and replace the border radius.
            new_content = re.sub(r'BoxDecoration\([\s\S]*?AppTheme\.redGradientStart[\s\S]*?\)', replacer, content)

            if new_content != content:
                with open(path, 'w') as file:
                    file.write(new_content)
                print(f"Updated {f}")
