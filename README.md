# AppmazoKit
AppmazoKit is a collection of commonly used boilerplate features.

[![CI Status](http://img.shields.io/travis/Appmazo/AppmazoKit.svg?style=flat)](https://travis-ci.org/Appmazo/AppmazoKit)
[![Version](https://img.shields.io/cocoapods/v/AppmazoKit.svg?style=flat)](http://cocoapods.org/pods/AppmazoKit.svg)
[![License](https://img.shields.io/cocoapods/l/AppmazoKit.svg?style=flat)](http://cocoapods.org/pods/AppmazoKit.svg)
[![Platform](https://img.shields.io/cocoapods/p/AppmazoKit.svg?style=flat)](http://cocoapods.org/pods/AppmazoKit.svg)

# Introduction
AppmazoKit is a collection of commonly used boilerplate code, UI elements and class extensions. 

## Installation

AppmazoKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "AppmazoKit"
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

# How to use

## Import

```swift
import AppmazoKit
```

# Managers

The Managers are great for simplifying common app flows like permissions, location services, biometric authentication and more.

- [Permissions Manager](#permissionsmanager)
- [Locations Manager](#locationsmanager)
- [Biometrics Manager](#biometricsmanager)
- [Ratings Manager](#ratingsmanager)

# UI Elements

The UI Elements contain frequently used UI for quick app prototyping and implementation.

- [Alert Controller](#alertcontroller)
- [Splash Animation](#splashanimation)
- [Modal Transitioning](#modaltransitioning)

# Class Extensions

The Class Extensions contain a lot of useful extensions of existing classes that should have been availble by default.

- [Keyboard Scroller](#keyboardscroller)
- [Date Extensions](#dateextensions)
- [URL Extensions](#urlextensions)

<a name="permissionsmanager">

## Permissions Manager

Helps streamline and manage common OS level permissions such as Location, Push Notifications and more.

<a name="locationsmanager">

## Locations Manager

Helps manage the user's location by providing a simplified manager with useful functions like getting user's current location, allowing custom locations entered as an address, storing last used location and more..

<a name="biometricsmanager">

## Biometrics Manager

A simple way for storing user credentials for use with Biometric verification.

<a name="ratingsmanager">

## Ratings Manager

A simple way for tracking and prompting users to rate your app.

<a name="alertcontroller">

## Alert Controller

A simple, efficient and familiar alert controller for a more elegant way to alert users.

<a name="splashanimation">

## Splash Animation

A simple view controller for showing a splash screen animation.

<a name="modaltransitioning">

## Modal Transitioning

UIViewControllerContextTransitioning for presenting modals.

<a name="keyboardscroller">

## Keyboard Scroller

A simple keyboard observer to allow UIScrollView to automatically scroll fields into view when the keyboard appears.

<a name="dateextensions">

## Date+Extensions

<a name="urlextensions">

## URL+Extensions

## Author

James Hickman, jhickman@appmazo.com

[![paypal](/Images/Buy-Me-A-Beer.png)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=CDFW3PEB76THY)
[![paypal](/Images/Buy-Me-A-6-Pack.png)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=B9QN4JF35KQUE)
[![paypal](/Images/Buy-Me-A-Keg.png)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=LGEHVAADUAMQJ)
[![paypal](/Images/Pay-Off-My-Student-Loans.png)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=FM6AQMF7YWRXY)

## License

The MIT License (MIT)

Copyright (c) 2015 NitWit Studios, LLC

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
