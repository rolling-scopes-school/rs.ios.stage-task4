import XCTest
@testable import ios_stage_task

class FillWithColorTests: XCTestCase {
    
    var painter: FillWithColor!
    var image = [[Int]]()
    var row = Int()
    var column = Int()
    var newColor = Int()

    override func setUpWithError() throws {
        painter = FillWithColor()
    }

    override func tearDownWithError() throws {
        painter = nil
    }

    func test1() {
        image = [[Int()]]
        row = 0
        column = 0
        newColor = 2
        XCTAssertEqual(painter.fillWithColor(image, row, column, newColor), [[2]])
    }

    func test2() {
        image = [[0,0]]
        row = 0
        column = 1
        newColor = 2
        XCTAssertEqual(painter.fillWithColor(image, row, column, newColor), [[2,2]])
    }

    func test3() {
        image = [[0,1]]
        row = 0
        column = 1
        newColor = 2
        XCTAssertEqual(painter.fillWithColor(image, row, column, newColor), [[0,2]])
    }

    func test4() {
        image = [[0,0,0]]
        row = 0
        column = 2
        newColor = 2
        XCTAssertEqual(painter.fillWithColor(image, row, column, newColor), [[2,2,2]])
    }

    func test5() {
        image = [[0,1,0]]
        row = 0
        column = 1
        newColor = 2
        XCTAssertEqual(painter.fillWithColor(image, row, column, newColor), [[0,2,0]])
    }

    func test6() {
        image = [[1,0,1],[0,1,0],[1,0,1]]
        row = 0
        column = 0
        newColor = 2
        XCTAssertEqual(painter.fillWithColor(image, row, column, newColor), [[2,0,1],[0,1,0],[1,0,1]])

        image = [[0,0,0],[1,1,1],[0,0,0]]
        row = 0
        column = 0
        newColor = 2
        XCTAssertEqual(painter.fillWithColor(image, row, column, newColor), [[2,2,2],[1,1,1],[0,0,0]])
    }
}
