import SwiftUI

/// Addition and subtraction of points.
extension CGPoint: AdditiveArithmetic {

    public static func + (lhs: Self, rhs: Self) -> Self {
        CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    public static func += (lhs: inout Self, rhs: Self) {
        lhs.x += rhs.x
        lhs.y += rhs.y
    }

    public static func - (lhs: Self, rhs: Self) -> Self {
        CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    public static func -= (lhs: inout Self, rhs: Self) {
        lhs.x -= rhs.x
        lhs.y -= rhs.y
    }

}

extension CGPoint: VectorArithmetic {

    /// Multiplication of a scalar and a point.
    public mutating func scale <T: BinaryFloatingPoint> (by s: T) {
        x *= CGFloat(s)
        y *= CGFloat(s)
    }

    public var magnitudeSquared: Double {
        Double(x * x + y * y)
    }

}

extension CGPoint {

    /// Multiplication of a scalar and a point.
    /// Equivalent to `scale(by:)` above.
    public static func * <T: BinaryFloatingPoint> (lhs: T, rhs: Self) -> Self {
        CGPoint(x: CGFloat(lhs) * rhs.x, y: CGFloat(lhs) * rhs.y)
    }

    /// Multiplication of a scalar and a point.
    /// Equivalent to `scale(by:)` above.
    public static func *= <T: BinaryFloatingPoint> (lhs: inout Self, rhs: T) {
        lhs.scale(by: rhs)
    }

}

extension CGPoint {

    /// Same range for both components.
    public static func random <T> (in range: ClosedRange<T>) -> CGPoint
    where T: BinaryFloatingPoint, T.RawSignificand: FixedWidthInteger {
        CGPoint(x: CGFloat(T.random(in: range)), y: CGFloat(T.random(in: range)))
    }

    /// A range for each component.
    public static func random <T> (xRange: ClosedRange<T>, yRange: ClosedRange<T>) -> CGPoint
    where T: BinaryFloatingPoint, T.RawSignificand: FixedWidthInteger {
        CGPoint(x: CGFloat(T.random(in: xRange)), y: CGFloat(T.random(in: yRange)))
    }

}
