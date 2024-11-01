import UIKit
import MessageUI

class FeedbackViewController: UIViewController, MFMailComposeViewControllerDelegate, UITextViewDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var feedbackTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "意見回饋"
        let backButton = UIBarButtonItem()
        backButton.title = "帳戶"
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        feedbackTextView.backgroundColor = .white
        feedbackTextView.overrideUserInterfaceStyle = .light
        
        setupFeedbackTextView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func setupFeedbackTextView() {
        feedbackTextView.layer.cornerRadius = 8
        feedbackTextView.layer.borderColor = UIColor.lightGray.cgColor
        feedbackTextView.layer.borderWidth = 1.0
        feedbackTextView.clipsToBounds = true
        feedbackTextView.delegate = self
        feedbackTextView.text = "請輸入您的回饋內容"
        feedbackTextView.textColor = .lightGray
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "請輸入您的回饋內容" {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "請輸入您的回饋內容"
            textView.textColor = .lightGray
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: email)
    }
    
    @IBAction func sendFeedback(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty,
              let feedback = feedbackTextView.text, !feedback.isEmpty, feedback != "請輸入您的回饋內容" else {
            showErrorAlert(message: "請填寫完整的 Email 和回饋內容")
            return
        }
        
        guard isValidEmail(email) else {
            showErrorAlert(message: "請輸入正確的 Email 格式")
            return
        }
        
        sendFeedbackEmail(email: email, feedback: feedback)
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "錯誤", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確定", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func sendFeedbackEmail(email: String, feedback: String) {
        guard MFMailComposeViewController.canSendMail() else {
            let alert = UIAlertController(title: "無法發送郵件", message: "請先在設定中配置郵件帳戶。", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "確定", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients(["ella91714@gmail.com"])
        mailComposeVC.setSubject("使用者意見回饋")
        mailComposeVC.setMessageBody("寄送者 Email: \(email)\n\n回饋內容:\n\(feedback)", isHTML: false)
        
        present(mailComposeVC, animated: true, completion: nil)
    }

    @objc func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true) {
            if result == .sent {
                self.emailTextField.text = ""
                self.feedbackTextView.text = "請輸入您的回饋內容"
                self.feedbackTextView.textColor = .lightGray
                
                let successAlert = UIAlertController(title: "發送完成", message: "您的意見回饋已成功寄出。", preferredStyle: .alert)
                successAlert.addAction(UIAlertAction(title: "確定", style: .default, handler: nil))
                self.present(successAlert, animated: true, completion: nil)
            }
        }
    }
}
