import 'dart:convert';
import 'dart:math';

import 'package:cobi_flutter_platform_settings/cobi_flutter_platform_settings.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'types.g.dart';

@JsonSerializable()
class TestType {
  int a;
  String b;
  
  TestType(this.a, this.b);
  
  factory TestType.fromJson(Map<String, dynamic> json) => _$TestTypeFromJson(json);
  
  Map<String, dynamic> toJson() => _$TestTypeToJson(this);
  
  @override
  String toString() {
    return toJson().toString();
  }
}

class TestTypeSetting extends PlatformSettingsWidgetBase<TestType> {
  TestTypeSetting({
    Key? key,
    required settingsKey,
    required title,
    TestType? defaultValue,
    
   }) : super(
    key: key,
    title: title,
    settingsKey: settingsKey,
    defaultValue: defaultValue
  );

  @override
  State<StatefulWidget> createState() => TestTypeSettingState();
}

class TestTypeSettingState extends PlatformSettingsWidgetBaseState<TestType, TestTypeSetting> {
  
  @override
  String? serialize() {
    return jsonEncode(value?.toJson());
  }
  
  @override
  TestType? deserialize(String? data) {
    if (data == null) {
      return null;
    }
    return TestType.fromJson(jsonDecode(data));
  }
  
  void _onTap() {
    int newValue = Random().nextInt(1000);
    setState(() {
      if (value == null) {
        value = TestType(newValue, newValue.toString());
      }
      else {
        value!.a = newValue;
        value!.b = newValue.toString();
      }
      persist();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: widget.leading,
      title: Text(widget.title),
      subtitle: Text(value?.toString() ?? "no value yet"),
      onTap: _onTap,
    );
  }
  
}
