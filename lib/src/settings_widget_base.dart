import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef SettingChangedCallback<T> = void Function(T? from, T? to);

/// The base class for all platform settings widgets
/// [T] is the type of value stored via shared_preferences
abstract class PlatformSettingsWidgetBase<T> extends StatefulWidget {
  
  /// The default value that is used if no value is stored
  final T? defaultValue;
  
  /// The key used to store via shared_preferences
  final String? settingsKey;
  
  /// The settings tile's title
  final String title;
  /// The settings tile's subtitle
  final String? subtitle;
  
  /// Whether this setting is enabled or not
  final bool enabled;
  
  /// The leading widget for the settings tile
  final Widget? leading;
  
  /// A callback that is triggered when the value changes
  final SettingChangedCallback<T>? onChanged;
  
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

/// The base state class for [PlatformSettingsWidgetBase]
/// 
/// This takes care of persisting the value via shared_preferences
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
  
  /// Here the actual storing takes place
  /// 
  /// This method can be overridden by subclasses in cases
  /// where a subclass needs to store e.g. a data type that
  /// is not directly suported by shared_preferences.
  /// An overriding subclass should make sure
  /// that null values are removed from shared_preferences.
  void persist() {
    if (widget.settingsKey == null) {
      return;
    }
    
    String settingsKey = widget.settingsKey!;
    
    if (value == null) {
      prefs.remove(widget.settingsKey!);
      return;
    }
    
    switch (T) {
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
  
  /// This method is called by subclasses when the value changes.
  /// Here, the new value is only set and [PlatformSettingsWidgetBase.onChanged] is only called
  /// when the value actually changes
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
