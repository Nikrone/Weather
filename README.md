# Weather

Weather is a weather app for iOS written in Swift. The app runs on iOS 15 and above.

The app includes a daily weather forecast and additional weather descriptions:

* HUMIDITY
* WIND
* FEELS LIKE
* PRESSURE
* VISIBILITY
* UV INDEX

## Screenshots
![Loading](https://github.com/Nikrone/Weather/blob/main/Weather/Resources/Screenshots/Simulator%20screen%201.png)
![Loading](https://github.com/Nikrone/Weather/blob/main/Weather/Resources/Screenshots/Simulator%20screen%202.png)

## Used features
* Swift Programming Language
* Architecture - MVP(custom) + Combine
* Core Location
* [Weather API](https://www.weatherapi.com)
* [Alamofire](https://github.com/Alamofire/Alamofire)
* [SwiftGen](https://github.com/SwiftGen/SwiftGen)
* [SnapKit](https://github.com/SnapKit/SnapKit)

## How to build

1) Download the repository

```
$ git clone https://github.com/Nikrone/Weather.git
$ cd Weather
```

2) Initialize pods

```
$ pod install
```

3) Open the project in Xcode

```
$ open "Weather.xcworkspace"
```

4) Add your API key

After downloading the application, go to [Weather API](https://www.weatherapi.com) and register an API key.
Once you have the API key, open the Configurations folder and the Enviroment.swift file and go to line 11 and replace it with your API key.

5) Compile and run the app in your simulator

# Requirements

- Xcode 15
- iOS 15
