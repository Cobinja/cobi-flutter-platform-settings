import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../common.dart';
import '../settings_widget_base.dart';

/// A radiobutton setting
/// 
/// This shows mutiple radio buttons of which one can be selected
class PlatformRadioSetting<T> extends PlatformSettingsWidgetBase<T> {
  final Widget? trailing;
  
  final List<PlatformListItem<T>> items;
  
  PlatformRadioSetting({
    Key? key,
    required settingsKey,
    required title,
    required this.items,
    T? defaultValue,
    String? subtitle,
    Widget? leading,
    this.trailing,
    bool enabled = true,
    SettingChangedCallback<T>? onChanged,
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
  State<StatefulWidget> createState() => _PlatformRadioSettingState<T>();
}

class _PlatformRadioSettingState<T> extends PlatformSettingsWidgetBaseState<T, PlatformRadioSetting<T>> {
  
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.title),
      leading: widget.leading,
      trailing: widget.trailing,
      subtitle: Column(
        children: List.generate(widget.items.length, (index) =>
          RadioListTile<T>(
            contentPadding: EdgeInsets.zero,
            dense: true,
            value: widget.items[index].value,
            groupValue: value,
            title: Text(widget.items[index].caption),
            onChanged: (val) => onChanged(val)
          )
        ),
      ),
    );
  }
}

/// Similar to [PlatformRadioSetting] but instead of showing the radio buttons directly,
/// this opens a dialog and stores the selected value only when the dialog is confirmed
class PlatformRadioModalSetting<T> extends PlatformSettingsWidgetBase<T> {
  final Widget? trailing;
  
  final List<PlatformListItem<T>> items;
  
  PlatformRadioModalSetting({Key? key,
    required settingsKey,
    required title,
    required this.items,
    T? defaultValue,
    String? subtitle,
    Widget? leading,
    this.trailing,
    bool enabled = true,
    SettingChangedCallback<T>? onChanged,
  }) : super(
    key: key,
    settingsKey: settingsKey,
    title: title,
    defaultValue: defaultValue,
    subtitle: subtitle,
    leading: leading,
    enabled: enabled,
    onChanged: onChanged,
  );

  @override
  State<StatefulWidget> createState() => _PlatformRadioModalSettingState<T>();
}

class _PlatformRadioModalSettingState<T> extends PlatformSettingsWidgetBaseState<T, PlatformRadioModalSetting<T>> {
  
  String? usedSubtitle;
  
  void _onTap() async {
    T? tmpValue = value;
    bool? ok = await showPlatformDialog<bool>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setNewState) => PlatformAlertDialog(
          title: Text(widget.title),
          content: Container(
            width: double.maxFinite,
            child: Scrollbar(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.items.length,
                itemBuilder: (BuildContext context, int index) {
                  return RadioListTile<T>(
                    dense: true,
                    value: widget.items[index].value,
                    groupValue: tmpValue,
                    title: Text(widget.items[index].caption),
                    onChanged: (val) => setNewState(() {
                      tmpValue = val;
                    }),
                  );
                },
              ),
            ) 
          ),
          actions: <Widget>[
            PlatformDialogAction(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            PlatformDialogAction(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ]
        ),
      ),
    );
    if (ok != null && ok && tmpValue != value) {
      onChanged(tmpValue);
    }
  }
  
  void setSubtitle() {
    if (value != null && value != '') {
      usedSubtitle = value.toString();
    }
    else if (widget.subtitle != null) {
      usedSubtitle = widget.subtitle;
    }
    else {
      usedSubtitle = '';
    }
  }
  
  @override
  void onChanged(T? newValue) {
    if (newValue == value) {
      return;
    }
    setState(() {
      value = newValue;
      setSubtitle();
      persist();
    });
    return;
  }
  
  @override
  Widget build(BuildContext context) {
    setSubtitle();
    return ListTile(
      title: Text(widget.title),
      subtitle: usedSubtitle != null ? Text(usedSubtitle!) : Text(''),
      leading: widget.leading,
      onTap: _onTap,
      enabled: widget.enabled,
    );
  }
  
}
