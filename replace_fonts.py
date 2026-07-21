import os
import re

def process_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    if 'GoogleFonts' not in content:
        return
        
    # Replace GoogleFonts.xxx( with TextStyle(fontFamily: 'Inter',
    content = re.sub(r'GoogleFonts\.[a-zA-Z0-9_]+\(', r"TextStyle(fontFamily: 'Inter', ", content)
    
    # Remove google_fonts import
    content = re.sub(r"import 'package:google_fonts/google_fonts\.dart';\n?", "", content)
    
    # Try to find Text widgets that likely contain figures and change them to IBM Plex Mono
    # We will look for Text('...123...' or Text('...₦...' or Text(price
    # This is a bit tricky with regex, so let's do some common patterns:
    
    # 1. Text('₦...'
    content = re.sub(r"(Text\(\s*['\"][^'\"]*?[₦\d][^'\"]*?['\"]\s*,[^>]*?style:\s*TextStyle\(\s*)fontFamily:\s*'Inter'", 
                     r"\1fontFamily: 'IBM Plex Mono'", content)
                     
    # 2. _buildStatCell(..., TablerIcons.cash) in rider app etc
    # We can just change all font families inside _buildStatCell to mono if it's a value
    
    # Let's save the file
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)

for root, _, files in os.walk('.'):
    for file in files:
        if file.endswith('.dart'):
            process_file(os.path.join(root, file))

print("Font replacement complete.")
