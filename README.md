## TMDB

A simple app for searching movies, depending on TMDB API.



#### <u>Design pattern (VIPER)</u>:

Viper is a design pattern that implements ‘separation of concern’ paradigm. Mostly like MVP or MVC it follows a modular approach. One feature, one module. For each module VIPER has five (sometimes four) different classes with distinct roles. No class go beyond its sole purpose. These classes are following.

**View:** Class that has all the code to show the app interface to the user and get their response. Upon receiving the response View alerts the Presenter.

**Presenter:** Nucleus of a module. It gets user response from the View and work accordingly. Only class to communicate with all other components. Calls the router for wire-framing, Interactor to fetch data (network calls or local data calls), view to update the UI.

**Interactor:** Have business logics of an app. Primarily make API calls to fetch data from a source. Responsible for making data calls but not necessarily from itself.

**Router:** Does the wire-framing. Listen from the presenter about which screen to present and executes it.

**Entity:** Contains plain model classes used by interactor.



## Requirements

- iOS 9.0+
- Xcode 9.0
- Swift 4.0



## Dependencies

- [Cocoapods](http://cocoapods.org) 
- [Alamofire](https://github.com/Alamofire/Alamofire) 
- [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) 

- [Nuke](https://github.com/kean/Nuke)
- [OHHTTPStubs](https://github.com/AliSoftware/OHHTTPStubs) 



## Building the app
#### 1- Install dependencies:

Install Cocoapods if not installed by running the below command in Terminal:

```bash
sudo gem install cocoapods
```

If Cocoapods installed, run the below command, all dependencies should be downloaded.

```bash
pod install
```

#### 2- Building the project:

- Open the `TMDB.xcworkspace` (should be created after installing dependencies).
- Select **TMDB** project.
- Under Targets -> General -> Signing, Choose your **Team** (you might need to change the **Bundle Identifier**).
- Choose your target device and hit Run.

