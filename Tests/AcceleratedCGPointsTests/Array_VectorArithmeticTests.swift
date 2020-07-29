import XCTest
@testable import AcceleratedCGPoints

final class Array_VectorArithmeticTests: XCTestCase {

    var a = [CGPoint.zero]
    var s: Double = 1

    func randomPoint() -> CGPoint {
        CGPoint(
            x: CGFloat.random(in: -1...1),
            y: CGFloat.random(in: -1...1)
        )
    }

    func randomArray(count: Int) -> [CGPoint] {
        (1 ... count).map { _ in randomPoint() }
    }

    override func setUp() {
        let count = 1_000
        a = randomArray(count: count)
        s = Double.random(in: -1...1)
    }

    func test_scale_empty() {
        var res: [CGPoint] = []
        res.scale(by: s)
        XCTAssertEqual(res, [])
    }

    func test_scale() {
        let exp = a.map { p in
            CGPoint(
                x: CGFloat(s) * p.x,
                y: CGFloat(s) * p.y
            )
        }
        var res = a
        res.scale(by: s)
        XCTAssertEqual(res, exp)
    }

    func test_magnitudeSquared_empty() {
        let a: [CGPoint] = []
        let res = a.magnitudeSquared
        XCTAssertEqual(res, 0)
    }

    func test_magnitudeSquared() {
        let exp = a
            .map { p in (p.x * p.x) + (p.y * p.y) }
            .reduce(0, +)
        let res = a.magnitudeSquared
        let expI = Int(10_000_000 * exp)
        let resI = Int(10_000_000 * res)
        XCTAssertEqual(resI, expI)
    }

    func test_scalar_times_point_empty() {
        let a: [CGPoint] = []
        let res = s * a
        XCTAssertEqual(res, a)
    }

    func test_scalar_times_point() {
        let exp = a.map { p in
            CGPoint(
                x: CGFloat(s) * p.x,
                y: CGFloat(s) * p.y
            )
        }
        let res = s * a
        XCTAssertEqual(res, exp)
    }

    func test_point_timesEqual_scalar_empty() {
        let a: [CGPoint] = []
        var res = a
        res *= s
        XCTAssertEqual(res, a)
    }

    func test_point_timesEqual_scalar() {
        let exp = a.map { p in
            CGPoint(
                x: CGFloat(s) * p.x,
                y: CGFloat(s) * p.y
            )
        }
        var res = a
        res *= s
        XCTAssertEqual(res, exp)
    }

    func test_performance_scale() {

        let count = 100_000
        a = randomArray(count: count)

        var start = Date()
        _ = a.map { p in
            CGPoint(
                x: CGFloat(s) * p.x,
                y: CGFloat(s) * p.y
            )
        }
        var end = Date()
        var timeElapsed = end.timeIntervalSince(start)
        let timePerPoint1 = timeElapsed / Double(count)
        print("scale timePerPoint (   standard approach): \(timePerPoint1)")

        var res = a
        start = Date()
        res.scale(by: s)
        end = Date()
        timeElapsed = end.timeIntervalSince(start)
        let timePerPoint2 = timeElapsed / Double(count)
        print("scale timePerPoint (accelerated approach): \(timePerPoint2)")
        print("scale ratio: \(timePerPoint1 / timePerPoint2)")

    }

    func test_performance_magnitudeSquared() {

        let count = 100_000
        a = randomArray(count: count)

        var start = Date()
        _ = a
            .map { p in (p.x * p.x) + (p.y * p.y) }
            .reduce(0, +)
        var end = Date()
        var timeElapsed = end.timeIntervalSince(start)
        let timePerPoint1 = timeElapsed / Double(count)
        print("magnitudeSquared timePerPoint (   standard approach): \(timePerPoint1)")

        start = Date()
        _ = a.magnitudeSquared
        end = Date()
        timeElapsed = end.timeIntervalSince(start)
        let timePerPoint2 = timeElapsed / Double(count)
        print("magnitudeSquared timePerPoint (accelerated approach): \(timePerPoint2)")
        print("magnitudeSquared ratio: \(timePerPoint1 / timePerPoint2)")

    }

    func test_static_scale_by_then_add_empty() {
        let s = randomPoint()
        let q = randomPoint()
        let a: [CGPoint] = []
        let res = [CGPoint].scale(a, by: s, thenAdd: q)
        XCTAssertEqual(res, [])
    }

    func test_static_scale_by_then_add() {
        let s = randomPoint()
        let q = randomPoint()
        let exp = a.map { p in
            CGPoint(
                x: s.x * p.x + q.x,
                y: s.y * p.y + q.y
            )
        }
        let res = [CGPoint].scale(a, by: s, thenAdd: q)
        XCTAssertEqual(res, exp)
    }

    func test_static_scale_by_then_subtract_empty() {
        let s = randomPoint()
        let q = randomPoint()
        let a: [CGPoint] = []
        let res = [CGPoint].scale(a, by: s, thenSubtract: q)
        XCTAssertEqual(res, [])
    }

    func test_static_scale_by_then_subtract() {
        let s = randomPoint()
        let q = randomPoint()
        let exp = a.map { p in
            CGPoint(
                x: s.x * p.x - q.x,
                y: s.y * p.y - q.y
            )
        }
        let res = [CGPoint].scale(a, by: s, thenSubtract: q)
        XCTAssertEqual(res, exp)
    }

    func test_scale_by_then_add_empty() {
        let s = randomPoint()
        let q = randomPoint()
        let a: [CGPoint] = []
        var res = a
        res.scale(by: s, thenAdd: q)
        XCTAssertEqual(res, [])
    }

    func test_scale_by_then_add() {
        let s = randomPoint()
        let q = randomPoint()
        let exp = a.map { p in
            CGPoint(
                x: s.x * p.x + q.x,
                y: s.y * p.y + q.y
            )
        }
        var res = a
        res.scale(by: s, thenAdd: q)
        XCTAssertEqual(res, exp)
    }

    func test_scale_by_then_subtract_empty() {
        let s = randomPoint()
        let q = randomPoint()
        let a: [CGPoint] = []
        var res = a
        res.scale(by: s, thenSubtract: q)
        XCTAssertEqual(res, [])
    }

    func test_scale_by_then_subtract() {
        let s = randomPoint()
        let q = randomPoint()
        let exp = a.map { p in
            CGPoint(
                x: s.x * p.x - q.x,
                y: s.y * p.y - q.y
            )
        }
        var res = a
        res.scale(by: s, thenSubtract: q)
        XCTAssertEqual(res, exp)
    }

    func test_performance_scale_by_then_add() {

        let s = randomPoint()
        let q = randomPoint()

        let count = 100_000
        a = randomArray(count: count)

        var start = Date()
        _ = a.map { p in
            CGPoint(
                x: s.x * p.x + q.x,
                y: s.y * p.y + q.y
            )
        }
        var end = Date()
        var timeElapsed = end.timeIntervalSince(start)
        let timePerPoint1 = timeElapsed / Double(count)
        print("scale(by:thenAdd:) timePerPoint (   standard approach): \(timePerPoint1)")

        var res = a
        start = Date()
        res.scale(by: s, thenAdd: q)
        end = Date()
        timeElapsed = end.timeIntervalSince(start)
        let timePerPoint2 = timeElapsed / Double(count)
        print("scale(by:thenAdd:) timePerPoint (accelerated approach): \(timePerPoint2)")
        print("scale(by:thenAdd:) ratio: \(timePerPoint1 / timePerPoint2)")

    }

    func test_performance_scale_by_then_subtract() {

        let s = randomPoint()
        let q = randomPoint()

        let count = 100_000
        a = randomArray(count: count)

        var start = Date()
        _ = a.map { p in
            CGPoint(
                x: s.x * p.x - q.x,
                y: s.y * p.y - q.y
            )
        }
        var end = Date()
        var timeElapsed = end.timeIntervalSince(start)
        let timePerPoint1 = timeElapsed / Double(count)
        print("scale(by:thenSubtract:) timePerPoint (   standard approach): \(timePerPoint1)")

        var res = a
        start = Date()
        res.scale(by: s, thenSubtract: q)
        end = Date()
        timeElapsed = end.timeIntervalSince(start)
        let timePerPoint2 = timeElapsed / Double(count)
        print("scale(by:thenSubtract:) timePerPoint (accelerated approach): \(timePerPoint2)")
        print("scale(by:thenSubtract:) ratio: \(timePerPoint1 / timePerPoint2)")

    }

    func test_random_same_range_neg_count() {
        let count = Int.random(in: -10...0)
        let u = CGFloat.random(in: -2...2)
        let v = CGFloat.random(in: -2...2)
        let a = min(u, v)
        let b = max(u, v)
        let res = [CGPoint].random(count: count, in: a...b)
        XCTAssert(res == [])
    }

    func test_random_same_range_zero_count() {
        let count = 0
        let u = CGFloat.random(in: -2...2)
        let v = CGFloat.random(in: -2...2)
        let a = min(u, v)
        let b = max(u, v)
        let res = [CGPoint].random(count: count, in: a...b)
        XCTAssert(res == [])
    }

    func test_random_same_range() {
        let count = Int.random(in: 1...10)
        let u = CGFloat.random(in: -2...2)
        let v = CGFloat.random(in: -2...2)
        let a = min(u, v)
        let b = max(u, v)
        let res = [CGPoint].random(count: count, in: a...b)
        XCTAssert(res.count == count)
        res.forEach { p in
            XCTAssert(a <= p.x && p.x <= b)
            XCTAssert(a <= p.y && p.y <= b)
        }
    }

    func test_random_separate_ranges_neg_count() {
        let count = Int.random(in: -10...0)
        var u = CGFloat.random(in: -2...2)
        var v = CGFloat.random(in: -2...2)
        let ax = min(u, v)
        let bx = max(u, v)
        u = CGFloat.random(in: -2...2)
        v = CGFloat.random(in: -2...2)
        let ay = min(u, v)
        let by = max(u, v)
        let res = [CGPoint].random(count: count, xRange: ax...bx, yRange: ay...by)
        XCTAssert(res == [])
    }

    func test_random_separate_ranges_zero_count() {
        let count = 0
        var u = CGFloat.random(in: -2...2)
        var v = CGFloat.random(in: -2...2)
        let ax = min(u, v)
        let bx = max(u, v)
        u = CGFloat.random(in: -2...2)
        v = CGFloat.random(in: -2...2)
        let ay = min(u, v)
        let by = max(u, v)
        let res = [CGPoint].random(count: count, xRange: ax...bx, yRange: ay...by)
        XCTAssert(res == [])
    }

    func test_random_separate_ranges() {
        let count = Int.random(in: 1...10)
        var u = CGFloat.random(in: -2...2)
        var v = CGFloat.random(in: -2...2)
        let ax = min(u, v)
        let bx = max(u, v)
        u = CGFloat.random(in: -2...2)
        v = CGFloat.random(in: -2...2)
        let ay = min(u, v)
        let by = max(u, v)
        let res = [CGPoint].random(count: count, xRange: ax...bx, yRange: ay...by)
        XCTAssert(res.count == count)
        res.forEach { p in
            XCTAssert(ax <= p.x && p.x <= bx)
            XCTAssert(ay <= p.y && p.y <= by)
        }
    }

}
