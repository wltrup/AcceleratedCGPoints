import XCTest
@testable import AcceleratedCGPoints

final class CGPoint_ExtensionsTests: XCTestCase {

    var p1 = CGPoint.zero
    var p2 = CGPoint.zero
    var s = CGFloat.zero

    override func setUp() {
        p1 = CGPoint(
            x: CGFloat.random(in: -1...1),
            y: CGFloat.random(in: -1...1)
        )
        p2 = CGPoint(
            x: CGFloat.random(in: -1...1),
            y: CGFloat.random(in: -1...1)
        )
        s = CGFloat.random(in: -1...1)
    }

    func test_plus() {
        let exp = CGPoint(
            x: p1.x + p2.x,
            y: p1.y + p2.y
        )
        let res = p1 + p2
        XCTAssertEqual(res, exp)
    }

    func test_plusEqual() {
        let exp = CGPoint(
            x: p1.x + p2.x,
            y: p1.y + p2.y
        )
        var res = p1
        res += p2
        XCTAssertEqual(res, exp)
    }

    func test_minus() {
        let exp = CGPoint(
            x: p1.x - p2.x,
            y: p1.y - p2.y
        )
        let res = p1 - p2
        XCTAssertEqual(res, exp)
    }

    func test_minusEqual() {
        let exp = CGPoint(
            x: p1.x - p2.x,
            y: p1.y - p2.y
        )
        var res = p1
        res -= p2
        XCTAssertEqual(res, exp)
    }

    func test_scale() {
        let exp = CGPoint(
            x: s * p1.x,
            y: s * p1.y
        )
        var res = p1
        res.scale(by: s)
        XCTAssertEqual(res, exp)
    }

    func test_magnitudeSquared() {
        let exp = (p1.x * p1.x) + (p1.y * p1.y)
        let res = p1.magnitudeSquared
        XCTAssertEqual(res, Double(exp))
    }

    func test_scalar_times_point() {
        let exp = CGPoint(
            x: s * p1.x,
            y: s * p1.y
        )
        let res = s * p1
        XCTAssertEqual(res, exp)
    }

    func test_scalar_timesEqual_point() {
        let exp = CGPoint(
            x: s * p1.x,
            y: s * p1.y
        )
        var res = p1
        res *= s
        XCTAssertEqual(res, exp)
    }

    func test_random_same_range() {
        let u = CGFloat.random(in: -2...2)
        let v = CGFloat.random(in: -2...2)
        let a = min(u, v)
        let b = max(u, v)
        let res = CGPoint.random(in: a...b)
        XCTAssert(a <= res.x && res.x <= b)
        XCTAssert(a <= res.y && res.y <= b)
    }

    func test_random_separate_ranges() {
        var u = CGFloat.random(in: -2...2)
        var v = CGFloat.random(in: -2...2)
        let ax = min(u, v)
        let bx = max(u, v)
        u = CGFloat.random(in: -2...2)
        v = CGFloat.random(in: -2...2)
        let ay = min(u, v)
        let by = max(u, v)
        let res = CGPoint.random(xRange: ax...bx, yRange: ay...by)
        XCTAssert(ax <= res.x && res.x <= bx)
        XCTAssert(ay <= res.y && res.y <= by)
    }

}
