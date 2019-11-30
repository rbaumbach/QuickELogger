import Quick
import Nimble
import Capsule
import Utensils
@testable import QuickELogger

class QuickELoggerEngineSpec: QuickSpec {
    override func spec() {
        describe("QuickELoggerEngine") {
            var subject: QuickELoggerEngine!
            
            var justADate: Date!
            var fakeFileManager: FakeFileManager!
            var directory: Directory!
            
            var fakeTrunk: FakeTrunk!
            var fakeUUID: FakeUUID!
                        
            beforeEach {
                justADate = Date()
                fakeFileManager = FakeFileManager()
                directory = Directory(fileManager: fakeFileManager)

                fakeTrunk = FakeTrunk()
                fakeTrunk.stubbedLoadData = [LogMessage(id: "1", timeStamp: justADate, type: .error, message: "bogus!")]
                
                fakeUUID = FakeUUID()
            }
            
            it("is setup properly") {
                subject = QuickELoggerEngine(filename: "ItsLogLog",
                                             directory: directory,
                                             trunk: fakeTrunk,
                                             uuid: fakeUUID)
                
                expect(subject.filename).to(equal("ItsLogLog"))
                expect(subject.directory).to(equal(Directory()))
                expect(fakeTrunk.capturedOutputFormat).to(equal(.pretty))
                expect(fakeTrunk.capturedDateFormat).to(equal(.iso8601))
            }
            
            describe("logging a message") {
                beforeEach {
                    subject = QuickELoggerEngine(filename: "ItsLogLog",
                                                 directory: directory,
                                                 trunk: fakeTrunk,
                                                 uuid: fakeUUID)
                    
                    subject.log(message: "UNO", type: .info, currentDate: justADate)
                }
                
                it("retrieves the log messages from disk") {
                    expect(fakeTrunk.capturedLoadDirectory).to(equal(directory))
                    expect(fakeTrunk.capturedLoadFilename).to(equal("ItsLogLog"))
                }
                
                it("saves the updated log messages to disk") {
                    let actualLogMessages = fakeTrunk.capturedSaveData as! [LogMessage]
                    
                    let expectedLogMessages = [LogMessage(id: "1", timeStamp: justADate, type: .error, message: "bogus!"),
                                               LogMessage(id: "uuid-amigos-012345", timeStamp: justADate, type: .info, message: "UNO")]

                    expect(actualLogMessages).to(equal(expectedLogMessages))
                    expect(fakeTrunk.capturedSaveDirectory).to(equal(directory))
                    expect(fakeTrunk.capturedSaveFilename).to(equal("ItsLogLog"))
                }
            }
        }
    }
}
