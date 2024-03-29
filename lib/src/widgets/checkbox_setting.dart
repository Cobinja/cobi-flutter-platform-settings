import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../settings_widget_base.dart';

/// A checkbox setting
/// 
/// On iOS this widget uses a switch instead of a checkbox
/// because there are no native checkboxes on iOS
class PlatformCheckboxSetting extends PlatformSettingsWidgetBase<bool> {
  PlatformCheckboxSetting({
    Key? key,
    required settingsKey,
    required title,
    bool? defaultValue,
    subtitle,
    bool enabled = true,
    Widget? leading,
    SettingChangedCallback<bool>? onChanged,
  }) : super(
    key: key,
    settingsKey: settingsKey,
    title: title,
    defaultValue: defaultValue,
    subtitle: subtitle,
    enabled: enabled,
    leading: leading,
    onChanged: onChanged,
  );

  @override
  State<StatefulWidget> createState() => _PlatformCheckboxSettingState();
}

class _PlatformCheckboxSettingState extends PlatformSettingsWidgetBaseState<bool, PlatformCheckboxSetting> {
  
  @override
  Widget build(BuildContext context) {
    if (platform(context) == PlatformTarget.iOS) {
      // No native checboxes on iOS, so just use a switch
      return SwitchListTile.adaptive(
        value: value != null ? value! : false,
        title: Text(widget.title),
        subtitle: widget.subtitle != null ? Text(widget.subtitle!) : null,
        onChanged: onChanged,
      );
    }
    if (isMaterial(context) || isCupertino(context))
    return CheckboxListTile(
      value: value != null ? value! : false,
      title: Text(widget.title),
      subtitle: widget.subtitle != null ? Text(widget.subtitle!) : null,
      onChanged: onChanged,
    );
    
    return throw new UnsupportedError(
        'This platform is not supported: $defaultTargetPlatform');
  }
  
}
