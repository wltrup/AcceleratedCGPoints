# AcceleratedCGPoints
![](https://img.shields.io/badge/platforms-iOS%2013%20%7C%20tvOS%2013%20%7C%20watchOS%206%20%7C%20macOS%2010.15-red)
[![Xcode](https://img.shields.io/badge/Xcode-11-blueviolet.svg)](https://developer.apple.com/xcode)
[![Swift](https://img.shields.io/badge/Swift-5.2-orange.svg)](https://swift.org)
![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/wltrup/AcceleratedCGPoints)
![GitHub](https://img.shields.io/github/license/wltrup/AcceleratedCGPoints)

## What

**AcceleratedCGPoints** is a Swift Package Manager library for iOS/tvOS (10.3 and above), watchOS (6.0 and above), and macOS (10.15 and above), under Swift 5.2 and above, providing

- a conformance of `CGPoint` to `AdditiveArithmetic`, to support direct arithmetic operations on points:
```swift
extension CGPoint: AdditiveArithmetic {

    public static func + (lhs: Self, rhs: Self) -> Self
    public static func += (lhs: inout Self, rhs: Self)
    
    public static func - (lhs: Self, rhs: Self) -> Self
    public static func -= (lhs: inout Self, rhs: Self)

}

extension CGPoint {

    public mutating func scale(by rhs: CGFloat)
    public var magnitudeSquared: CGFloat

    public static func * (lhs: CGFloat, rhs: Self) -> Self
    public static func *= (lhs: inout Self, rhs: CGFloat)

}
```

- extensions to `Array`, to support accelerated arithmetic on large arrays of `CGPoint`s, using Apple's `Accelerate` framework

```swift
extension Array: AdditiveArithmetic where Element == CGPoint {

    // **NOTE**: `.zero` is an array of **length 1**.
    public static let zero: [CGPoint]

    // Returns an empty array if the arguments are empty arrays.
    // **NOTE**: crashes if the arguments are of different lengths.
    public static func + (lhs: Self, rhs: Self) -> Self
    public static func - (lhs: Self, rhs: Self) -> Self

    // Does nothing if the arguments are empty arrays.
    // **NOTE**: crashes if the arguments are of different lengths.
    public static func += (lhs: inout Self, rhs: Self)
    public static func -= (lhs: inout Self, rhs: Self)

}

extension Array: VectorArithmetic where Element == CGPoint {

    // Does nothing if `self` is an empty array.
    public mutating func scale(by rhs: Double)

    // Returns 0 if `self` is an empty array.
    public var magnitudeSquared: Double

}

extension Array where Element == CGPoint {

    // Does nothing if `self` is an empty array.
    public mutating func scale(by rhs: CGFloat)

    // Does nothing if `rhs` is an empty array.
    public static func * (lhs: CGFloat, rhs: Self) -> Self
    public static func * (lhs: Double,  rhs: Self) -> Self

    // Does nothing if `lhs` is an empty array.
    public static func *= (lhs: inout Self, rhs: CGFloat)
    public static func *= (lhs: inout Self, rhs: Double)

    // Performs the operations
    //
    //     p[i].x -> sx * p[i].x + q.x
    //     p[i].y -> sy * p[i].y + q.y
    //
    // on each point `p[i]` in the array, given two scalar values `sx` and `sy` (which
    // are interpreted as components of a point `s`) and a point `q`, returning the
    // result in a new array of points.
    //
    // Returns an empty array if `points` is an empty array.
    //
    public static func scale(_ points: [CGPoint], by s: CGPoint, thenAdd q: CGPoint) -> [CGPoint] 

    // Performs the operations
    //
    //     p[i].x -> sx * p[i].x - q.x
    //     p[i].y -> sy * p[i].y - q.y
    //
    // on each point `p[i]` in the array, given two scalar values `sx` and `sy` (which
    // are interpreted as components of a point `s`) and a point `q`, returning the
    // result in a new array of points.
    //
    // Returns an empty array if `points` is an empty array.
    //
    public static func scale(_ points: [CGPoint], by s: CGPoint, thenSubtract q: CGPoint) -> [CGPoint] 

    // Performs (in place) the operations
    //
    //     p[i].x -> sx * p[i].x + q.x
    //     p[i].y -> sy * p[i].y + q.y
    //
    // on each point `p[i]` in the array, given two scalar values `sx` and `sy` (which
    // are interpreted as components of a point `s`) and a point `q`.
    //
    // Does nothing if `self` is an empty array.
    //
    public mutating func scale(by s: CGPoint, thenAdd q: CGPoint) 

    // Performs (in place) the operations
    //
    //     p[i].x -> sx * p[i].x - q.x
    //     p[i].y -> sy * p[i].y - q.y
    //
    // on each point `p[i]` in the array, given two scalar values `sx` and `sy` (which
    // are interpreted as components of a point `s`) and a point `q`.
    //
    // Does nothing if `self` is an empty array.
    //
    public mutating func scale(by s: CGPoint, thenSubtract q: CGPoint) 

}
```

## Performance

Typical results when comparing the speeds of these operations (on an old 2012 MacBook Pro) against typical `forEach` or `map` implementations, on arrays of 1_000_000 points, appear below:

`+`  time per point (standard approach): 1.6e-06 seconds
`+`  time per point (accelerated approach): 1.2e-08 seconds
`+`  accelerated 129 times faster than standard

`+=` time per point (standard approach): 1.2e-06 seconds
`+=` time per point (accelerated approach): 1.6e-08 seconds
`+=` accelerated 74 times faster than standard

`-`  time per point (standard approach): 1.5e-06 seconds
`-`  time per point (accelerated approach): 8.6e-09 seconds
`-`  accelerated 174 times faster than standard

`-=` time per point (standard approach): 2.0e-06 seconds
`-=` time per point (accelerated approach): 2.3e-08 seconds
`-=` accelerated 88 times faster than standard

`scale` time per point (standard approach): 3.3e-07 seconds
`scale` time per point (accelerated approach): 4.4e-09 seconds
`scale` accelerated 75 times faster than standard

`magnitudeSquared` time per point (standard approach): 6.3e-07 seconds
`magnitudeSquared` time per point (accelerated approach): 1.2e-08 seconds
`magnitudeSquared` accelerated 54 times faster than standard

`scale(by:thenAdd:)` time per point (standard approach): 3.2e-07 seconds
`scale(by:thenAdd:)` time per point (accelerated approach): 2.8e-08 seconds
`scale(by:thenAdd:)` accelerated 12 times faster than standard

`scale(by:thenSubtract:)` time per point (standard approach): 3.6e-07 seconds
`scale(by:thenSubtract:)` time per point (accelerated approach): 2.8e-08 seconds
`scale(by:thenSubtract:)` accelerated 13 times faster than standard

## Installation

**AcceleratedCGPoints** is provided only as a Swift Package Manager package, because I'm moving away from CocoaPods and Carthage, and can be easily installed directly from Xcode.

## Author

Wagner Truppel, trupwl@gmail.com

## License

**AcceleratedCGPoints** is available under the MIT license. See the [LICENSE](./LICENSE) file for more info.
