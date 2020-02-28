# ConstraintsOperators 
[![CI Status](https://img.shields.io/travis/Voidilov/ConstraintsOperators.svg?style=flat)](https://cocoapods.org/pods/ConstraintsOperators)
[![Version](https://img.shields.io/cocoapods/v/ConstraintsOperators.svg?style=flat)](https://cocoapods.org/pods/ConstraintsOperators)
[![License](https://img.shields.io/cocoapods/l/ConstraintsOperators.svg?style=flat)](https://cocoapods.org/pods/ConstraintsOperators)
[![Platform](https://img.shields.io/cocoapods/p/ConstraintsOperators.svg?style=flat)](https://cocoapods.org/pods/ConstraintsOperators)

## Usage

Сreate constraints with simple expressions:

```swift
view1.ignoreAutoresizingMask()
view1.centerX =| view2.layout.centerX + 10
view1.centerY =| 15

view1.width <=| 200
view1.width >=| 100
//or
view1.width =| 100...200

view1.height =| view2.layout.height / 2 + 20
...
view.width =| 100
view.width =| 200 //automatically replaces previuos width constraint
...
view1.height.priority(.defaultLow) =| 0
...
view1.height.priority(900) =| 10
...
let constraint: NSLayoutConstraint = view1.height.deactivated =| 200
...
view1.height =| view1.superview
view1.centerX =| view2
...
[view1, view2].ignoreAutoresizingMask()
[view1, view2].height =| 200
view1[.centerX, .centerY] =| 0
view1.edges(.vertical) =| 0
...
Axis.vertical =| [10, view1, 0..., view2.fixed(200), 0...5, view3.layout.centerY, 10]
...
view1.top =| view1.leading //compile error, you cannot combine incompatible attributes
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
