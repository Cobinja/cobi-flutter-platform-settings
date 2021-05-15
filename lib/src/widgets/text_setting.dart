import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../settings_widget_base.dart';

class PlatformTextSetting extends PlatformSettingsWidgetBase<String> {
  
  final String? dialogHintText;
  final TextInputType? keyboardType;
  final bool? isPasswordField;
  final String okText;
  final String cancelText;
  final List<TextInputFormatter>? inputFormatters;
  
  PlatformTextSetting({
    Key? key,
    required settingsKey,
    required title,
    defaultValue,
    subtitle,
    Widget? leading,
    this.dialogHintText,
    this.keyboardType,
    bool enabled = true,
    this.isPasswordField,
    this.inputFormatters,
    this.okText = 'OK',
    this.cancelText = 'Cancel'
  }) : super(
    key: key,
    settingsKey: settingsKey,
    title: title,
    defaultValue: defaultValue,
    subtitle: subtitle,
    enabled: enabled,
    leading: leading
  )
  {
    if (subtitle == null) {
      subtitle = defaultValue;
    }
  }

  @override
  State<StatefulWidget> createState() => _PlatformTextSettingState();
}

class _PlatformTextSettingState extends PlatformSettingsWidgetBaseState<String, PlatformTextSetting> {
  
  String? usedSubtitle;
   
  @override
  init() {
    super.init();
    if (value != null) {
      usedSubtitle = value;
    }
    else {
      usedSubtitle = widget.subtitle ?? '';
    }
  }
  
  @override
  void onChanged(covariant String newValue) {
    if (newValue is String?) {
      setState(() {
        this.value = newValue;
        if (value != null && value != '') {
          usedSubtitle = value;
        }
        else if (widget.subtitle != null) {
          usedSubtitle = widget.subtitle;
        }
        else {
          usedSubtitle = '';
        }
        persist();
      });
      return;
    }
    throw TypeError();
  }
  
  _onTap() async {
    final String? changedValue = await showPlatformDialog<String>(
      context: context,
      builder: (_) {
        var controller = TextEditingController(text: value);
        return PlatformAlertDialog(
          title: Text(
            widget.title,
            style: platformThemeData(
              context,
              material: (data) => data.textTheme.caption,
              cupertino: (data) => data.textTheme.navTitleTextStyle,
            ),
          ),
          content: PlatformTextField(
            controller: controller,
            autofocus: true,
            inputFormatters: widget.inputFormatters,
            keyboardType: widget.keyboardType,
          ),
          actions: [
            PlatformDialogAction(
              onPressed: () => Navigator.pop(context),
              child: PlatformText(widget.cancelText),
            ),
            PlatformDialogAction(
              onPressed: () => Navigator.pop(context, controller.text),
              child: PlatformText(widget.okText),
            )
          ],
        );
      },
    );
    if (changedValue != null && changedValue != value) {
      onChanged(changedValue);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    // TODO migrate to platform list tile when https://github.com/stryder-dev/flutter_platform_widgets/issues/296 is done
    
    return ListTile(
      title: Text(widget.title),
      subtitle: usedSubtitle != null ? Text(usedSubtitle!) : Text(''),
      leading: widget.leading,
      onTap: _onTap,
      enabled: widget.enabled,
    );
  }

}
