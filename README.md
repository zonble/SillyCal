# SillyCal - Silly Calculator

A sample iPhone calculator app written in Objective-C, originally created as a
learning exercise and demonstration project.

## Features

- Basic arithmetic operations: addition, subtraction, multiplication, division
- Memory functions: MC (memory clear), M+ (memory plus), M- (memory minus),
  MR (memory recall)
- Positive/negative toggle (+/-)
- Decimal point input
- Division-by-zero error handling

## Technical Notes

- Written in Objective-C using manual reference counting (MRC/non-ARC).
  The code uses explicit [release] calls and retain properties, which reflects
  iOS development practices prior to the introduction of ARC (Automatic
  Reference Counting) in Xcode 4.2 / iOS 5.
- Targets ARMv7 devices (iPhone 3GS and later, original iPad and later).
- Uses UIKit's UIViewController and IBAction/IBOutlet wiring via Interface
  Builder (XIB files).
- Arithmetic is performed using NSDecimalNumber for precision, rather than
  floating-point types.
- The project includes a Travis CI configuration (.travis.yml) that builds
  against the i386 iPhone Simulator SDK.

## Legacy Status

This project is no longer maintained and is archived for historical reference.
It will not build with modern versions of Xcode without migration to ARC and
updates to deprecated APIs (e.g. UIAlertView, viewDidUnload,
shouldAutorotateToInterfaceOrientation:).
