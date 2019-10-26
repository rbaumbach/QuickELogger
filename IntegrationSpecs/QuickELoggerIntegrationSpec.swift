import Quick
import Nimble

@testable import QuickELogger

class QuickELoggerIntegrationSpec: QuickSpec {
    override func spec() {
        describe("QuickELogger") {
            var subject: QuickELogger!
                        
            beforeEach {
                subject = QuickELogger()
            }
            
            it("exists") {
                expect(subject).toNot(beNil())
            }
        }
    }
}
