import UIKit

class UserNameController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 嘗試從 UserDefaults 中讀取已儲存的使用者名稱
        if let savedName = UserDefaults.standard.string(forKey: "userName") {
            displayLabel.text = "Hello, \(savedName)!"
            nameTextField.isHidden = true
            saveButton.isHidden = true
            // 一秒後自動跳轉到 Tab Bar Controller
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.navigateToTabBarController()
            }
        } else {
            displayLabel.text = "請問如何稱呼您？"
        }
    }
    
    // MARK: - Actions
    @IBAction func saveNameButtonTapped(_ sender: UIButton) {
        // 取得使用者輸入的名稱
        guard let name = nameTextField.text, !name.isEmpty else {
            displayLabel.text = "請輸入您的稱呼"
            return
        }
        
        // 使用 UserDefaults 儲存名稱
        UserDefaults.standard.set(name, forKey: "userName")
        
        // 顯示名稱並隱藏輸入框與按鈕
        displayLabel.text = "Hello, \(name)!"
        nameTextField.isHidden = true
        saveButton.isHidden = true
        
        // 一秒後自動跳轉到 Tab Bar Controller
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.navigateToTabBarController()
        }
    }
    
    // MARK: - Helper Method
    func navigateToTabBarController() {
        // 使用 segue 跳轉到 Tab Bar Controller
        performSegue(withIdentifier: "showTabBarController", sender: self)
    }
}
