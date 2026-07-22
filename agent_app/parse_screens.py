import re

with open('screens.html', 'r') as f:
    content = f.read()

agent_section = re.search(r'<section class="app-section"[^>]*id="sec-agent".*?</section>\s*<section class="app-section"', content, re.DOTALL)
if not agent_section:
    print("Could not find sec-agent")
else:
    modules = re.findall(r'<div class="module-head">.*?<h3>(.*?)</h3>.*?<div class="screen-grid wide">(.*?)</div>\s*</div>', agent_section.group(0), re.DOTALL)
    for module_title, module_html in modules:
        print(f"\n--- MODULE: {module_title} ---")
        scards = re.findall(r'<article class="scard".*?>\s*<div class="scard-head">.*?<h4>(.*?)</h4>.*?<p class="scard-purpose">(.*?)</p>.*?(<div class="scard-chips">.*?</div>)', module_html, re.DOTALL)
        for title, purpose, chips_html in scards:
            chips = re.findall(r'<span class="chip">(.*?)</span>', chips_html)
            print(f"- {title}: {purpose}")
            print(f"  Chips: {', '.join(chips)}")
