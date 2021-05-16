import 'package:cobi_flutter_platform_settings/cobi_flutter_platform_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    final materialTheme = ThemeData(
      cupertinoOverrideTheme: CupertinoThemeData(
        primaryColor: Color(0xff127EFB),
      ),
      primarySwatch: Colors.indigo,
      accentColor: Colors.blue,
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.all(16.0)),
          foregroundColor: MaterialStateProperty.all(Color(0xFF3DDC84)),
        ),
      ),
    );

    return Theme(
      data: materialTheme,
      child: PlatformProvider(
        settings: PlatformSettingsData(iosUsesMaterialWidgets: true),
        builder: (context) => PlatformApp(
          localizationsDelegates: <LocalizationsDelegate<dynamic>>[
            DefaultMaterialLocalizations.delegate,
            DefaultWidgetsLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate,
          ],
          title: 'Flutter Platform Widgets',
          home: MyHomePage(),
          material: (_, __) => MaterialAppData(
            theme: materialTheme,
          ),
          cupertino: (_, __) => CupertinoAppData(
            theme: CupertinoThemeData(
              primaryColor: Color(0xff127EFB),
            ),
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text('Platform Settings Example'),
      ),
      body: PlatformSettingsScreen(
        title: 'App Settings',
        children: [
          PlatformSettingsGroup(
            title: 'Switchable Settings',
            children: [
              PlatformSwitchSetting(
                settingsKey: 'switch-setting',
                title: 'This is a switch setting',
                defaultValue: true
              ),
              PlatformCheckboxSetting(
                settingsKey: 'checkbox-setting',
                title: 'This is a checkbox setting',
                defaultValue: false,
              ),
            ],
          ),
          PlatformSettingsGroup(
            title: 'Text Settings',
            children: [
              PlatformTextSetting<String>(
                settingsKey: 'text-setting',
                title: 'A text setting with default keyboard type',
              ),
              PlatformTextSetting<String>(
                settingsKey: 'text-setting-2',
                title: 'This a text setting with a specified subtitle',
                subtitle: 'This is a subtitle'
              ),
              PlatformTextSetting<int>(
                settingsKey: 'text-setting-3',
                title: 'A text setting for integers only',
                keyboardType: TextInputType.number,
                defaultValue: 42000,
                validator: (value) {
                  if (value == null || value < 1024 || value > 65536) {
                    return 'Integer number between 1024 and 65536 expected';
                  }
                },
              ),
              PlatformTextSetting<double>(
                settingsKey: 'text-setting-4',
                title: 'A text setting for doubles only',
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          PlatformRadioModalSetting<int>(
            settingsKey: 'radio-modal-setting',
            title: 'This is a modal radio setting',
            defaultValue: 5,
            items: [
              PlatformListItem<int>(value: 1, caption: 'One'),
              PlatformListItem<int>(value: 2, caption: 'Two'),
              PlatformListItem<int>(value: 3, caption: 'Three'),
              PlatformListItem<int>(value: 4, caption: 'Four'),
              PlatformListItem<int>(value: 5, caption: 'Five'),
              PlatformListItem<int>(value: 6, caption: 'Six'),
              PlatformListItem<int>(value: 7, caption: 'Seven'),
              PlatformListItem<int>(value: 8, caption: 'Eight'),
              PlatformListItem<int>(value: 9, caption: 'Nine'),
              PlatformListItem<int>(value: 10, caption: 'Ten'),
              PlatformListItem<int>(value: 11, caption: 'Eleven'),
              PlatformListItem<int>(value: 12, caption: 'Twelve'),
              PlatformListItem<int>(value: 13, caption: 'Thirteen'),
              PlatformListItem<int>(value: 14, caption: 'Fourteen'),
              PlatformListItem<int>(value: 15, caption: 'Fifteen'),
              PlatformListItem<int>(value: 16, caption: 'Sixteen'),
              PlatformListItem<int>(value: 17, caption: 'Seventeen'),
              PlatformListItem<int>(value: 18, caption: 'Eighteen'),
              PlatformListItem<int>(value: 19, caption: 'Nineteen'),
              PlatformListItem<int>(value: 20, caption: 'Twenty'),
              PlatformListItem<int>(value: 21, caption: 'Twentyone'),
              PlatformListItem<int>(value: 22, caption: 'Twentytwo'),
              PlatformListItem<int>(value: 23, caption: 'Twentythree'),
            ],
          ),
          PlatformRadioSetting<int>(
            settingsKey: 'radio-setting',
            title: 'This is a radio setting',
            items: [
              PlatformListItem<int>(value: 1, caption: 'One'),
              PlatformListItem<int>(value: 2, caption: 'Two'),
              PlatformListItem<int>(value: 3, caption: 'Three'),
              PlatformListItem<int>(value: 4, caption: 'Four'),
              PlatformListItem<int>(value: 5, caption: 'Five'),
            ]
          ),
          PlatformSliderSetting(
            settingsKey: 'slider-setting',
            title: 'This is a slider setting',
            minValue: 0.0,
            maxValue: 10.0,
            divisions: 10,
            defaultValue: 5.0,
          ),
          PlatformCustomSetting(
            title: 'This is a custom setting',
            onPressed: () => showPlatformDialog(
              context: context,
              builder: (_) => PlatformAlertDialog(
                title: Text('Warning'),
                content: Text('Self destruct in 5 seconds.'),
                actions: <Widget>[
                  PlatformDialogAction(
                    child: Text('Cancel'),
                    onPressed: () => Navigator.pop(context)
                  ),
                  PlatformDialogAction(
                    child: Text('OK'),
                    onPressed: () => Navigator.pop(context)
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
