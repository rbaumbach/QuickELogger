import XCTest

@testable import QuickELogger

class PerformanceTests: XCTestCase {
    var logger: QuickELogger!
    
    override func setUp() {
        logger = QuickELogger()
    }

    override func tearDown() {
        print("Deleting test file")
        
        let fileManager = FileManager.default
        
        let documentsDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        try! FileManager.default.removeItem(atPath: documentsDir.path + "/QuickELogger.json")
    }

    func testPerformanceExample() {
        measure {
            (0...10).forEach { number in
                let message = "This is log message \(number), this will be used to verify that we can see how the performance and the file size is effected.  This seems like a decently long message that will be a good experiment."

                logger.log(message: message, type: .verbose)
            }
        }
    }
}

/*

 Test Results - As of version 0.1.3
 
 10     logs -> Executed 1 test, with 0 failures (0 unexpected) in 1.137 (1.140) seconds
 50     logs -> Executed 1 test, with 0 failures (0 unexpected) in 16.448 (16.451) seconds
 100    logs -> Executed 1 test, with 0 failures (0 unexpected) in 65.910 (65.913) seconds
 1_0000 logs -> Executed 1 test, with 0 failures (0 unexpected) in 5959.687 (5959.690) seconds

*/
