import XCTest
import Log
@testable import ColorConsoleLogAppender

class ColorConsoleLogAppenderTests: XCTestCase {

    func testReality() {
        XCTAssert(2 + 2 == 4, "Something is severely wrong here.")
    }
    
    func testAppender() {
        let logAppender = ConsoleLogAppender()
        let logger = Logger(name: "testLogger", appender:logAppender)
        struct TestError: Error { let description: String }
        logger.log("Stuff failed pretty badly", error: TestError(description: "Everything failed badly"))
        // [1465345612][/Users/dan/Developer/projects/Zewo/Development/Log/Tests/Log/LogTests.swift:testStandardOutputAppender():12:19]: Stuff failed pretty badly: (TestError #1)(description: "Everything failed badly")
    }

}
extension ColorConsoleLogAppenderTests {
	static var allTests : [(String, (ColorConsoleLogAppenderTests) -> () throws -> Void)] {
		return [
            ("testReality", testReality),
			("testAppender", testAppender),
		]
	}
}
