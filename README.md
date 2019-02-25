---------------------
| Maze it yourself! |
---------------------

link towards the Godot doc : http://docs.godotengine.org/en/stable/learning/workflow/export/exporting_for_android.html

=> To play the game on Android with one-click-deploy of Godot engine <=

# Required:
-Godot engine v2.1.3 (https://godotengine.org/download)<br/>
-Android SDK (http://developer.android.com/sdk/index.html)<br/>
-OpenJDK or Oracle JDK version 6 or superior<br/>
-a debug keystore file <br/>
-Android Debug Bridge<br/>

# Step-by-step setup:
-Install Android SDK<br/>
-Install OpenJDK or Oracle JDK<br/>
-Launch Godot engine<br/>
-Enter Editor Settings (Settings > Editor Settings)<br/>
-In "Android" setup adb (android debug tool), jarsigner, debug keystore :<br/>
	->adb inside the sdk folder .../Android/sdk/platform-tools/adb<br/>
	->jarsigner inside the jdk folder .../jdk_version_number/bin/jarsigner<br/>
	->keystore .../.android/debug.keystore<br/>
-Connect phone to PC with USB wire and active android debug mode on phone<br/>
-Check that the android export is setup in Godot in Export > Android (there should be a warning if anything is missing)<br/>
-then check that the android icon can be seen on top of screen<br/>
-click on the android icon<br/>
-play the game<br/>
