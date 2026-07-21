import os

folder = 'customer_app/lib/screens'
for f in os.listdir(folder):
    if f == 'welcome_screen.dart': continue
    path = os.path.join(folder, f)
    with open(path, 'r') as file:
        content = file.read()
    
    # Check if already has Stack wrapper
    if 'assets/moodboard/biker09.jpeg' in content:
        continue

    # Make AppBar transparent
    content = content.replace("backgroundColor: AppTheme.screenBackground,", "backgroundColor: Colors.transparent,")
    
    # Inject extendBodyBehindAppBar
    if 'appBar: AppBar(' in content:
        content = content.replace("appBar: AppBar(", "extendBodyBehindAppBar: true,\n      appBar: AppBar(")
    else:
        content = content.replace("body:", "extendBodyBehindAppBar: true,\n      body:")

    # Wrap body:
    bg_wrapper = """body: Stack(
        children: [
          Positioned.fill(child: Image.asset('assets/moodboard/biker09.jpeg', fit: BoxFit.cover)),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [Colors.black.withOpacity(0.3), Colors.black.withOpacity(0.7), Colors.black],
                  stops: const [0.0, 0.5, 0.9],
                ),
              ),
            ),
          ),
          SafeArea(
            child: """

    if "body: SingleChildScrollView(" in content:
        content = content.replace("body: SingleChildScrollView(", bg_wrapper + "SingleChildScrollView(")
    elif "body: SafeArea(" in content:
        # Avoid double SafeArea
        bg_wrapper_no_safearea = bg_wrapper.replace("SafeArea(\n            child: ", "")
        content = content.replace("body: SafeArea(", bg_wrapper_no_safearea + "SafeArea(")
    elif "body: Column(" in content:
        content = content.replace("body: Column(", bg_wrapper + "Column(")
    elif "body: ListView(" in content:
        content = content.replace("body: ListView(", bg_wrapper + "ListView(")
    else:
        print("Could not find body for", f)
        continue
    
    # Now close the SafeArea / Stack. We need to add `), ],` right before the end of Scaffold.
    # We find the bottomNavigationBar if it exists, or the closing of Scaffold.
    if "bottomNavigationBar:" in content:
        content = content.replace("      bottomNavigationBar:", "          ),\n        ],\n      ),\n      bottomNavigationBar:")
    else:
        # replace the last `    );` inside build method
        # actually find `    );` before `  }`
        content = content.replace("    );\n  }", "          ),\n        ],\n      ),\n    );\n  }")
        
    with open(path, 'w') as file:
        file.write(content)
    print("Wrapped", f)
