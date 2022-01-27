import 'package:cobi_flutter_platform_settings/src/settings_widget_base.dart';
import 'package:flutter/material.dart';

import 'settings_screen.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

/// A group of settings
/// 
/// This widget groups various [PlatformSettingsWidgetBase]s together
class PlatformSettingsGroup extends PlatformSettingsWidgetBase {
  
  /// All children go here
  final List<PlatformSettingsWidgetBase> children;
  
  PlatformSettingsGroup({
    Key? key,
    required String title,
    required this.children,
  }) : super(key: key, title: title);

  @override
  State<StatefulWidget> createState() => _PlatformSettingsGroupState();
  
}

class _PlatformSettingsGroupState extends PlatformSettingsWidgetBaseState<dynamic, PlatformSettingsGroup> {
  
  @override
  Widget build(BuildContext context) {
    
    PlatformSettingsScreen? screen = context.findAncestorWidgetOfExactType<PlatformSettingsScreen>();
    
    if (screen == null) {
      throw('PlatformSettingsGroup must be a child of PlatformSettingsScreen');
    }
    
    List<Widget> content = [];
    
    widget.children.forEach((item) {
      content.add(Container(
        padding: EdgeInsets.only(top: 8.0, bottom: 0.0),
        child: item,
      ) );
      if (item != widget.children.last) {
        content.add(Divider(
          height: 8.0,
          thickness: 1.0
        ));
      }
    });
    
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            textAlign: TextAlign.left,
            overflow: TextOverflow.fade,
            style: platformThemeData(
              context,
              material: (data) => data.textTheme.bodyText1!.copyWith(color: data.accentColor),
              cupertino: (data) => data.textTheme.navTitleTextStyle,
            ),
          ),
          ...content,
        ],
      )
    );
  }
  
}
