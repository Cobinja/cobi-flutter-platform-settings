# cobi_flutter_platform_settings
An application settings screen that persists values via the [shared_preferences](https://pub.dev/packages/shared_preferences) package and uses the [flutter_platform_widgets](https://pub.dev/packages/flutter_platform_widgets) for platform integration.
## Getting Started
You can use this anywhere in your app that already uses flutter_platform_widgets.
If flutter_platform_widgets is new to you, please read their documentation to get started.

*Note: This package currently uses some material widgets even on iOS, so make sure you use ``iosUsesMaterialWidgets:  true`` (see https://github.com/stryder-dev/flutter_platform_widgets/blob/master/README.md#settings). This will likely change when [this](https://github.com/stryder-dev/flutter_platform_widgets/issues/296) is done.*

All widgets come with a property 'settingsKey' which is used to store them in shared_preferences, so you can retrieve the value from anywhere using the same key.
The only exceptions from this are PlatformSettingsScreen, PlatformSettingsGroup and PlatformCustomSetting (which is intended to launch navigation routes or to just show some information).

## Widgets
### PlatformSettingsScreen
The uppermost settings container. Use this as a starting point.
```dart
PlatformSettingsScreen (
  title: 'App Settings',
  children: [],
)
```
### PlatformSettingsGroup
A container that groups various settings together
```dart
PlatformSettingsGroup (
  title: 'First Group',
  children: [],
)
```
### PlatformCustomSetting
A settings widget that takes an onPressed action, useful e.g. to launch navigation routes.
```dart
PlatformCustomSetting (
  title: 'My Custom Setting',
  subtitle: 'My subtitle',
  onPressed: () => debugPrint('hello world!'),
)
```
### PlatformTextSetting
A widget that shows a textfield
```dart
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
```
### PlatformSwitchSetting
A widget with a two-state switch
```dart
PlatformSwitchSetting(
  settingsKey: 'switch-setting',
  title: 'This is a switch setting',
  defaultValue: true,
)
```
### PlatformCheckboxSetting
A widget with a checkbox on Android
*Note: On iOS this uses a switch due to the lack of native checkboxes*
```dart
PlatformCheckboxSetting(
  settingsKey: 'checkbox-setting',
  title: 'This is a checkbox setting',
  defaultValue: false,
),
```
### PlatformRadioSetting
This shows a list of radio buttons
```dart
PlatformRadioSetting<int>(
  settingsKey:  'radio-setting',
  title:  'This is a radio setting',
  items: [
    PlatformListItem<int>(value: 1, caption: 'One'),
    PlatformListItem<int>(value: 2, caption: 'Two'),
    PlatformListItem<int>(value: 3, caption: 'Three'),
    PlatformListItem<int>(value: 4, caption: 'Four'),
    PlatformListItem<int>(value: 5, caption: 'Five'),
  ],
),
```
### PlatformRadioModalSetting
The radio buttons in this one are shown in a dialog
```dart
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
  ],
),
```
### PlatformSliderSetting
You guessed right, a widget with a slider
```dart
PlatformSliderSetting(
  settingsKey: 'slider-setting',
  title: 'This is a slider setting',
  minValue: 0.0,
  maxValue: 100.0,
  divisions: 100,
  defaultValue: 25.0,
),
```
#### You can find more example use cases in the included example app.
## Extensibility
You can define your own widgets by subclassing ``SettingsWidgetBase<T>`` and ``SettingsWidgetBaseState<T, YourSettingsWidgetClass>`` with ``T`` being the type stored via shared_preferences.

If you need a data type *not* supplied by shared_preferences, you can override ``SettingsWidgetBaseState::serialize()`` and ``SettingsWidgetBaseState::deserialize()`` and do the serialization yourself.
#### Note: Serialization and deserialization work different in 3.0 compared to version 2.0. See the included example.
