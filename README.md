# dotenv-ios

Give access to `.env` environment variables file within your iOS projects. 

`dotenv-ios` is a simple CLI tool you can run on each XCode build to inject environment variables into your iOS app. This tool was inspired by [the twelve-factor app](https://12factor.net/config) to make environmental changes in your app simple. 

*Note: At this time, only Swift is supported.*

# Getting started

* Install this tool:

```
gem install dotenv-ios
```

* In the root of your iOS project, create a `.env` file and store all of the environment variables you wish inside. (Make sure to add this file to your `.gitignore` to avoid checking it into source control!)

* In your iOS app's source code, reference environment variables that you want to use:

```swift
let apiHost: String = Env.apiHost
```

At first, XCode will complain that `Env.apiHost` cannot be found. Don't worry. We will be fixing that. `dotenv-ios` CLI crawls your source code looking for `Env.X` requests and generating a `Env.swift` file for you! Anytime you want to use environmental variables, you just need to add it to your source. Super easy. 

* Create a new Build Phase in XCode to run this command. 

The shell command for this build phase is quite simple: `dotenv-ios --source PathToYourSourceCode/`

Reorder the new Build Phase to be first to run. That way this tool can generate the environment variables before XCode tries to compile your app's source code. 

* Run a build in XCode (Cmd + B) to run the `dotenv-ios` CLI tool. 

* Add the newly generated `PathToYourSourceCode/Env.swift` file to your XCode project. 

* Done! 

## Development 

```bash
$> bundle install
```

You're ready to start developing! 

## Deployment 

This gem is setup automatically to deploy to RubyGems on a git tag deployment. 

* Add `RUBYGEMS_KEY` secret to Travis-CI's settings. 
* Make a new git tag, push it up to GitHub. Travis will deploy for you. 

## Author

* Levi Bostian - [GitHub](https://github.com/levibostian), [Twitter](https://twitter.com/levibostian), [Website/blog](http://levibostian.com)

![Levi Bostian image](https://gravatar.com/avatar/22355580305146b21508c74ff6b44bc5?s=250)

## Contribute

dotenv-ios is open for pull requests. Check out the [list of issues](https://github.com/levibostian/dotenv-ios/issues) for tasks I am planning on working on. Check them out if you wish to contribute in that way.

**Want to add features?** Before you decide to take a bunch of time and add functionality to the library, please, [create an issue]
(https://github.com/levibostian/dotenv-ios/issues/new) stating what you wish to add. This might save you some time in case your purpose does not fit well in the use cases of this project.
