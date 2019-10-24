import Quick
import Nimble

class TestSpec: QuickSpec {
  override func spec() {
    describe("truthy") {
      it("is true") {
        expect(true).to(beTruthy())
      }
    }
  }
}
