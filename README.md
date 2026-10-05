# Smart Campus Visitor Management (UIKit, programmatic UI)

## Option A — XcodeGen (easiest)
1. `brew install xcodegen`
2. In this folder run: `xcodegen`
3. Open `SmartCampus.xcodeproj`, pick a simulator, press Run.

## Option B — Into your existing Xcode project
1. Delete the template's ViewController.swift, AppDelegate.swift, SceneDelegate.swift, Main.storyboard.
2. Drag the contents of the `SmartCampus` folder (except Info.plist) into your project (Copy items if needed).
3. Target > Info: delete "Main storyboard file base name"; under Application Scene Manifest > Scene Configuration > Default Configuration, delete "Storyboard Name" and set Class to `$(PRODUCT_MODULE_NAME).SceneDelegate`.
4. Add the key "Privacy - Camera Usage Description" with a short message.
5. Set Deployment Target to iOS 15 or higher.

Login: admin / 1234. The Simulator has no camera, so use "Manual" on the Scan tab to type a pass ID (e.g. VIS-001).
