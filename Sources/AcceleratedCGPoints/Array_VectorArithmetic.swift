import SwiftUI
import enum Accelerate.vDSP

extension Array: VectorArithmetic where Element == CGPoint {

    /// Multiplication of a single scalar and an array of points.
    /// Does nothing if `self` is an empty array.
    public mutating func scale(by rhs: Double) {
        if self.isEmpty { return }
        self.withUnsafeMutableBytes { selfBuffer in
            var selfTypedBuffer = selfBuffer.bindMemory(to: Double.self)
            vDSP.multiply(rhs, selfTypedBuffer, result: &selfTypedBuffer)
        }
    }

    /// Returns 0 if `self` is an empty array.
    public var magnitudeSquared: Double {
        if self.isEmpty { return .zero }
        var result: Double = .zero
        self.withUnsafeBytes { selfBuffer in
            let selfTypedBuffer = selfBuffer.bindMemory(to: Double.self)
            result = vDSP.sum(vDSP.multiply(selfTypedBuffer, selfTypedBuffer))
        }
        return result
    }

}

extension Array where Element == CGPoint {

    /// Does nothing if `self` is an empty array.
    public mutating func scale(by rhs: CGFloat) {
        self.scale(by: Double(rhs))
    }

    /// Multiplication of a single scalar and an array of points.
    /// Equivalent to `scale(by:)` above.
    /// Does nothing if `rhs` is an empty array.
    public static func * (lhs: CGFloat, rhs: Self) -> Self {
        if rhs.isEmpty { return rhs }
        var res = rhs
        res.scale(by: lhs)
        return res
    }

    /// Multiplication of a single scalar and an array of points.
    /// Equivalent to `scale(by:)` above.
    /// Does nothing if `rhs` is an empty array.
    public static func * (lhs: Double, rhs: Self) -> Self {
        if rhs.isEmpty { return rhs }
        var res = rhs
        res.scale(by: lhs)
        return res
    }

    /// Multiplication of a single scalar and an array of points.
    /// Equivalent to `scale(by:)` above.
    /// Does nothing if `lhs` is an empty array.
    public static func *= (lhs: inout Self, rhs: CGFloat) {
        lhs.scale(by: rhs)
    }

    /// Multiplication of a single scalar and an array of points.
    /// Equivalent to `scale(by:)` above.
    /// Does nothing if `lhs` is an empty array.
    public static func *= (lhs: inout Self, rhs: Double) {
        lhs.scale(by: rhs)
    }

    /// Performs the operations
    ///
    ///     p[i].x -> sx * p[i].x + q.x
    ///     p[i].y -> sy * p[i].y + q.y
    ///
    /// on each point `p[i]` in the array, given two scalar values `sx` and `sy` (which
    /// are interpreted as components of a point `s`) and a point `q`, returning the
    /// result in a new array of points.
    ///
    /// Returns an empty array if `points` is an empty array.
    ///
    public static func scale(_ points: [CGPoint], by s: CGPoint, thenAdd q: CGPoint) -> [CGPoint] {

        if points.isEmpty { return [] }

        let sa = [CGPoint](repeating: s, count: points.count)
        let qa = [CGPoint](repeating: q, count: points.count)
        var result = [CGPoint](repeating: .zero, count: points.count)

        result.withUnsafeMutableBytes { resBuffer in
            var resTypedBuffer = resBuffer.bindMemory(to: Double.self)
            points.withUnsafeBytes { pointsBuffer in
                let pointsTypedBuffer = pointsBuffer.bindMemory(to: Double.self)
                sa.withUnsafeBytes { saBuffer in
                    let saTypedBuffer = saBuffer.bindMemory(to: Double.self)
                    qa.withUnsafeBytes { qaBuffer in
                        let qaTypedBuffer = qaBuffer.bindMemory(to: Double.self)
                        vDSP.add(
                            multiplication: (saTypedBuffer, pointsTypedBuffer),
                            qaTypedBuffer,
                            result: &resTypedBuffer
                        )
                    }
                }
            }
        }

        return result

    }

    /// Performs the operations
    ///
    ///     p[i].x -> sx * p[i].x - q.x
    ///     p[i].y -> sy * p[i].y - q.y
    ///
    /// on each point `p[i]` in the array, given two scalar values `sx` and `sy` (which
    /// are interpreted as components of a point `s`) and a point `q`, returning the
    /// result in a new array of points.
    ///
    /// Returns an empty array if `points` is an empty array.
    ///
    public static func scale(_ points: [CGPoint], by s: CGPoint, thenSubtract q: CGPoint) -> [CGPoint] {

        if points.isEmpty { return [] }

        let sa = [CGPoint](repeating: s, count: points.count)
        let qa = [CGPoint](repeating: q, count: points.count)
        var result = [CGPoint](repeating: .zero, count: points.count)

        result.withUnsafeMutableBytes { resBuffer in
            var resTypedBuffer = resBuffer.bindMemory(to: Double.self)
            points.withUnsafeBytes { pointsBuffer in
                let pointsTypedBuffer = pointsBuffer.bindMemory(to: Double.self)
                sa.withUnsafeBytes { saBuffer in
                    let saTypedBuffer = saBuffer.bindMemory(to: Double.self)
                    qa.withUnsafeBytes { qaBuffer in
                        let qaTypedBuffer = qaBuffer.bindMemory(to: Double.self)
                        vDSP.subtract(
                            multiplication: (saTypedBuffer, pointsTypedBuffer),
                            qaTypedBuffer,
                            result: &resTypedBuffer
                        )
                    }
                }
            }
        }

        return result

    }

    /// Performs (in place) the operations
    ///
    ///     p[i].x -> sx * p[i].x + q.x
    ///     p[i].y -> sy * p[i].y + q.y
    ///
    /// on each point `p[i]` in the array, given two scalar values `sx` and `sy` (which
    /// are interpreted as components of a point `s`) and a point `q`.
    ///
    /// Does nothing if `self` is an empty array.
    ///
    public mutating func scale(by s: CGPoint, thenAdd q: CGPoint) {

        if self.isEmpty { return }

        let sa = [CGPoint](repeating: s, count: self.count)
        let qa = [CGPoint](repeating: q, count: self.count)

        self.withUnsafeMutableBytes { selfBuffer in
            var selfTypedBuffer = selfBuffer.bindMemory(to: Double.self)
            sa.withUnsafeBytes { saBuffer in
                let saTypedBuffer = saBuffer.bindMemory(to: Double.self)
                qa.withUnsafeBytes { qaBuffer in
                    let qaTypedBuffer = qaBuffer.bindMemory(to: Double.self)
                    vDSP.add(
                        multiplication: (saTypedBuffer, selfTypedBuffer),
                        qaTypedBuffer,
                        result: &selfTypedBuffer
                    )
                }
            }
        }

    }

    /// Performs (in place) the operations
    ///
    ///     p[i].x -> sx * p[i].x - q.x
    ///     p[i].y -> sy * p[i].y - q.y
    ///
    /// on each point `p[i]` in the array, given two scalar values `sx` and `sy` (which
    /// are interpreted as components of a point `s`) and a point `q`.
    ///
    /// Does nothing if `self` is an empty array.
    ///
    public mutating func scale(by s: CGPoint, thenSubtract q: CGPoint) {

        if self.isEmpty { return }

        let sa = [CGPoint](repeating: s, count: self.count)
        let qa = [CGPoint](repeating: q, count: self.count)

        self.withUnsafeMutableBytes { selfBuffer in
            var selfTypedBuffer = selfBuffer.bindMemory(to: Double.self)
            sa.withUnsafeBytes { saBuffer in
                let saTypedBuffer = saBuffer.bindMemory(to: Double.self)
                qa.withUnsafeBytes { qaBuffer in
                    let qaTypedBuffer = qaBuffer.bindMemory(to: Double.self)
                    vDSP.subtract(
                        multiplication: (saTypedBuffer, selfTypedBuffer),
                        qaTypedBuffer,
                        result: &selfTypedBuffer
                    )
                }
            }
        }

    }

}
