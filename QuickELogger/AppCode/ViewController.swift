import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Dox dir")
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!)
    }
}
