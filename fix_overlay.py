import os

folder = 'customer_app/lib/screens'
for f in os.listdir(folder):
    if f == 'welcome_screen.dart': continue
    path = os.path.join(folder, f)
    with open(path, 'r') as file:
        content = file.read()
    
    bad_overlay = """          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [Colors.black.withOpacity(0.3), Colors.black.withOpacity(0.7), Colors.black],
                  stops: const [0.0, 0.5, 0.9],
                ),
              ),
            ),
          ),"""
    
    good_overlay = """          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.92),
            ),
          ),"""
    
    if bad_overlay in content:
        content = content.replace(bad_overlay, good_overlay)
        with open(path, 'w') as file:
            file.write(content)
        print("Fixed", f)
    else:
        print("Did not find bad overlay in", f)
