# Selector

This is the mobile application used to control your Selector.

You can find information on the device here: _@todo_

# Generate secrets

```bash
flutter pub run environment_config:generate --DICOGS_TOKEN=YOUR_DICOGS_TOKEN_HERE
```

# Generate the localizations

```bash
flutter pub run build_runner build | flutter pub get
```

# Generate launcher icon

```bash
flutter pub run flutter_launcher_icons:main
```

# Build apk

```bash
flutter build apk --split-per-abi
```

# Build bundle

```bash
flutter build appbundle
```
