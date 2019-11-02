import Quick
import Nimble

@testable import QuickELogger

class FileUtilsSpec: QuickSpec {
    override func spec() {
        describe("FileUtils") {
            var subject: FileUtils!
            
            var fakeFileManager: FakeFileManager!
            
            beforeEach {
                fakeFileManager = FakeFileManager()
                
                subject = FileUtils(fileManager: fakeFileManager)
            }
            
            it("is setup properly") {
                expect(subject).toNot(beNil())
            }
            
            describe("when building file URL from directory and filename") {
                var url: URL!
                
                describe("when building /Documents directory URL") {
                    beforeEach {
                        url = subject.buildFullFileURL(directory: .documents, filename: "Goofus.json")
                    }
                    
                    it("builds the correct URL") {
                        expect(url).to(equal(URL(string: "file:///fake-directory/extra-fake-directory/Goofus.json")!))
                    }
                }
                
                describe("when building /tmp directory URL") {
                    beforeEach {
                        url = subject.buildFullFileURL(directory: .temp, filename: "Goofus.json")
                    }
                    
                    it("builds the correct URL") {
                        expect(url).to(equal(URL(string: "file:///fake-temp-directory/Goofus.json")!))
                    }
                }
                
                describe("when building /Library directory URL") {
                    beforeEach {
                        url = subject.buildFullFileURL(directory: .library, filename: "Goofus.json")
                    }
                    
                    it("builds the correct URL") {
                        expect(url).to(equal(URL(string: "file:///fake-directory/extra-fake-directory/Goofus.json")!))
                    }
                }
                
                describe("when building /Library/Caches directory URL") {
                    beforeEach {
                        url = subject.buildFullFileURL(directory: .caches, filename: "Goofus.json")
                    }
                    
                    it("builds the correct URL") {
                        expect(url).to(equal(URL(string: "file:///fake-directory/extra-fake-directory/Goofus.json")!))
                    }
                }
                
                describe("when building '/Library/Application Support' directory URL") {
                    // Note: The "Library/Application Support" directory doesn't exist by default when an application is loaded.
                    // This is why we need code to create the directory to dump our logs in if it doesn't exist.
                    
                    // Additional note: The apple docs say that the directory is "Application support" with a lowercase "support".
                    // However, the FileManager API returns "Application Support" with an uppercase "Support".
                    
                    describe("when the application support directory doesn't exist") {
                        beforeEach {
                            url = subject.buildFullFileURL(directory: .applicationSupport, filename: "Goofus.json")
                        }
                        
                        it("creates the application support directory") {
                            expect(fakeFileManager.capturedFileExistsPath).to(equal("/fake-directory/extra-fake-directory"))
                            expect(fakeFileManager.capturedCreateDirectoryURL).to(equal(URL(string: "file:///fake-directory/extra-fake-directory")))
                            expect(fakeFileManager.capturedCreateDirectoryCreateIntermediates).to(beFalsy())
                            expect(fakeFileManager.capturedCreateDirectoryAttributes).to(beNil())
                        }
                        
                        it("builds the correct URL") {
                            expect(fakeFileManager.capturedFileExistsPath).to(equal("/fake-directory/extra-fake-directory"))
                            expect(fakeFileManager.capturedCreateDirectoryURL).to(equal(URL(string: "file:///fake-directory/extra-fake-directory")!))
                            expect(fakeFileManager.capturedCreateDirectoryCreateIntermediates).to(beFalsy())
                            expect(fakeFileManager.capturedCreateDirectoryAttributes).to(beNil())
                            
                            expect(url).to(equal(URL(string: "file:///fake-directory/extra-fake-directory/Goofus.json")!))
                        }
                    }
                    
                    describe("when the application support directory exists") {
                        beforeEach {
                            fakeFileManager.stubbedFileExistsPath = true
                            
                            url = subject.buildFullFileURL(directory: .applicationSupport, filename: "Goofus.json")
                        }
                        
                        it("builds the correct URL") {
                            expect(url).to(equal(URL(string: "file:///fake-directory/extra-fake-directory/Goofus.json")!))
                        }
                        
                        it("can accept log saves") {
                            expect(fakeFileManager.capturedFileExistsPath).to(equal("/fake-directory/extra-fake-directory"))
                            
                            expect(url).to(equal(URL(string: "file:///fake-directory/extra-fake-directory/Goofus.json")!))
                        }
                    }
                }
            }
        }
    }
}
