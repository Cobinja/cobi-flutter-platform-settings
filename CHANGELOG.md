## [3.0.0] - May 15th, 2023

* Upgrade usable flutter version to 3.10 and usable dart SDK version to < 4.0.0
* Improve custom type serialization and deserialization
* Migrate to PlatformListTile
* Replace accentColor with secondary on Android
* Replace caption with bodySmall on Android

## [2.0.1] - May 15th, 2021

* Export base classes so that apps/libraries can subclass their own widgets

## [2.0.0] - May 16th, 2021

* `PlatformTextSetting`: Change to a generic type that supports String, int and double as types (breaking change, thus major version increased)
* `PlatformCheckboxSetting`: Use a checkbox for MacOS but not iOS
* All widgets now have the `onChanged` property
* Added API documentation

## [1.0.0] - May 15th, 2021

* Initial release
