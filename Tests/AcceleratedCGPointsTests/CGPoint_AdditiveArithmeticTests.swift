import XCTest
@testable import AcceleratedCGPoints

final class CGPoint_AdditiveArithmeticTests: XCTestCase {

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
        XCTAssertEqual(res, exp)
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

}
