# UIViewAnimationTransitionQueue

Make UIView animation or transition chain more easliy

![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)
![License: MIT](https://img.shields.io/badge/platform-iOS-green.svg)
![License: MIT](https://img.shields.io/badge/Pod-v0.39.0-yellow.svg)


## Contents

- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)

## Requirements

- iOS 10.0+
- Xcode 8.0+
- Swift 3.0+

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate **UIViewAnimaitonTransitionQueue** into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'UIViewAnimationTransitionQueue', '~> 0.1.1'
end
```

Then, run the following command:

```bash
$ pod install
```

### Manually

Just copy [UIViewAnimationTransitionQueue.swift](UIViewAnimationTransitionQueue/UIViewAnimationTransitionQueue.swift) into your project


## Usage

### Pure Animation Queue: UIView.animationQ

`.add`: add animation setting into queue

example in [ViewController](UIViewAnimationTransitionQueue/ViewController.swift)

```swift
UIView.animationQ
            .add {
                self.vBlock.frame = self.miniFrame!
            }.add(duration: 3, dampingRatio: 0.1, velocity: 1) {
                self.vBlock.frame = self.largeFrame!
            }.add(duration: 2) {
                self.vBlock.frame = self.miniFrame!
            }.done {
                print("pausing 3 secs")
            }
            .pause(3)
            .done {
                print("pause end")
            }
            .add {
                self.vBlock.frame = self.originFrame!
            }.done {
                print("ani end")
            }.start()
```

### Pure Transition Queue: UIView.transitionQ

`.add`: add transition setting into queue, from view argument needed

example in [ViewController](UIViewAnimationTransitionQueue/ViewController.swift)

```swift
UIView.transitionQ
            .add(vBlock, toView: nil, options: .transitionFlipFromBottom) {
                self.vBlock.addSubview(self.ivEmoji)
            }.done {
                print("pausing 3 secs")
            }
            .pause(3)
            .done {
                print("pause end")
            }
            .add(vBlock, toView: nil, options: .transitionFlipFromTop) {
                self.ivEmoji.removeFromSuperview()
            }.done {
                print("transition end")
            }.start()
```

### Mix Animation and Transition Queue

`.addTrans`: add transition into queue, from view argument needed

`.addAnim`: add animation setting into queue

example in [ViewController](UIViewAnimationTransitionQueue/ViewController.swift)

```swift
UIView.transformQ
            .addTrans(vBlock, toView: nil, options: .transitionFlipFromBottom) {
                self.vBlock.addSubview(self.ivEmoji)
            }.addAnim {
                self.vBlock.frame = self.largeFrame!
                self.ivEmoji.frame = CGRect(origin: CGPoint.zero, size:self.largeFrame!.size)
            }.done {
                print("pausing 2 sec")
            }.pause(2)
            .done {
                print("pause end")
            }.addTrans(vBlock, toView: nil,options: .transitionFlipFromTop){
                self.ivEmoji.removeFromSuperview()
                self.ivEmoji.frame = CGRect(origin: CGPoint.zero, size: self.originFrame!.size)
            }.addAnim {
                self.vBlock.frame = self.originFrame!
            }.done {
                print("all end")
            }.start()
```

### Common Action

`.pause`: pausing a period of time, default 1 second

`.done`: execute after previous action done

`.start()`: start to do setting in **FIFO** order

## License

UIViewAnimationTransitionQueue is released under the MIT license. See LICENSE for details.