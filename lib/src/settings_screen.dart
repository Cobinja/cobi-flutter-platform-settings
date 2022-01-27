import 'package:cobi_flutter_platform_settings/src/settings_widget_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

/// The uppermost container for platform settings widgets
/// 
/// This can contain multiple [PlatformSettingsGroup]s
/// and other Widgets derived from [PlatformSettingsWidgetBase]
/// 
/// This class is supposed to be used within a PlatformApp from flutter_platform_widgets
class PlatformSettingsScreen extends PlatformSettingsWidgetBase {
  
  /// All children go here
  final List<PlatformSettingsWidgetBase> children;

  PlatformSettingsScreen({
    Key? key,
    required String title,
    required this.children,
  }) :
  super(key: key, title: title);

  @override
  State<StatefulWidget> createState() => _PlatformSettingsScreenState();
}

class _PlatformSettingsScreenState extends PlatformSettingsWidgetBaseState<dynamic, PlatformSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    PlatformTarget target = platform(context);
    if (target != PlatformTarget.android && target != PlatformTarget.android) {
      throw Exception('Platform unsupported, only Android and iOS');
    }
    
    List<Widget> content = [];
    
    widget.children.forEach((item) {
      content.add(Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: item,
        )
      );
      if (item != widget.children.last) {
        content.add(
          Divider(
            height: 8.0,
            thickness: 1.0
          )
        );
      }
    });
    
    return ListView.builder(
      shrinkWrap: true,
      itemCount: content.length,
      itemBuilder: (BuildContext context, int index) => content[index],
    );
  }
  
}
