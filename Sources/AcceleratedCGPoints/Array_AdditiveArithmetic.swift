import CoreGraphics
import enum Accelerate.vDSP

/// Addition and subtraction of arrays of points.
extension Array: AdditiveArithmetic where Element == CGPoint {

    /// **NOTE**: `.zero` is an array of length 1.
    public static let zero: [CGPoint] = [.zero]

    /// Returns an empty array if the arguments are empty arrays.
    /// **NOTE**: crashes if the arguments are of different lengths.
    public static func + (lhs: Self, rhs: Self) -> Self {

        guard lhs.count == rhs.count else { fatalError("Arrays of unequal sizes") }
        if lhs.isEmpty { return [] }

        var result = [CGPoint](repeating: .zero, count: lhs.count)

        result.withUnsafeMutableBytes { resBuffer in
            var resTypedBuffer = resBuffer.bindMemory(to: Double.self)
            lhs.withUnsafeBytes { lhsBuffer in
                let lhsTypedBuffer = lhsBuffer.bindMemory(to: Double.self)
                rhs.withUnsafeBytes { rhsBuffer in
                    let rhsTypedBuffer = rhsBuffer.bindMemory(to: Double.self)
                    vDSP.add(lhsTypedBuffer, rhsTypedBuffer, result: &resTypedBuffer)
                }
            }
        }

        return result

    }

    /// Does nothing if the arguments are empty arrays.
    /// **NOTE**: crashes if the arguments are of different lengths.
    public static func += (lhs: inout Self, rhs: Self) {

        guard lhs.count == rhs.count else { fatalError("Arrays of unequal sizes") }
        if lhs.isEmpty { return }

        lhs.withUnsafeMutableBytes { lhsBuffer in
            var lhsTypedBuffer = lhsBuffer.bindMemory(to: Double.self)
            rhs.withUnsafeBytes { rhsBuffer in
                let rhsTypedBuffer = rhsBuffer.bindMemory(to: Double.self)
                vDSP.add(lhsTypedBuffer, rhsTypedBuffer, result: &lhsTypedBuffer)
            }
        }

    }

    /// Returns an empty array if the arguments are empty arrays.
    /// **NOTE**: crashes if the arguments are of different lengths.
    public static func - (lhs: Self, rhs: Self) -> Self {

        guard lhs.count == rhs.count else { fatalError("Arrays of unequal sizes") }
        if lhs.isEmpty { return [] }

        var result = [CGPoint](repeating: .zero, count: lhs.count)

        result.withUnsafeMutableBytes { resBuffer in
            var resTypedBuffer = resBuffer.bindMemory(to: Double.self)
            lhs.withUnsafeBytes { lhsBuffer in
                let lhsTypedBuffer = lhsBuffer.bindMemory(to: Double.self)
                rhs.withUnsafeBytes { rhsBuffer in
                    let rhsTypedBuffer = rhsBuffer.bindMemory(to: Double.self)
                    vDSP.subtract(lhsTypedBuffer, rhsTypedBuffer, result: &resTypedBuffer)
                }
            }
        }

        return result

    }

    /// Does nothing if the arguments are empty arrays.
    /// **NOTE**: crashes if the arguments are of different lengths.
    public static func -= (lhs: inout Self, rhs: Self) {

        guard lhs.count == rhs.count else { fatalError("Arrays of unequal sizes") }
        if lhs.isEmpty { return }

        lhs.withUnsafeMutableBytes { lhsBuffer in
            var lhsTypedBuffer = lhsBuffer.bindMemory(to: Double.self)
            rhs.withUnsafeBytes { rhsBuffer in
                let rhsTypedBuffer = rhsBuffer.bindMemory(to: Double.self)
                vDSP.subtract(lhsTypedBuffer, rhsTypedBuffer, result: &lhsTypedBuffer)
            }
        }

    }

}
