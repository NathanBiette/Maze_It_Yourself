---------------------
| Maze it yourself! |
---------------------

link towards the Godot doc : http://docs.godotengine.org/en/stable/learning/workflow/export/exporting_for_android.html

=> To play the game on Android with one-click-deploy of Godot engine <=

#Required:
-Godot engine v2.1.3 (https://godotengine.org/download)
-Android SDK (http://developer.android.com/sdk/index.html)
-OpenJDK or Oracle JDK version 6 or superior
-a debug keystore file 
-Android Debug Bridge

#Step-by-step setup:
-Install Android SDK
-Install OpenJDK or Oracle JDK
-Launch Godot engine
-Enter Editor Settings (Settings > Editor Settings)
-In "Android" setup adb (android debug tool), jarsigner, debug keystore :
	->adb inside the sdk folder .../Android/sdk/platform-tools/adb
	->jarsigner inside the jdk folder .../jdk_version_number/bin/jarsigner
	->keystore .../.android/debug.keystore
-Connect phone to PC with USB wire and active android debug mode on phone
-Check that the android export is setup in Godot in Export > Android (there should be a warning if anything is missing)
-then check that the android icon can be seen on top of screen
-click on the android icon
-play the game
