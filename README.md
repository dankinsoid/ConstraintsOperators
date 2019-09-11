# ConstraintsOperators 
[![CI Status](https://img.shields.io/travis/Voidilov/ConstraintsOperators.svg?style=flat)](https://cocoapods.org/pods/ConstraintsOperators)
[![Version](https://img.shields.io/cocoapods/v/ConstraintsOperators.svg?style=flat)](https://cocoapods.org/pods/ConstraintsOperators)
[![License](https://img.shields.io/cocoapods/l/ConstraintsOperators.svg?style=flat)](https://cocoapods.org/pods/ConstraintsOperators)
[![Platform](https://img.shields.io/cocoapods/p/ConstraintsOperators.svg?style=flat)](https://cocoapods.org/pods/ConstraintsOperators)

## Usage

Сreate constraints with simple expressions:

```swift
view1.layout.centerX =| view2.layout.centerX + 10
view1.layout.centerY =| 15

view1.layout.width <=| 200
view1.layout.width >=| 100

view1.layout.height =| view2.layout.height / 2 + 20
...
view1.layout.height.priority(.defaultLow) =| 0
...
view1.layout.height.priority(900) =| 10
...
let constraint = view1.layout.height.deactivated =| 200
...
view1.layout.height =| view1.superview
view1.layout.centerX =| view2
...
[view1, view2].layout.height =| 200
view1.layout[.centerX, .centerY] =| 0
view1.layout.edges(.vertiacal) =| 0
...
Axis.vertical =| [10, view1, 10..., view2.fixed(200), 0...5]
```

Supported operators: `=|`, `<=|`, `>=|`

Every operator returns a `NSLayoutConstraint` instance with the `isActive` property set to `true`.

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
