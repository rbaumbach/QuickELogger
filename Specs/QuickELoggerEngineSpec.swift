import Quick
import Nimble

@testable import QuickELogger

class QuickELoggerEngineSpec: QuickSpec {
    override func spec() {
        describe("QuickELoggerEngine") {
            var subject: QuickELoggerEngine!
            
            var justADate: Date!
                        
            var fakeFileManager: FakeFileManager!
            var fakeJSONEncoder: FakeJSONEncoder!
            var fakeDataUtils: FakeDataUtils!
            var fakeFileUtils: FakeFileUtils!
            var fakeUUID: FakeUUID!
            var fakeJSONDecoder: FakeJSONDecoder<[LogMessage]>!
                        
            beforeEach {
                justADate = Date()

                fakeFileManager = FakeFileManager()
                fakeJSONEncoder = FakeJSONEncoder()
                fakeDataUtils = FakeDataUtils()
                fakeFileUtils = FakeFileUtils()
                fakeUUID = FakeUUID()
                                
                fakeJSONDecoder = FakeJSONDecoder<[LogMessage]>()
                fakeJSONDecoder.stubbedDecodedJSON = [LogMessage(id: "1", timeStamp: justADate, type: .error, message: "bogus!")]
            }
            
            it("is setup properly") {
                subject = QuickELoggerEngine(filename: "ItsLogLog",
                                             directory: .documents,
                                             fileManager: fakeFileManager,
                                             jsonEncoder: fakeJSONEncoder,
                                             jsonDecoder: fakeJSONDecoder,
                                             dataUtils: fakeDataUtils,
                                             fileUtils: fakeFileUtils,
                                             uuid: fakeUUID)
                
                expect(subject.filename).to(equal("ItsLogLog.json"))
                expect(subject.directory).to(equal(.documents))
                expect(fakeJSONEncoder.capturedOutputFormatting).to(equal(.prettyPrinted))
                expect(fakeJSONEncoder.capturedDateEncodingStrategy).to(equal(.iso8601))
                
                // For some reason my <Equtable> extension isn't working in FoundationExtensions.swift
                // expect(fakeJSONDecoder.capturedDateDecodingStrategy).to(equal(.iso8601))
            }
            
            describe("logging a message") {
                beforeEach {
                    subject = QuickELoggerEngine(filename: "ItsLogLog",
                                                 directory: .documents,
                                                 fileManager: fakeFileManager,
                                                 jsonEncoder: fakeJSONEncoder,
                                                 jsonDecoder: fakeJSONDecoder,
                                                 dataUtils: fakeDataUtils,
                                                 fileUtils: fakeFileUtils,
                                                 uuid: fakeUUID)
                }
                
                describe("when a log file doesn't exist on disk") {
                    beforeEach {
                        fakeDataUtils.shouldThrowLoadDataException = true
                                                                        
                        subject.log(message: "UNO", type: .info, currentDate: justADate)
                    }
                    
                    it("is logged in a new JSON file to disk") {
                        let expectedLogMessages = [LogMessage(id: "uuid-amigos-012345", timeStamp: justADate, type: .info, message: "UNO")]
                        
                        expect(fakeJSONEncoder.capturedEncodeValue as? [LogMessage]).to(equal(expectedLogMessages))
                        
                        expect(fakeDataUtils.capturedWriteData).to(equal(fakeJSONEncoder.stubbedEncodeData))
                        expect(fakeDataUtils.capturedWriteURL).to(equal(URL(string: "file:///fake-directory/fakefilename.json")))
                        
                        expect(fakeFileUtils.capturedBuildFullFileURLDirectory).to(equal(.documents))
                        expect(fakeFileUtils.capturedBuildFullFileURLFilename).to(equal("ItsLogLog.json"))
                    }
                }
                
                describe("when a log file exists on disk") {
                    describe("when the log file on disk cannot be properly decoded") {
                        beforeEach {
                            fakeJSONDecoder.shouldThrowDecodeException = true
                            
                            subject.log(message: "DOS", type: .debug, currentDate: justADate)
                        }
                        
                        it("is logged in a new JSON file to disk (the old one gets overwritten)") {
                            let expectedLogMessages = [LogMessage(id: "uuid-amigos-012345", timeStamp: justADate, type: .debug, message: "DOS")]
                            
                            expect(fakeJSONEncoder.capturedEncodeValue as? [LogMessage]).to(equal(expectedLogMessages))
                                                       
                            expect(fakeDataUtils.capturedWriteData).to(equal(fakeJSONEncoder.stubbedEncodeData))
                            expect(fakeDataUtils.capturedWriteURL).to(equal(URL(string: "file:///fake-directory/fakefilename.json")))
                            
                            expect(fakeFileUtils.capturedBuildFullFileURLDirectory).to(equal(.documents))
                            expect(fakeFileUtils.capturedBuildFullFileURLFilename).to(equal("ItsLogLog.json"))
                        }
                    }
                    
                    describe("when the log file on disk can be properly decoded") {
                        beforeEach {
                            subject.log(message: "TRES", type: .error, currentDate: justADate)
                        }
                        
                        it("is logged to to disk using the previous log messages loaded from disk") {
                            let expectedLogMessages = [LogMessage(id: "1", timeStamp: justADate, type: .error, message: "bogus!"),
                                                       LogMessage(id: "uuid-amigos-012345", timeStamp: justADate, type: .error, message: "TRES")]
                            
                            expect(fakeJSONDecoder.capturedDecodeTypeAsString).to(equal("Array<LogMessage>.Type"))
                            expect(fakeJSONDecoder.capturedDecodeData).to(equal(fakeDataUtils.stubbedLoadData))
                            
                            expect(fakeJSONEncoder.capturedEncodeValue as? [LogMessage]).to(equal(expectedLogMessages))
                                                       
                            expect(fakeDataUtils.capturedWriteData).to(equal(fakeJSONEncoder.stubbedEncodeData))
                            expect(fakeDataUtils.capturedWriteURL).to(equal(URL(string: "file:///fake-directory/fakefilename.json")))
                            
                            expect(fakeFileUtils.capturedBuildFullFileURLDirectory).to(equal(.documents))
                            expect(fakeFileUtils.capturedBuildFullFileURLFilename).to(equal("ItsLogLog.json"))
                        }
                    }
                }
            }
        }
    }
}
