import 'package:flutter/material.dart';

import '../settings_widget_base.dart';

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
      onChanged,
      Widget? leading,
      this.trailing
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
  State<StatefulWidget> createState() => _PlatformCustomSettingState<T>();
  
}


class _PlatformCustomSettingState<T> extends PlatformSettingsWidgetBaseState<T, PlatformCustomSetting<T>> {
  @override
  Widget build(BuildContext context) {
    // TODO migrate to platform list tile when https://github.com/stryder-dev/flutter_platform_widgets/issues/296 is done
    
    return ListTile(
      leading: widget.leading,
      trailing: widget.trailing,
      title: Text(widget.title),
      subtitle: widget.subtitle != null ? Text(widget.subtitle!) : null,
      onTap: widget.onPressed,
    );
  }
  
}
