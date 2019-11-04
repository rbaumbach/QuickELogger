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

    func testQuickELoggerPerformance() {
        measure {
            (0...10).forEach { number in
                let message = "This is log message \(number), this will be used to verify that we can see how the performance and the file size is effected.  This seems like a decently long message that will be a good experiment."

                logger.log(message: message, type: .verbose)
            }
        }
    }
    
    func testQuickELoggerMemoryConsumption() {
        measure {
            var logMessages: [LogMessage] = []
                        
            (0...10_000).forEach { number in
                let message = "This is log message \(number), this will be used to verify that we can see how the performance and the file size is effected.  This seems like a decently long message that will be a good experiment."

                let logMessage = LogMessage(id: "\(number)", timeStamp: Date(), type: .info, message: message)
                
                logMessages.append(logMessage)
            }
            
            print("Number of log messages: \(logMessages.count)")
        }
    }
    
    func testQuickELoggerAsStringMemoryConsumption() {
        measure {
            let testBundle = Bundle(for: type(of: self))
            
            guard let fileURL = testBundle.url(forResource: "QuickELogger-3004-messages", withExtension: "json") else {
                return
            }
            
            let stringy = try! String(contentsOf: fileURL, encoding: .utf8)
            
            print("Length of file as string: \(stringy.count)")
        }
    }
}

/*
 
 - testQuickELoggerPerformance()

 Test Results - As of version 0.1.3
 
 10     logs -> Executed 1 test, with 0 failures (0 unexpected) in 1.137 (1.140) seconds
 50     logs -> Executed 1 test, with 0 failures (0 unexpected) in 16.448 (16.451) seconds
 100    logs -> Executed 1 test, with 0 failures (0 unexpected) in 65.910 (65.913) seconds
 1_0000 logs -> Executed 1 test, with 0 failures (0 unexpected) in 5959.687 (5959.690) seconds
 
 - testQuickELoggerMemoryConsumption()
 
 Memory Results - As of version 0.1.3, and Xcode 11.1 with iPhone 11 Pro Simulator
                - Using [LogMessages] data structure
 
 1         log message  -> Sim memory 56.1  MB
 1_000     log messages -> Sim memory 56.6  MB
 10_000    log messages -> Sim memory 58.1  MB <- This looks like a good place to cut off log files
 50_000    log messages -> Sim memory 70.5  MB
 100_000   log messages -> Sim memory 85.0  MB
 1_000_000 log messages -> Sim memory 352.7 MB
 
 - testQuickELoggerAsStringMemoryConsumption()
 
 Memory Results - As of version 0.1.3, and Xcode 11.1 with iPhone 11 Pro Simulator
                - Loading .json file into string variable
 
 0     log message string  -> Sim memory 56.0 MB
 10    log messages string -> Sim memory 56.1 MB
 3_000 log messages string -> Sim memory 57.1 MB
 
*/
