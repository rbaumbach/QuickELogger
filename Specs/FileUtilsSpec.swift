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
                    
                }
            }
        }
    }
}
