import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../settings_widget_base.dart';

/// A Custom Setting for various purposes
/// This widget can be used for various stuff,
/// like calling another navigation route or
/// showing some information
class PlatformCustomSetting<T> extends PlatformSettingsWidgetBase<T> {
  final void Function()? onPressed;
  final Widget? trailing;
  
  PlatformCustomSetting({
      Key? key,
      settingsKey,
      required title,
      T? defaultValue,
      String? subtitle,
      enabled = true,
      this.onPressed,
      Widget? leading,
      this.trailing,
      SettingChangedCallback<T>? onChanged,
    }) : super(
      key: key,
      settingsKey: settingsKey,
      title: title,
      defaultValue: defaultValue,
      subtitle: subtitle,
      enabled: enabled,
      leading: leading,
      onChanged: onChanged
  );

  @override
  State<StatefulWidget> createState() => _PlatformCustomSettingState<T>();
  
}


class _PlatformCustomSettingState<T> extends PlatformSettingsWidgetBaseState<T, PlatformCustomSetting<T>> {
  @override
  Widget build(BuildContext context) {
    
    return PlatformListTile(
      leading: widget.leading,
      trailing: widget.trailing,
      title: Text(widget.title),
      subtitle: widget.subtitle != null ? Text(widget.subtitle!) : null,
      onTap: widget.onPressed,
    );
  }
  
}
