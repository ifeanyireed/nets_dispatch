import os

folder = 'customer_app/lib/screens'
for f in os.listdir(folder):
    if f == 'welcome_screen.dart': continue
    path = os.path.join(folder, f)
    with open(path, 'r') as file:
        content = file.read()
    
    # We only want to remove the extra closures if they are at the very end of the file
    bad_ending = """          ),
        ],
      ),
    );
  }
}"""
    good_ending = """    );
  }
}"""
    if content.endswith(bad_ending) or content.endswith(bad_ending + '\n'):
        content = content.replace(bad_ending, good_ending)
        with open(path, 'w') as file:
            file.write(content)
        print("Fixed", f)

