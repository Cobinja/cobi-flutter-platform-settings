import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PlatformSettingsWidgetBase<T> extends StatefulWidget {
  
  final T? defaultValue;
  
  final String? settingsKey;
  
  final String title;
  final String? subtitle;
  
  final bool enabled;
  
  final Widget? leading;
  
  final Function(T? from, T? to)? onChanged;
  
  PlatformSettingsWidgetBase({
    Key? key,
    this.settingsKey,
    required this.title,
    this.defaultValue,
    this.subtitle,
    this.enabled = true,
    this.onChanged,
    this.leading
  }) : super(key: key);
}

abstract class PlatformSettingsWidgetBaseState<T, W extends PlatformSettingsWidgetBase<T>> extends State<W> {
  
  @protected
  T? value;
  
  @protected
  late SharedPreferences prefs;
  
  PlatformSettingsWidgetBaseState() {
    
    SharedPreferences.getInstance()
    .then((value) {
      this.prefs = value;
      init();
    });
  }
  
  @protected
  void init() {
    if (widget.settingsKey == null) {
      return;
    }
    
    this.prefs = prefs;
    Object? currentValue = prefs.get(widget.settingsKey!);
    
    setState(() {
      if (currentValue != null && !(currentValue is T?)) {
        value = widget.defaultValue;
      }
      if (currentValue == null) {
        currentValue = widget.defaultValue;
      }
      value = currentValue as T?;
    });
  }
  
  void persist() {
    if (widget.settingsKey == null) {
      return;
    }
    
    String settingsKey = widget.settingsKey!;
    
    if (value == null) {
      prefs.remove(widget.settingsKey!);
      return;
    }
    
    Type type = value.runtimeType;
    switch (type) {
      case String:
        prefs.setString(settingsKey, value as String);
        break;
      case bool:
        prefs.setBool(settingsKey, value as bool);
        break;
      case int:
        prefs.setInt(settingsKey, value as int);
        break;
      case double:
        prefs.setDouble(settingsKey, value as double);
        break;
      case List:
        if (T is List<String>) {
          List<String> val = value as List<String>;
          prefs.setStringList(settingsKey, val);
        }
        break;
      default:
        break;
    }
  }
  
  @protected
  void onChanged(T? newValue) {
    setState(() {
      T? oldValue = value;
      this.value = newValue;
      if (widget.onChanged != null) {
        widget.onChanged!(oldValue, newValue);
      }
      persist();
    });
  }
  
}
