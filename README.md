# Todo app

App, which can help organize your tasks

### What can this app do?
v1:
- You can use swipes to mark completed tasks or to delete tasks
- You can mark "deadline" of tasks
- All tasks are divided by importance

v2:

- Now, your tasks are saved when you exit the app

v3:

- Your tasks are saving online. If you don't have connection, your tasks will upload, when mobile phone will connect to the Internet
- If app will have some troubles with detecting connection, You will see a info with button.
- In this update I reworked architecture and made dependencies injection
- Also I added unit tests and integration tests
- All mistakes from the backend are handling
- Now, navigation realized with Navigator 2.0!

v4:

- Added 2 flavors: dev and prod.

Dev run: flutter run --flavor dev --target lib/main_dev.dart
Prod run: flutter run --flavor prod --target lib/main_prod.dart

- Added Firebase Crashlytics and Analytics
- Added landscape mode and supporting for big screens
- Added Github CI with distribution to Firebase App Distribution (link to join testing: https://appdistribution.firebase.dev/i/ece720b38173ca66)

### Screenshots

<image src = "screenshots/scr1.jpeg">
<image src = "screenshots/scr2.jpeg">
<image src = "screenshots/scr3.jpeg">

### Download link

You can download zip-file with .apk there: https://github.com/SokoMix/yandToDoApp/releases/tag/lease
