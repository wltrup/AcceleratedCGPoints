import CoreGraphics

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

extension CGPoint {

    /// Multiplication of a scalar and a point.
    public mutating func scale(by rhs: CGFloat) {
        self.x *= rhs
        self.y *= rhs
    }

    public var magnitudeSquared: CGFloat {
        (self.x * self.x) + (self.y * self.y)
    }

    /// Equivalent to `scale(by:)` above.
    public static func * (lhs: CGFloat, rhs: Self) -> Self {
        CGPoint(x: lhs * rhs.x, y: lhs * rhs.y)
    }

    /// Equivalent to `scale(by:)` above.
    public static func *= (lhs: inout Self, rhs: CGFloat) {
        lhs.x *= rhs
        lhs.y *= rhs
    }

}
