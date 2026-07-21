import os
import re

mapping = {
    'account_balance_wallet_outlined': 'wallet',
    'add': 'plus',
    'add_a_photo_outlined': 'camera_plus',
    'apple': 'brand_apple',
    'arrow_back_ios_new_rounded': 'chevron_left',
    'arrow_forward_ios_rounded': 'chevron_right',
    'attach_file_rounded': 'paperclip',
    'camera_alt_outlined': 'camera',
    'card_giftcard_rounded': 'gift',
    'check': 'check',
    'check_circle': 'circle_check_filled',
    'check_circle_outline': 'circle_check',
    'chevron_right': 'chevron_right',
    'close': 'x',
    'cloud_upload_outlined': 'cloud_upload',
    'credit_card': 'credit_card',
    'done_all': 'checks',
    'email_outlined': 'mail',
    'facebook': 'brand_facebook',
    'favorite': 'heart',
    'g_mobiledata_rounded': 'brand_google',
    'history': 'history',
    'home_filled': 'home',
    'info_outline': 'info_circle',
    'inventory_2': 'box',
    'keyboard_arrow_down': 'chevron_down',
    'keyboard_arrow_down_rounded': 'chevron_down',
    'local_shipping_outlined': 'truck',
    'location_on': 'map_pin',
    'location_on_rounded': 'map_pin',
    'lock_outline': 'lock',
    'map': 'map',
    'mobile_screen_share_rounded': 'device_mobile',
    'more_vert': 'dots_vertical',
    'motorcycle': 'motorbike',
    'my_location': 'current_location',
    'navigation': 'navigation',
    'navigation_outlined': 'navigation',
    'notifications_none_outlined': 'bell',
    'payments_outlined': 'cash',
    'person': 'user',
    'person_outline': 'user',
    'person_outline_rounded': 'user',
    'person_rounded': 'user',
    'phone': 'phone',
    'phone_android_outlined': 'device_mobile',
    'phone_outlined': 'phone',
    'pin_outlined': 'pin',
    'receipt_long': 'receipt',
    'schedule': 'clock',
    'search': 'search',
    'send_rounded': 'send',
    'star_border_rounded': 'star',
    'stars': 'star_filled',
    'store_mall_directory_rounded': 'building_store',
    'tune_rounded': 'adjustments',
    'turn_right_rounded': 'corner_down_right',
    'verified_outlined': 'shield_check',
    'view_carousel_rounded': 'carousel_horizontal',
    'visibility_off_outlined': 'eye_off',
    'visibility_outlined': 'eye',
    'wifi_off_rounded': 'wifi_off'
}

folders = ['customer_app/lib', 'rider_app/lib']

for folder in folders:
    for root, dirs, files in os.walk(folder):
        for f in files:
            if f.endswith('.dart'):
                path = os.path.join(root, f)
                with open(path, 'r') as file:
                    content = file.read()
                
                # add import if it doesn't exist but has Icons.
                if 'Icons.' in content and 'flutter_tabler_icons' not in content:
                    # place import at the top
                    content = "import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';\n" + content
                
                # replace all Icons.xxx with TablerIcons.xxx
                def replacer(match):
                    icon_name = match.group(1)
                    if icon_name in mapping:
                        return f"TablerIcons.{mapping[icon_name]}"
                    else:
                        print(f"Missing mapping for {icon_name}")
                        return f"TablerIcons.{icon_name}"
                
                new_content = re.sub(r'Icons\.([a-zA-Z0-9_]+)', replacer, content)
                
                if new_content != content:
                    with open(path, 'w') as file:
                        file.write(new_content)
                    print(f"Updated {f}")
