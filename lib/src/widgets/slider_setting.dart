import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../settings_widget_base.dart';

/// A slider setting
/// 
/// This widget only uses the data type double, not int
class PlatformSliderSetting extends PlatformSettingsWidgetBase<double> {
  final Widget? trailing;
  final double minValue;
  final double maxValue;
  final int? divisions;
  
  PlatformSliderSetting({
    Key? key,
    required settingsKey,
    required title,
    this.minValue = 0,
    this.maxValue = 1,
    this.divisions,
    double? defaultValue,
    this.trailing,
    SettingChangedCallback<double>? onChanged,
  }
  ) : super(
    key: key,
    settingsKey: settingsKey,
    title: title,
    defaultValue: defaultValue,
    onChanged: onChanged,
  );

  @override
  State<StatefulWidget> createState() => _PlatformSwitchSettingState();
}

class _PlatformSwitchSettingState extends PlatformSettingsWidgetBaseState<double, PlatformSliderSetting> {
  
  double? sliderValue;
  
  @override
  init() {
    super.init();
    if (value != null) {
      sliderValue = value!;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    
    if (sliderValue == null) {
      sliderValue = value ?? widget.defaultValue ?? 0.0;
    }
    
    // TODO migrate to platform list tile when https://github.com/stryder-dev/flutter_platform_widgets/issues/296 is done
    
    return ListTile(
      leading: widget.leading,
      trailing: widget.trailing,
      title: Text(widget.title),
      subtitle: PlatformSlider(
        value: sliderValue!,
        min: widget.minValue,
        max: widget.maxValue,
        divisions: widget.divisions,
        onChangeEnd: (v) {
          onChanged(sliderValue);
        },
        onChanged: (val) => setState(() => (sliderValue = val)),
        activeColor: Theme.of(context).accentColor,
      )
    );
  }
  
}
