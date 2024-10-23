import UIKit

class UserNameController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserName()
    }

    @IBAction func saveNameButtonTapped(_ sender: UIButton) {
        guard let name = nameTextField.text, !name.isEmpty else {
            displayLabel.text = "請輸入您的稱呼"
            return
        }
        saveUserName(name: name)
    }

    private func loadUserName() {
        if let savedName = UserDefaults.standard.string(forKey: "userName") {
            displayLabel.text = "Hello, \(savedName)!"
            nameTextField.isHidden = true
            saveButton.isHidden = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.navigateToTabBarController()
            }
        } else {
            displayLabel.text = "請問如何稱呼您？"
        }
    }

    private func saveUserName(name: String) {
        UserDefaults.standard.set(name, forKey: "userName")
        displayLabel.text = "Hello, \(name)!"
        nameTextField.isHidden = true
        saveButton.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.navigateToTabBarController()
        }
    }

    private func navigateToTabBarController() {
        performSegue(withIdentifier: "showTabBarController", sender: self)
    }
}
