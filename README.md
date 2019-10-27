# QuickELogger [![Bitrise](https://app.bitrise.io/app/c7517344c4df3fb0/status.svg?token=At32U3i-V_TdPJEvW2yYOQ&branch=master)](https://app.bitrise.io/app/c7517344c4df3fb0) [![License](https://img.shields.io/dub/l/vibe-d.svg)](https://github.com/rbaumbach/InstagramSimpleOAuth/blob/master/MIT-LICENSE.txt)

A quick and simple way to log JSON log messages to disk in your iPhone or iPad app.

## Adding QuickELogger to your project

### CocoaPods

[CocoaPods](http://cocoapods.org) is the recommended way to add QuickELogger to your project.

1.  Add QuickELogger to your Podfile `pod 'QuickELogger'`.
2.  Install the pod(s) by running `pod install`.
3.  Add QuickELogger to your files with `import QuickELogger`.

### Clone from Github

1.  Clone repository from github and copy files directly, or add it as a git submodule.
2.  Add all files from `Source` directory to your project.

## How To

* Create an instance of `QuickELogger`, and then it's as simple as calling `log(:message:type)`.
* This logger has the following (pretty standard) log types: `verbose, info, debug, warn, error`.

Note: The file is saved in the `/Documents` directory.

Additional note: By default the filename is `QuickELogger.json`.  You can specify a different filename in `init(:filename)`.

### Example Usage

```swift
import QuickELogger

let logger = QuickELogger()

logger(message: "Black beans > Pinto beans", type: .info)
```

What happens at `/Documents/QuickELogger.json`:

```
[
  {
    "timeStamp" : "2019-10-27T02:32:57Z",
    "id" : "41593EA2-9D4D-4406-839B-2298AD7FA2E3",
    "message" : "Black beans > Pinto beans",
    "type" : "info"
  }
]
```

Note: `Black beans > Pinto beans` would result in a "falsy" output.

## Additional Info

### Gotchas

This logger doesn't append to a log file in the traditional sense.  It reads from a current log (if one exists), and then overwrites that log with updated logs.  This framework was created out of necessity to write logs to disk easily without loading in huge log frameworks and shouldn't be used for ultra-heavy logging.

Plans to make this more "enterprise-ready" are being evaluated.

### Treats

This library comes with a protocol ready to use in your application for those of you that enjoy testing your software.  This allows you to program your application to this "interface" and then you can stub it out with your own fake implementation for unit tests:

```swift
public protocol QuickELoggerProtocol {
    func log(message: String, type: LogType)
}
```

## Testing

* Prerequisites: [ruby](https://github.com/sstephenson/rbenv), [ruby gems](https://rubygems.org/pages/download), [bundler](http://bundler.io)

This project has been setup to use [fastlane](https://fastlane.tools) to run the specs.

First, run the `setup.sh` script to bundle required gems and Cocoapods when in the project directory:

```bash
$ ./setup.sh
```

And then use fastlane to run all the specs on the command line:

```bash
$ bundle exec fastlane run_all_specs
```

## Version History

Version history can be found [on releases page](https://github.com/rbaumbach/QuickELogger/releases).

## Suggestions, requests, and feedback

Thanks for checking out QuickELogger for your logging needs.  Any feedback can be can be sent to: github@ryan.codes.
