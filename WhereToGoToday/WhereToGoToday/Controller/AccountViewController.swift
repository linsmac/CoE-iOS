import UIKit

class AccountViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupProfileImageView()
        loadNickname()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - Setup Profile Image
    private func setupProfileImageView() {
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
        
        // 載入圖片
        if let imageData = UserDefaults.standard.data(forKey: "profileImage") {
            profileImageView.image = UIImage(data: imageData)
        } else {
            profileImageView.image = UIImage(named: "defaultProfileImage") // 使用預設圖片
        }
    }
    
    // MARK: - Load and Display Nickname
    private func loadNickname() {
        let nickname = UserDefaults.standard.string(forKey: "userName") ?? "使用者"
        nicknameLabel.text = "嗨～\(nickname)"
    }
    
    // MARK: - Edit Nickname
    @IBAction func editNicknameButtonTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "更改暱稱", message: "請輸入新的暱稱", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "新的暱稱"
        }
        
        let saveAction = UIAlertAction(title: "儲存", style: .default) { [weak self] _ in
            if let newNickname = alertController.textFields?.first?.text, !newNickname.isEmpty {
                UserDefaults.standard.set(newNickname, forKey: "userName")
                self?.nicknameLabel.text = "嗨～\(newNickname)"
            }
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - TableView Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 // 目前只有一個選項：意見回饋
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedbackCell", for: indexPath)
        
        // 設置 Cell 的圖示和文字
        cell.imageView?.image = UIImage(systemName: "pencil.and.outline") // 使用 SF Symbol
        cell.textLabel?.text = "意見回饋"
        cell.accessoryType = .disclosureIndicator // 右邊顯示箭頭
        
        return cell
    }
    
    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 { // 意見回饋 Cell
            performSegue(withIdentifier: "showFeedbackPage", sender: nil)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFeedbackPage" {
            // 在這裡可以傳遞資料到意見回饋頁面
            // 例如: let feedbackVC = segue.destination as? FeedbackViewController
        }
    }
}
