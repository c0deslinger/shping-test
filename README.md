# Photo Album

This is a photo album app that fetches data from Unsplash.

## Additional Features
- Cache mode: Fetches data from cache if no internet connection is available.
- Shimmer loading: Provides a loading animation while fetching data.
- Dark mode: Supports dark mode for better user experience.
- Flutter flavor: Can be run with local, dev, or production environment.
  You can check how flavor works by reading my articles:
  [How to Build Flavor in Flutter Android with Different Firebase Config](https://ahmedyusuf.medium.com/how-to-build-flavor-in-flutter-android-with-different-firebase-config-96b259e5572e)
  and 
  [Setup Flavors in iOS Flutter with Different Firebase Config](https://ahmedyusuf.medium.com/setup-flavors-in-ios-flutter-with-different-firebase-config-43c4c4823e6b).
- Extension on text to auto capitalize on first letter
- Add gorouter
- Add localization
- Unit test: Not yet implemented.

## How to Run
A. Run from VSCode

Create or modify the `launch.json` file in the `.vscode` folder as follows:
```
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Development",
            "request": "launch",
            "type": "dart",
            "program" : "lib/main_dev.dart",
            "args": [
                "--flavor",
                "Dev"
            ]
        },
        {
            "name": "Production",
            "request": "launch",
            "type": "dart",
            "flutterMode": "release",
            "program" : "lib/main_prod.dart",
            "args": [
                "--flavor",
                "Prod"
            ]
        }
    ]
}
```

B. Build using Command Line
- Build appbundle
  
  For production:
  
  ```flutter build appbundle --flavor prod -t lib/main_prod.dart```
  
  For development:
  
  ```flutter build appbundle --flavor dev -t lib/main_dev.dart```

- Build APK
  
  For production:
  
  ```flutter build apk --flavor prod -t lib/main_prod.dart```
  
  For development:
  
  ```flutter build apk --flavor dev -t lib/main_dev.dart```

## Config file
The configuration file is located in the project/config folder. There, you can find variables such as unsplash_api_url and unsplash_api_key, which are separated for each environment using the flavor mechanism. This will be useful if there are differences in the API URL and API key for each environment in the future, without needing to change much code.