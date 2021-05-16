import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../settings_widget_base.dart';

/// A textfield setting
/// 
/// When tapped, this widget shows a dialog with a textbox.
class PlatformTextSetting<T> extends PlatformSettingsWidgetBase<T> {
  
  /// The hint text for the dialog
  final String? dialogHintText;
  /// The keyboard type to be used in the dialog
  final TextInputType? keyboardType;
  /// Whether or not to obscure the text
  final bool? obscureText;
  /// the character used to obscure the text
  final String? obscuringCharacter;
  /// The text for the 'confirm' action in the dialog
  final String okText;
  /// The text for the 'cancel' action in the dialog
  final String cancelText;
  /// A list of TextInputFormatter that can be used to restrict or allow certain characters
  final List<TextInputFormatter>? inputFormatters;
  /// This callback is triggered for validation.
  /// Useful e.g. to make sure the user only entered numbers in a certain range
  final FormFieldValidator<T>? validator;
  
  /// Inherited from PlatformTextFormField
  final bool? autocorrect;
  /// Inherited from PlatformTextFormField
  final SmartDashesType? smartDashesType;
  /// Inherited from PlatformTextFormField
  final SmartQuotesType? smartQuotesType;
  /// Inherited from PlatformTextFormField
  final bool? enableSuggestions;
  /// Inherited from PlatformTextFormField
  final int? maxLines;
  /// Inherited from PlatformTextFormField
  final int? minLines;
  /// Inherited from PlatformTextFormField
  final bool? expands;
  /// Inherited from PlatformTextFormField
  final int? maxLength;
  /// Inherited from PlatformTextFormField
  final double cursorWidth = 2.0;
  /// Inherited from PlatformTextFormField
  final double? cursorHeight;
  /// Inherited from PlatformTextFormField
  final Color? cursorColor;
  /// Inherited from PlatformTextFormField
  final Brightness? keyboardAppearance;
  /// Inherited from PlatformTextFormField
  final EdgeInsets? scrollPadding;
  /// Inherited from PlatformTextFormField
  final bool? enableInteractiveSelection;
  /// Inherited from PlatformTextFormField
  final TextSelectionControls? selectionControls;
  
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
    this.obscureText,
    this.obscuringCharacter,
    this.inputFormatters,
    this.validator,
    this.okText = 'OK',
    this.cancelText = 'Cancel',
    this.autocorrect,
    this.smartDashesType,
    this.smartQuotesType,
    this.enableSuggestions,
    this.maxLines,
    this.minLines,
    this.expands,
    this.maxLength,
    this.cursorHeight,
    this.cursorColor,
    this.keyboardAppearance,
    this.scrollPadding,
    this.enableInteractiveSelection,
    this.selectionControls,
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
  )
  {
    if (T != String && T != int && T != double) {
      throw Exception('PlatformTextSetting only supports String, int and double as generic types');
    }
    
    if (subtitle == null) {
      subtitle = defaultValue;
    }
  }

  @override
  State<StatefulWidget> createState() => _PlatformTextSettingState<T>();
}

class _PlatformTextSettingState<T> extends PlatformSettingsWidgetBaseState<T, PlatformTextSetting<T>> {
  
  String? usedSubtitle;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  @override
  init() {
    super.init();
    if (value != null) {
      usedSubtitle = value.toString();
    }
    else {
      usedSubtitle = widget.subtitle ?? '';
    }
  }
  
  @override
  void onChanged(T? newValue) {
    setState(() {
      this.value = newValue;
      if (value != null && value != '') {
        usedSubtitle = value.toString();
      }
      else if (widget.subtitle != null) {
        usedSubtitle = widget.subtitle;
      }
      else {
        usedSubtitle = '';
      }
      persist();
    });
  }
  
  doChange(String? newValue) {
    if (newValue == null) {
      onChanged(newValue as T?);
    }
    
    switch(T) {
      case String:
        onChanged(newValue as T?);
        break;
      case int:
        onChanged(int.tryParse(newValue!) as T?);
        break;
      case double:
        onChanged(double.tryParse(newValue!) as T?);
        break;
      default:
        break;
    }
  }
  
  String? validate(String? val) {
    if (val == null) {
      return widget.validator != null ? widget.validator!(val as T?) : null;
    }
    
    switch(T) {
      case String:
        return widget.validator != null ? widget.validator!(val as T) : null;
      case int:
        int? v = int.tryParse(val);
        if (v == null)  {
          return 'Integer value required';
        }
        if (widget.validator != null) {
          return widget.validator!(v as T);
        }
        break;
      case double:
        double? v = double.tryParse(val);
        if (v == null)  {
          return 'Floating point value required';
        }
        if (widget.validator != null) {
          return widget.validator!(v as T);
        }
        break;
      default:
        return 'General error in text field validation';
    }
    return null;
  }
  
  List<TextInputFormatter>? _buildInputFormatters() {
    List<TextInputFormatter>? result;
    switch(T) {
      case int:
        result = [FilteringTextInputFormatter.digitsOnly];
        break;
      case double:
        result = [FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]'))];
        break;
    }
    
    if (widget.inputFormatters != null) {
      if (result == null) {
        result = [];
      }
      result.addAll(widget.inputFormatters!);
    }
    
    return result;
  }
  
  _onTap() async {
    await showPlatformDialog<String>(
      context: context,
      builder: (_) {
        var controller = TextEditingController(text: value?.toString());
        return PlatformAlertDialog(
          title: Text(
            widget.title,
            style: platformThemeData(
              context,
              material: (data) => data.textTheme.caption,
              cupertino: (data) => data.textTheme.navTitleTextStyle,
            ),
          ),
          content: Form(
            key: _formKey,
            child: PlatformTextFormField(
              hintText: widget.dialogHintText,
              controller: controller,
              autofocus: true,
              inputFormatters: _buildInputFormatters(),
              keyboardType: widget.keyboardType,
              validator: validate,
              onSaved: doChange,
              textInputAction: TextInputAction.done,
              obscureText: widget.obscureText,
              obscuringCharacter: widget.obscuringCharacter,
              autocorrect: widget.autocorrect,
              smartDashesType: widget.smartDashesType,
              smartQuotesType: widget.smartQuotesType,
              enableSuggestions: widget.enableSuggestions,
              maxLines: widget.maxLines,
              minLines: widget.minLines,
              expands: widget.expands,
              maxLength: widget.maxLength,
              cursorHeight: widget.cursorHeight,
              cursorColor: widget.cursorColor,
              keyboardAppearance: widget.keyboardAppearance,
              scrollPadding: widget.scrollPadding,
              enableInteractiveSelection: widget.enableInteractiveSelection,
              selectionControls: widget.selectionControls,
            ),
            autovalidateMode: AutovalidateMode.always,
          ),
          actions: [
            PlatformDialogAction(
              onPressed: () => Navigator.pop(context),
              child: PlatformText(widget.cancelText),
            ),
            PlatformDialogAction(
              onPressed: ()  {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  Navigator.pop(context);
                }
              },
              child: PlatformText(widget.okText),
            )
          ],
        );
      },
    );
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
