import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let doxDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        print("Dox dir")
        print(doxDir)
        
        let bundleDir = doxDir.deletingLastPathComponent()
        
        print("Bundle dir")
        print(bundleDir)
    }
}
