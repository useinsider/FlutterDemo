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

Note: You Can see the detailed usage of the methods used with the integration with Firebase by examining the `main.dart`, `App.tsx`, and `ios/Runner/AppDelegate.swift` files.

### Android

1. Add `agconnect-services.json` to `android/app` folder.
2. Add your keystore file to `android/app` folder and replace `signingConfigs` attributes in `android/app/build.gradle` file with your info.
3. Replace manifestPlaceholders -> partner value with your partner name in `android/app/build.gradle` file. (This step is important to add test device with QR or Email in the panel.)
4. And run project with `flutter run` command.

### iOS

1. Go to the iOS folder with terminal and run the `pod install` command.
2. Open XCode and check the app group and bundle identifier for all targets.
3. Replace `insider` URL type in main target Info -> URL Types with your partner name. (This step is important to add test device with QR or Email in the panel.)
4. Change APP_GROUP variables value in `InsiderNotificationService/NotificationService.m` and `InsiderNotificationContent/NotificationViewController.m` files.
5. And run project with XCode.
