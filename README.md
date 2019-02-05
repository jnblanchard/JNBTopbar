# JNBTopbar

[![CI Status](https://img.shields.io/travis/jnblanchard@mac.com/JNBTopbar.svg?style=flat)](https://travis-ci.org/jnblanchard@mac.com/JNBTopbar)
[![Version](https://img.shields.io/cocoapods/v/JNBTopbar.svg?style=flat)](https://cocoapods.org/pods/JNBTopbar)
[![License](https://img.shields.io/cocoapods/l/JNBTopbar.svg?style=flat)](https://cocoapods.org/pods/JNBTopbar)
[![Platform](https://img.shields.io/cocoapods/p/JNBTopbar.svg?style=flat)](https://cocoapods.org/pods/JNBTopbar)

![](https://static.wixstatic.com/media/8e69fb_7cf92e1b92e94f8495f4c1371424127e~mv2.gif)

## Requirements

iOS 11+

## Installation

JNBTopbar is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'JNBTopbar'
```

## Example

Here's how one may show a greeting label for two and a half seconds.
```swift
JNBTopbar.shared.showWith(contentView: label,
                             contentBackgroundColor: UIColor.black,
                             cornerRadius: 6,
                             screenInsets: UIEdgeInsets(top: 0, left: -8, bottom: -16, right: -8),
                             shadowColor: UIColor.black.cgColor,
                             shadowOpacity: 0.7,
                             shadowRadius: 10,
                             borderWidth: 2.0,
                             borderColor: UIColor.white.cgColor,
                             forDuration: 2.5,
                             completion: nil)
```

If you do not specify a forDuration; the bar will show until hide or another call to show is made.
```swift
JNBTopbar.shared.hide { (completed) in
  guard completed else { return }
  // bar has finished animating uup
}
```

## License

MIT license. See the LICENSE file for more info.

## Author

jnblanchard@mac.com
