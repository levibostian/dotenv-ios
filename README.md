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

* Create a new Build Phase in XCode to run this command. Reorder the new Build Phase to be first to run. That way this tool can generate the environment variables before XCode tries to compile your app's source code. 

First, create a bash script in your project (for example purposes here, we created a script named, `dot_env_ios.rb` in the root of the project. It's important to put it there so dotenv-ios can find the `.env` file in the root):

```ruby
#!/usr/bin/env ruby   

require 'dotenv'
Dotenv.load('.env')

`bundle exec dotenv-ios --source #{ENV["SOURCE_CODE_DIRECTORY"]}`
```

You will notice above that I am also using the `dotenv` ruby gem to make life even easier storing a variable `SOURCE_CODE_DIRECTORY` in `.env` I can use in this script. 

Now, back to XCode build scripts. Leave the shell as the default, `/bin/sh` and have the script in XCode simply execute your bash script you just made:

```
./dot_env_ios.rb
```

Done! 

*Note: It's highly recommended you checkout [this quick doc](https://gist.github.com/levibostian/aac45628ff00f677888824d651cc7724) on how to run ruby scripts within XCode as you may encounter issues along the way.*

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
