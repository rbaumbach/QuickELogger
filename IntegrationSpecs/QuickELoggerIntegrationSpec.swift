import Quick
import Nimble

@testable import QuickELogger

class QuickELoggerIntegrationSpec: QuickSpec {
    override func spec() {
        describe("QuickELogger") {
            var subject: QuickELogger!
            
            // Mas cleanup...
            
            beforeSuite {                
                deleteTestArtifacts()
            }
            
            afterEach {
                deleteTestArtifacts()
            }
            
            afterSuite {
                deleteTestArtifacts()
            }
            
            describe("when using the default filename for the log file") {
                beforeEach {
                    subject = QuickELogger()
                }
                
                describe("when logging a message") {
                    describe("when a log file doesn't exist on disk") {
                        beforeEach {
                            subject.log(message: "Goofus", type: .error)
                        }
                        
                        it("is logged in a new JSON file to disk") {
                            let logMessages = getLogMessages()
                            
                            expect(logMessages.count).to(equal(1))
                            
                            let logMessage = logMessages.first!
                            
                            expect(logMessage.id).toNot(beNil())
                            expect(logMessage.timeStamp).toNot(beNil())
                            
                            expect(logMessage.type).to(equal(.error))
                            expect(logMessage.message).to(equal("Goofus"))
                        }
                    }
                    
                    describe("when a log file already exists on disk") {
                        beforeEach {
                            subject.log(message: "Goofus", type: .error)
                            subject.log(message: "Gallant", type: .info)
                        }
                        
                        it("is logged with the previous JSON data to disk") {
                            let logMessages = getLogMessages()
                            
                            expect(logMessages.count).to(equal(2))
                            
                            let previousLogMessage = logMessages[0]
                            
                            expect(previousLogMessage.id).toNot(beNil())
                            expect(previousLogMessage.timeStamp).toNot(beNil())
                            
                            expect(previousLogMessage.type).to(equal(.error))
                            expect(previousLogMessage.message).to(equal("Goofus"))
                            
                            let newLogMessage = logMessages[1]
                            
                            expect(newLogMessage.id).toNot(beNil())
                            expect(newLogMessage.timeStamp).toNot(beNil())
                            
                            expect(newLogMessage.type).to(equal(.info))
                            expect(newLogMessage.message).to(equal("Gallant"))
                        }
                    }
                }
            }
            
            describe("when using a user specified filename for the log file") {
                beforeEach {
                    subject = QuickELogger(filename: "mas-tacos")
                }
                
                describe("when logging a message") {
                    describe("when a log file doesn't exist on disk") {
                        beforeEach {
                            subject.log(message: "Goofus", type: .error)
                        }
                        
                        it("is logged in a new JSON file to disk") {
                            let logMessages = getLogMessages(filename: "mas-tacos")
                            
                            expect(logMessages.count).to(equal(1))
                            
                            let logMessage = logMessages.first!
                            
                            expect(logMessage.id).toNot(beNil())
                            expect(logMessage.timeStamp).toNot(beNil())
                            
                            expect(logMessage.type).to(equal(.error))
                            expect(logMessage.message).to(equal("Goofus"))
                        }
                    }
                    
                    describe("when a log file already exists on disk") {
                        beforeEach {
                            subject.log(message: "Goofus", type: .error)
                            subject.log(message: "Gallant", type: .info)
                        }

                        it("is logged with the previous JSON data to disk") {
                            let logMessages = getLogMessages(filename: "mas-tacos")
                            
                            expect(logMessages.count).to(equal(2))
                            
                            let previousLogMessage = logMessages[0]
                            
                            expect(previousLogMessage.id).toNot(beNil())
                            expect(previousLogMessage.timeStamp).toNot(beNil())
                            
                            expect(previousLogMessage.type).to(equal(.error))
                            expect(previousLogMessage.message).to(equal("Goofus"))
                            
                            let newLogMessage = logMessages[1]
                            
                            expect(newLogMessage.id).toNot(beNil())
                            expect(newLogMessage.timeStamp).toNot(beNil())
                            
                            expect(newLogMessage.type).to(equal(.info))
                            expect(newLogMessage.message).to(equal("Gallant"))
                        }
                    }
                }
            }
            
            describe("writing to other directories besides the root Documents directory") {
                describe("Documents/somethingElse/dude/") {
                    beforeEach {
                        subject = QuickELogger(directory: .documents(path: "somethingElse/dude/"))
                        
                        subject.log(message: "Dox", type: .info)
                    }
                    
                    it("writes the log file to the /Documents/somethingElse/dude/ directory") {
                        let logMessages = getLogMessages(directory: .documents(path: "somethingElse/dude/"))
                        
                        expect(logMessages.count).to(equal(1))
                        
                        let logMessage = logMessages.first!
                        
                        expect(logMessage.id).toNot(beNil())
                        expect(logMessage.timeStamp).toNot(beNil())
                        
                        expect(logMessage.type).to(equal(.info))
                        expect(logMessage.message).to(equal("Dox"))
                    }
                }
                
                describe("tmp") {
                    describe("when an additional path is given") {
                        beforeEach {
                            subject = QuickELogger(directory: .temp(path: "extra-temp/folder"))
                            
                            subject.log(message: "This is temporary and will get deleted frequently", type: .info)
                        }
                        
                        it("writes the log file in the additional path directory") {
                            let logMessages = getLogMessages(directory: .temp(path: "extra-temp/folder"))
                            
                            expect(logMessages.count).to(equal(1))
                            
                            let logMessage = logMessages.first!
                            
                            expect(logMessage.id).toNot(beNil())
                            expect(logMessage.timeStamp).toNot(beNil())
                            
                            expect(logMessage.type).to(equal(.info))
                            expect(logMessage.message).to(equal("This is temporary and will get deleted frequently"))
                        }
                    }
                    
                    describe("when NO additional path is given") {
                        beforeEach {
                            subject = QuickELogger(directory: .temp())
                            
                            subject.log(message: "This is temporary and will get deleted frequently", type: .info)
                        }
                        
                        it("writes the log file to the temp directory") {
                            let logMessages = getLogMessages(directory: .temp())
                            
                            expect(logMessages.count).to(equal(1))
                            
                            let logMessage = logMessages.first!
                            
                            expect(logMessage.id).toNot(beNil())
                            expect(logMessage.timeStamp).toNot(beNil())
                            
                            expect(logMessage.type).to(equal(.info))
                            expect(logMessage.message).to(equal("This is temporary and will get deleted frequently"))
                        }
                    }
                }
                
                describe("Library") {
                    describe("when an additional path is given") {
                        beforeEach {
                            subject = QuickELogger(directory: .library(path: "extra-library/folder"))
                            
                            subject.log(message: "This is the top-level directory for any files that are not user data files", type: .info)
                        }
                        
                        it("writes the log file in the additional path directory") {
                            let logMessages = getLogMessages(directory: .library(path: "extra-library/folder"))
                            
                            expect(logMessages.count).to(equal(1))
                            
                            let logMessage = logMessages.first!
                            
                            expect(logMessage.id).toNot(beNil())
                            expect(logMessage.timeStamp).toNot(beNil())
                            
                            expect(logMessage.type).to(equal(.info))
                            expect(logMessage.message).to(equal("This is the top-level directory for any files that are not user data files"))
                        }
                    }
                    
                    describe("when NO additional path is given") {
                        beforeEach {
                            subject = QuickELogger(directory: .library())
                            
                            subject.log(message: "This is the top-level directory for any files that are not user data files", type: .info)
                        }
                        
                        it("writes the log file to the library directory") {
                            let logMessages = getLogMessages(directory: .library())
                            
                            expect(logMessages.count).to(equal(1))
                            
                            let logMessage = logMessages.first!
                            
                            expect(logMessage.id).toNot(beNil())
                            expect(logMessage.timeStamp).toNot(beNil())
                            
                            expect(logMessage.type).to(equal(.info))
                            expect(logMessage.message).to(equal("This is the top-level directory for any files that are not user data files"))
                        }
                    }
                }
                
                describe("Caches") {
                    describe("when an additional path is given") {
                        beforeEach {
                            subject = QuickELogger(directory: .caches(path: "extra-caches/folder"))
                            
                            subject.log(message: "This can be deleted unexpectedly", type: .info)
                        }
                        
                        it("writes the log file in the additional path directory") {
                            let logMessages = getLogMessages(directory: .caches(path: "extra-caches/folder"))
                            
                            expect(logMessages.count).to(equal(1))
                            
                            let logMessage = logMessages.first!
                            
                            expect(logMessage.id).toNot(beNil())
                            expect(logMessage.timeStamp).toNot(beNil())
                            
                            expect(logMessage.type).to(equal(.info))
                            expect(logMessage.message).to(equal("This can be deleted unexpectedly"))
                        }
                    }
                    
                    describe("when NO additional path is given") {
                        beforeEach {
                            subject = QuickELogger(directory: .caches())
                            
                            subject.log(message: "This can be deleted unexpectedly", type: .info)
                        }
                        
                        it("writes the log file to the caches directory") {
                            let logMessages = getLogMessages(directory: .caches())
                            
                            expect(logMessages.count).to(equal(1))
                            
                            let logMessage = logMessages.first!
                            
                            expect(logMessage.id).toNot(beNil())
                            expect(logMessage.timeStamp).toNot(beNil())
                            
                            expect(logMessage.type).to(equal(.info))
                            expect(logMessage.message).to(equal("This can be deleted unexpectedly"))
                        }
                    }
                }
                
                describe("Application Support") {
                    describe("when an additional path is given") {
                        beforeEach {
                            subject = QuickELogger(directory: .applicationSupport(path: "extra-application-support/folder"))
                            
                            subject.log(message: "This is where you should add app related data that is to be hidden from the user", type: .info)
                        }
                        
                        it("writes the log file in the additional path directory") {
                            let logMessages = getLogMessages(directory: .applicationSupport(path: "extra-application-support/folder"))
                            
                            expect(logMessages.count).to(equal(1))
                            
                            let logMessage = logMessages.first!
                            
                            expect(logMessage.id).toNot(beNil())
                            expect(logMessage.timeStamp).toNot(beNil())
                            
                            expect(logMessage.type).to(equal(.info))
                            expect(logMessage.message).to(equal("This is where you should add app related data that is to be hidden from the user"))
                        }
                    }

                    describe("when NO additional path is given") {
                        beforeEach {
                            subject = QuickELogger(directory: .applicationSupport())

                            subject.log(message: "This is where you should add app related data that is to be hidden from the user", type: .info)
                        }

                        it("writes the log file to the application support directory") {
                            let logMessages = getLogMessages(directory: .applicationSupport())

                            expect(logMessages.count).to(equal(1))

                            let logMessage = logMessages.first!

                            expect(logMessage.id).toNot(beNil())
                            expect(logMessage.timeStamp).toNot(beNil())

                            expect(logMessage.type).to(equal(.info))
                            expect(logMessage.message).to(equal("This is where you should add app related data that is to be hidden from the user"))
                        }
                    }
                }
                
                // Note: Make sure your URL is good, or else I will crash!
                
                describe("custom user specified path") {
                    var customURL: URL!
                    
                    beforeEach {
                        customURL = documentsDirectory()
                        
                        subject = QuickELogger(directory: .custom(url: customURL))
                        
                        subject.log(message: "I will crash if the custom url isn't good!!!!", type: .info)
                    }

                    it("writes the log file to the custom user specified directory") {
                        let logMessages = getLogMessages(directory: .custom(url: customURL))
                        
                        expect(logMessages.count).to(equal(1))
                        
                        let logMessage = logMessages.first!
                        
                        expect(logMessage.id).toNot(beNil())
                        expect(logMessage.timeStamp).toNot(beNil())
                        
                        expect(logMessage.type).to(equal(.info))
                        expect(logMessage.message).to(equal("I will crash if the custom url isn't good!!!!"))
                    }
                }
            }
        }
    }
}
