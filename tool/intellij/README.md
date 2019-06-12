# Live Templates for MobX

## Add Live Templates

### Android Studio

1. Copy file `MobX.xml` to:

   - Windows: `C:\Users\<userName>\.AndroidStudio<version>\config\templates\`
   - macOS: `/Users/<userName>/Library/Preferences/AndroidStudio<version>/templates/`

1. Restart **Android Studio**

### Intellij

A similar process can be followed for _Intellij Ultimate_. The paths can differ based on how you are installing it. If you use the _Jetbrains Toolbox_ app to manage the app versions, the default location would be in

> `/Users/<userName>/Library/Application Support/JetBrains/Toolbox/apps/IDEA-U`

## List of Live Templates

**`str`**:

```dart
part 'store.g.dart';

class Store = _Store with _$Store;

abstract class _Store with Store {

}
```

**`obs`**:

```dart
@observable
int value = 0;
```

**`act`**:

```dart
@action
void fooBar() {

}
```
