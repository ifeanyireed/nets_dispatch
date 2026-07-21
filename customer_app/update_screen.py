import re

with open('lib/screens/create_delivery_screen.dart', 'r') as f:
    content = f.read()

# Add FocusNodes
content = content.replace(
    '  final _dropoffController = TextEditingController();',
    '  final _dropoffController = TextEditingController();\n  final _pickupFocus = FocusNode();\n  final _dropoffFocus = FocusNode();'
)

content = content.replace(
    '    _dropoffController.dispose();',
    '    _dropoffController.dispose();\n    _pickupFocus.dispose();\n    _dropoffFocus.dispose();'
)

# Update _buildTextField signature to accept focusNode
content = content.replace(
    'Widget _buildTextField(String label, IconData? icon, Color? iconColor, {int maxLines = 1, TextEditingController? controller, Widget? suffixIcon}) {',
    'Widget _buildTextField(String label, IconData? icon, Color? iconColor, {int maxLines = 1, TextEditingController? controller, Widget? suffixIcon, FocusNode? focusNode}) {'
)

content = content.replace(
    '      controller: controller,',
    '      controller: controller,\n      focusNode: focusNode,'
)

# Add _buildAddressAutocomplete function
autocomplete_func = """

  Widget _buildAddressAutocomplete(String label, IconData icon, Color iconColor, TextEditingController controller, FocusNode focusNode, {Widget? suffixIcon}) {
    return RawAutocomplete<String>(
      textEditingController: controller,
      focusNode: focusNode,
      optionsBuilder: (TextEditingValue textEditingValue) async {
        if (textEditingValue.text.length < 3) {
          return const Iterable<String>.empty();
        }
        return await MapboxService.autocompletePlaces(textEditingValue.text);
      },
      onSelected: (String selection) {
        // selection is automatically put into the controller
      },
      fieldViewBuilder: (context, textController, focus, onFieldSubmitted) {
        return _buildTextField(label, icon, iconColor, controller: textController, focusNode: focus, suffixIcon: suffixIcon);
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width - 48,
              margin: const EdgeInsets.only(top: 8),
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                color: AppTheme.cardBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white12),
                boxShadow: [
                  BoxShadow(color: Colors.black54, blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options.elementAt(index);
                  return ListTile(
                    leading: const Icon(TablerIcons.map_pin, color: AppTheme.textSecondary, size: 20),
                    title: Text(option, style: TextStyle(fontFamily: 'Inter', color: Colors.white, fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
                    onTap: () => onSelected(option),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
"""

content = content.replace(
    '  Widget _buildTextField',
    autocomplete_func + '\n  Widget _buildTextField'
)

# Replace the specific calls in the ListView
content = content.replace(
    """_buildTextField('Pickup address', TablerIcons.map_pin, AppTheme.primaryRed, controller: _pickupController, 
                      suffixIcon: _isGettingLocation ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : IconButton(
                        icon: const Icon(TablerIcons.current_location, color: Colors.white54),
                        onPressed: _getCurrentLocation,
                      )
                    )""",
    """_buildAddressAutocomplete('Pickup address', TablerIcons.map_pin, AppTheme.primaryRed, _pickupController, _pickupFocus,
                      suffixIcon: _isGettingLocation ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : IconButton(
                        icon: const Icon(TablerIcons.current_location, color: Colors.white54),
                        onPressed: _getCurrentLocation,
                      )
                    )"""
)

content = content.replace(
    "_buildTextField('Drop-off address', TablerIcons.map_pin, Colors.blue, controller: _dropoffController)",
    "_buildAddressAutocomplete('Drop-off address', TablerIcons.map_pin, Colors.blue, _dropoffController, _dropoffFocus)"
)

with open('lib/screens/create_delivery_screen.dart', 'w') as f:
    f.write(content)

print("Done")
