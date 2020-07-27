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

    /// Multiplication of a (Double) scalar and a point.
    public mutating func scale(by rhs: Double) {
        x *= CGFloat(rhs)
        y *= CGFloat(rhs)
    }

    public var magnitudeSquared: Double {
        Double(x * x + y * y)
    }

}

extension CGPoint {

    /// Multiplication of a (CGFloat) scalar and a point.
    public mutating func scale(by rhs: CGFloat) {
        self.x *= rhs
        self.y *= rhs
    }

    /// Multiplication of a (CGFloat) scalar and a point.
    /// Equivalent to `scale(by:)` above.
    public static func * (lhs: CGFloat, rhs: Self) -> Self {
        CGPoint(x: lhs * rhs.x, y: lhs * rhs.y)
    }

    /// Multiplication of a (Double) scalar and a point.
    /// Equivalent to `scale(by:)` above.
    public static func * (lhs: Double, rhs: Self) -> Self {
        CGPoint(x: CGFloat(lhs) * rhs.x, y: CGFloat(lhs) * rhs.y)
    }

    /// Multiplication of a (CGFloat) scalar and a point.
    /// Equivalent to `scale(by:)` above.
    public static func *= (lhs: inout Self, rhs: CGFloat) {
        lhs.scale(by: rhs)
    }

    /// Multiplication of a (Double) scalar and a point.
    /// Equivalent to `scale(by:)` above.
    public static func *= (lhs: inout Self, rhs: Double) {
        lhs.scale(by: rhs)
    }

}

extension CGPoint {

    /// Same (CGFloat) range for both components.
    static func random(in range: ClosedRange<CGFloat>) -> CGPoint {
        CGPoint(x: .random(in: range), y: .random(in: range))
    }

    /// Same (Double) range for both components.
    static func random(in range: ClosedRange<Double>) -> CGPoint {
        CGPoint(x: .random(in: range), y: .random(in: range))
    }

    /// A separate (CGFloat) range for each component.
    static func random(xRange: ClosedRange<CGFloat>, yRange: ClosedRange<CGFloat>) -> CGPoint {
        CGPoint(x: .random(in: xRange), y: .random(in: yRange))
    }

    /// A separate (Double) range for each component.
    static func random(xRange: ClosedRange<Double>, yRange: ClosedRange<Double>) -> CGPoint {
        CGPoint(x: .random(in: xRange), y: .random(in: yRange))
    }

}
