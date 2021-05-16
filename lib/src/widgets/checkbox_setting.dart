import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../settings_widget_base.dart';

class PlatformCheckboxSetting extends PlatformSettingsWidgetBase<bool> {
  PlatformCheckboxSetting({
    Key? key,
    required settingsKey,
    required title,
    bool? defaultValue,
    subtitle,
    bool enabled = true,
    Widget? leading
  }) : super(
    key: key,
    settingsKey: settingsKey,
    title: title,
    defaultValue: defaultValue,
    subtitle: subtitle,
    enabled: enabled,
    leading: leading
  );

  @override
  State<StatefulWidget> createState() => _PlatformCheckboxSettingState();
}

class _PlatformCheckboxSettingState extends PlatformSettingsWidgetBaseState<bool, PlatformCheckboxSetting> {
  
  @override
  Widget build(BuildContext context) {
    // TODO migrate to platform list tile when https://github.com/stryder-dev/flutter_platform_widgets/issues/296 is done
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
