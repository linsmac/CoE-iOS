import UIKit

class IndexViewController: UIViewController {
    
    // MARK: - Outlets for TextFields
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var itineraryTextField: UITextField!
    @IBOutlet weak var transportTextField: UITextField!
    @IBOutlet weak var departureDateTextField: UIDatePicker!
    @IBOutlet weak var departureLocationTextField:UITextField!
    @IBOutlet weak var returnDateTextField: UIDatePicker!
    @IBOutlet weak var returnLocationTextField: UITextField!
    @IBOutlet weak var itineraryPreferences: UITextField!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*        // 添加鍵盤事件監聽
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
         
         // 允許點擊屏幕空白處隱藏鍵盤
         let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
         view.addGestureRecognizer(tapGesture)
         
         
         }
         
         
         // 鍵盤出現時，調整 UIScrollView 的偏移量
         @objc func keyboardWillShow(_ notification: Notification) {
         if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
         let keyboardHeight = keyboardFrame.cgRectValue.height
         let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
         scrollView.contentInset = contentInsets
         scrollView.scrollIndicatorInsets = contentInsets
         }
         }
         
         // 鍵盤隱藏時，還原 UIScrollView 的偏移量
         @objc func keyboardWillHide(_ notification: Notification) {
         UIView.animate(withDuration: 0.3) {
         let contentInsets = UIEdgeInsets.zero
         self.scrollView.contentInset = contentInsets
         self.scrollView.scrollIndicatorInsets = contentInsets
         self.scrollView.setContentOffset(CGPoint.zero, animated: true)
         }
         }
         */
        /*
         // 點擊空白處隱藏鍵盤
         @objc func dismissKeyboard() {
         view.endEditing(true)
         }
         
         
         deinit {
         // 移除通知觀察者
         NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
         NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
         }
         */
    }
        
        // MARK: - Action for the "Explore" button
        @IBAction func exploreButtonTapped(_ sender: UIButton) {
            // 獲取使用者輸入的值
            let itinerary = itineraryTextField.text ?? ""
            let transport = transportTextField.text ?? ""
            
            // 從 UIDatePicker 獲取日期
            let departureDate = departureDateTextField.date
            let returnDate = returnDateTextField.date
            
            let departureLocation = departureLocationTextField.text ?? ""
            let returnLocation = returnLocationTextField.text ?? ""
            
            // 格式化日期顯示
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"  // 符合 ISO 8601 格式
            let departureDateString = formatter.string(from: departureDate)
            let returnDateString = formatter.string(from: returnDate)
            
            // 進行 API 請求
            let parameters: [String: Any] = [
                "trip_theme": itinerary,
                "transportation": transport,
                "departure_location": departureLocation,
                "departure_time": departureDateString,
                "return_location": returnLocation,
                "return_time": returnDateString
            ]
            
            // 發送 POST 請求
            sendPostRequest(with: parameters)
        }
        
        func sendPostRequest(with parameters: [String: Any]) {
            let url = URL(string: "https://fastapi-production-a532.up.railway.app/Trip/")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
                request.httpBody = jsonData
            } catch {
                print("Error converting parameters to JSON:", error)
                return
            }
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error with request:", error)
                    return
                }
                
                guard let data = data else {
                    print("No data received")
                    return
                }
                
                do {
                    // 解析 JSON 回應
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                    print("Response from API: \(jsonResponse)")
                } catch {
                    print("Error parsing response data:", error)
                }
            }
            
            task.resume()
        }
        
        // MARK: - Action for the "Clear" button
        @IBAction func clearButtonTapped(_ sender: UIButton) {
            // 清空所有的輸入框
            itineraryTextField.text = ""
            transportTextField.text = ""
            departureLocationTextField.text = ""
            returnLocationTextField.text = ""
            
            // 重設 UIDatePicker 的日期
            departureDateTextField.setDate(Date(), animated: true)
            returnDateTextField.setDate(Date(), animated: true)
        }
        
    }

