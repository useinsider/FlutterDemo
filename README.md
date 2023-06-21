# Insider Flutter Demo

<p align="center">
  <img src="assets/images/insider-logo-read-me.jpg">

  <table align="center">
    <tr>
      <td><a href="https://useinsider.com/"> Insider </a></td>
      <td><a href="https://pub.dev/packages/flutter_insider"> flutter_insider Package </a></td>
      <td><a href="https://academy.useinsider.com/docs/flutter-integration"> InsiderAcademy </a></td>
    </tr>
  </table>
</p>  

## Description

This Demo contains simple methods that you can use with the Insider SDK.

## Preview

<table align="center">
  <tbody>
    <tr>
      <td><img src="assets/images/preview.gif" width="250"></td>
    </tr>
  </tbody>
</table>


## Installation

Install all npm packages by running the `dart pub get` command in the home directory.

Replace partner name and app group value in `main.dart` with your info.

Run the `flutterfire configure --project={project}` command for your Firebase configuration.

Note: Can easily find the warnings added as comments by searching the `FIXME-INSIDER` key in the project and you can quickly make the necessary arrangements for the project.

Note: You can see the detailed usage of the methods used with the integration with Firebase by examining the `main.dart`, `ios/Runner/NotificationManager.h/m`, and `ios/Runner/AppDelegate.swift` files.

Important: Additional integration codes in the `ios/Runner/NotificationManager.h/m` file are important for Firebase and Insider SDK to work together on iOS.

### Android

1. Add `agconnect-services.json` to `android/app` folder.
2. Add your keystore file to `android/app` folder and replace `signingConfigs` attributes in `android/app/build.gradle` file with your info.
3. Replace manifestPlaceholders -> partner value with your partner name in `android/app/build.gradle` file. (This step is important to add test device with QR or Email in the panel.)
    - Also, edit the partner names in the `src/AndroidManifest.XML` for routing to the app with QR/Mail for multi-panel.
4. And run project with `flutter run` command.

### iOS

1. Go to the iOS folder with terminal and run the `pod install` command.
2. Open XCode and check the app group and bundle identifier for all targets.
3. Replace `insider` URL type in main target Info -> URL Types with your partner name. (This step is important to add test device with QR or Email in the panel.)
4. Change APP_GROUP variables value in `InsiderNotificationService/NotificationService.m` and `InsiderNotificationContent/NotificationViewController.m` files.
5. And run project with XCode.

## Additional Notes

### Multiple Inone Panel Handling On Insider SDK

To handle multiple panels in one app, some adjustments are required.

#### Both Platform

##### Multiple panels, one app initialize case

* When initializing the Insider SDK, the partner name defined as a parameter inside the initialize function should be defined with a dynamic variable. The Insider SDK must be initialized again after this variable has been updated according to the app status (Example: country selection).
    - Repeated initialization operations in the same session are invalid. The SDK works with the first initialized partner name. For stable operation of the next initialization process, it must be initialized after the app is killed and reopened.

Example: https://github.com/useinsider/FlutterDemo/blob/a57ba7d514e3643f9e6237dbddc10da1206d6d62/lib/main.dart#L56-L82

#### iOS

##### Multiple Notification Targets, one app use case

* If you need to manage the added notification targets for multiple panels, you can add these targets to the same project more than once. (Optional)
    - If you want to use such a structure, make sure that the app_group values ​​you use for multiple targets are similar. Make sure that the APP_GROUP variables that you define in the Insider and Notification targets are the same.

Example For Country Handling:
```
InsiderNotificationServiceRU (Target)
InsiderNotificationContentRU (Target)
```
 
```
InsiderNotificationServiceEU (Target)
InsiderNotificationContentEU (Target)
```
You can manage this by adding multiple services and content within the same project.

##### Test device addition case

* During the integration process, you can add the partner name you added to the Info tab (Main Target) in URL Types multiple times for your different panels to be directed to the application via QR/Email.

#### Android

#####  Test device addition case

* The partner name you add to app/build.gradle for directed to the application with QR/Email during the integration process is functional for a single panel.
    - Keep adding this code you added for the main panel you use. And replace your_partner_name value, with your main panel name. https://github.com/useinsider/FlutterDemo/blob/8f13f3061260863950864f595c427e2f434d1eac/android/app/build.gradle#L55
* Add the following code to your AndroidManifest.XML file to be able to use this routing in more than one panel on the same app.

Example: 

https://github.com/useinsider/FlutterDemo/blob/8f13f3061260863950864f595c427e2f434d1eac/android/app/src/main/AndroidManifest.xml#L35-L51
