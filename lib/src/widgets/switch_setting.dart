import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../settings_widget_base.dart';

class PlatformSwitchSetting extends PlatformSettingsWidgetBase<bool> {
  PlatformSwitchSetting(
    {Key? key, required settingsKey, required title, bool? defaultValue, String? subtitle}
  ) : super(key: key, settingsKey: settingsKey, title: title, defaultValue: defaultValue, subtitle: subtitle);

  @override
  State<StatefulWidget> createState() => _PlatformSwitchSettingState();
}

class _PlatformSwitchSettingState extends PlatformSettingsWidgetBaseState<bool, PlatformSwitchSetting> {
  
  @override
  Widget build(BuildContext context) {
    // TODO migrate to platform list tile when https://github.com/stryder-dev/flutter_platform_widgets/issues/296 is done
    
    return SwitchListTile.adaptive(
      value: value != null ? value! : false,
      title: Text(widget.title),
      // prevent an empty subtitle causing a slight vertical offset
      subtitle: widget.subtitle != null && widget.subtitle!.trim() != '' ? Text(widget.subtitle!) : null,
      onChanged: onChanged,
    );
  }
  
}
