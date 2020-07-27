import XCTest
@testable import AcceleratedCGPoints

final class Array_AdditiveArithmeticTests: XCTestCase {

    var a1 = [CGPoint.zero]
    var a2 = [CGPoint.zero]

    func makePointsArray(count: Int) -> [CGPoint] {
        (1 ... count).map { _ in
            CGPoint(
                x: CGFloat.random(in: -1...1),
                y: CGFloat.random(in: -1...1)
            )
        }
    }

    override func setUp() {
        let count = 1_000
        a1 = makePointsArray(count: count)
        a2 = makePointsArray(count: count)
    }

    func test_plus() {
        let exp = zip(a1, a2).map(+)
        let res = a1 + a2
        XCTAssertEqual(res, exp)
    }

    func test_plusEqual() {
        let exp = zip(a1, a2).map(+)
        var res = a1
        res += a2
        XCTAssertEqual(res, exp)
    }

    func test_minus() {
        let exp = zip(a1, a2).map(-)
        let res = a1 - a2
        XCTAssertEqual(res, exp)
    }

    func test_minusEqual() {
        let exp = zip(a1, a2).map(-)
        var res = a1
        res -= a2
        XCTAssertEqual(res, exp)
    }

    func test_performance_plus() {

        let count = 100_000
        a1 = makePointsArray(count: count)
        a2 = makePointsArray(count: count)
        let pairs = zip(a1, a2)

        var start = Date()
        _ = pairs.map(+)
        var end = Date()
        var timeElapsed = end.timeIntervalSince(start)
        let timePerPoint1 = timeElapsed / Double(count)
        print("+  timePerPoint (   standard approach): \(timePerPoint1)")

        start = Date()
        _ = a1 + a2
        end = Date()
        timeElapsed = end.timeIntervalSince(start)
        let timePerPoint2 = timeElapsed / Double(count)
        print("+  timePerPoint (accelerated approach): \(timePerPoint2)")
        print("+  ratio: \(timePerPoint1 / timePerPoint2)")

    }

    func test_performance_plusEqual() {

        let count = 100_000
        a1 = makePointsArray(count: count)
        a2 = makePointsArray(count: count)
        let pairs = zip(a1, a2)

        var start = Date()
        pairs.forEach { p1, p2 in
            var p = p1
            p += p2
        }
        var end = Date()
        var timeElapsed = end.timeIntervalSince(start)
        let timePerPoint1 = timeElapsed / Double(count)
        print("+= timePerPoint (   standard approach): \(timePerPoint1)")

        var a = a1
        start = Date()
        a += a2
        end = Date()
        timeElapsed = end.timeIntervalSince(start)
        let timePerPoint2 = timeElapsed / Double(count)
        print("+= timePerPoint (accelerated approach): \(timePerPoint2)")
        print("+= ratio: \(timePerPoint1 / timePerPoint2)")

    }

    func test_performance_minus() {

        let count = 100_000
        a1 = makePointsArray(count: count)
        a2 = makePointsArray(count: count)
        let pairs = zip(a1, a2)

        var start = Date()
        _ = pairs.map(-)
        var end = Date()
        var timeElapsed = end.timeIntervalSince(start)
        let timePerPoint1 = timeElapsed / Double(count)
        print("-  timePerPoint (   standard approach): \(timePerPoint1)")

        start = Date()
        _ = a1 - a2
        end = Date()
        timeElapsed = end.timeIntervalSince(start)
        let timePerPoint2 = timeElapsed / Double(count)
        print("-  timePerPoint (accelerated approach): \(timePerPoint2)")
        print("-  ratio: \(timePerPoint1 / timePerPoint2)")

    }

    func test_performance_minusEqual() {

        let count = 100_000
        a1 = makePointsArray(count: count)
        a2 = makePointsArray(count: count)
        let pairs = zip(a1, a2)

        var start = Date()
        pairs.forEach { p1, p2 in
            var p = p1
            p -= p2
        }
        var end = Date()
        var timeElapsed = end.timeIntervalSince(start)
        let timePerPoint1 = timeElapsed / Double(count)
        print("-= timePerPoint (   standard approach): \(timePerPoint1)")

        var a = a1
        start = Date()
        a -= a2
        end = Date()
        timeElapsed = end.timeIntervalSince(start)
        let timePerPoint2 = timeElapsed / Double(count)
        print("-= timePerPoint (accelerated approach): \(timePerPoint2)")
        print("-= ratio: \(timePerPoint1 / timePerPoint2)")

    }

}
