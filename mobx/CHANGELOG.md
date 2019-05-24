# Changelog

## 0.2.0

- A breaking change has been introduced to the use of the `Store` type. Previously it was meant to be used as an _interface_, which has now changed to a **mixin**. Instead of doing:

```dart
abstract class UserBase implements Store {}
```

You now do:

```dart
abstract class UserBase with Store {}
```

This allows us to add more convenience methods to the `Store` mixin without causing any breaking change in the future. With the current use of the interface, this was not possible and was limiting the purpose. `Store` was just a marker interface without any core functionality. With a **mixin**, it opens up some flexibility in adding more functionality later.

- All the docs and example code have been updated to the use of the `Store` mixin.
