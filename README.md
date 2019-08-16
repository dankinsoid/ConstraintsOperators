# ConstraintsOperators 
[![CI Status](https://img.shields.io/travis/Voidilov/ConstraintsOperators.svg?style=flat)](https://cocoapods.org/pods/ConstraintsOperators)
[![Version](https://img.shields.io/cocoapods/v/ConstraintsOperators.svg?style=flat)](https://cocoapods.org/pods/ConstraintsOperators)
[![License](https://img.shields.io/cocoapods/l/ConstraintsOperators.svg?style=flat)](https://cocoapods.org/pods/ConstraintsOperators)
[![Platform](https://img.shields.io/cocoapods/p/ConstraintsOperators.svg?style=flat)](https://cocoapods.org/pods/ConstraintsOperators)

## Usage

Сreate constraints with simple expressions:

```swift
let offset: CGFloat = 10
view1.layout.centerX =| view2.layout.centerX + offset
view1.layout.centerY =| offset

let maxWidth: CGFloat = 200
let minWidth: CGFloat = 100
view1.layout.width <=| maxWidth
view1.layout.width >=| minWidth

let heightRatio: CGFloat = 1 / 2
view1.layout.height =| view2.layout.height * heightRatio + 20
```

Supported operators: =|, <=|, >=|

Every operator returns a NSLayoutConstraint instance with the 'isActive' property set to 'true'.

## Installation

ConstraintsOperators is available through [CocoaPods](https://cocoapods.org). To install

it, simply add the following line to your Podfile:

```ruby
pod 'ConstraintsOperators'
```

## Author

Voidilov, voidilov@gmail.com

## License

ConstraintsOperators is available under the MIT license. See the LICENSE file for more info.
