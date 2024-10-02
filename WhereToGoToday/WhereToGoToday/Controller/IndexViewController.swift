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
    
    var apiResponseData: TripResponse? // 保存從 API 回傳的 JSON 資料
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
 
    // MARK: - Action for the "Explore" button
    @IBAction func exploreButtonTapped(_ sender: UIButton) {
        sender.isEnabled = false
        
        let trip_theme = itineraryTextField.text ?? ""
        let transportation = transportTextField.text ?? ""
        let departure_location = departureLocationTextField.text ?? ""
        let return_location = returnLocationTextField.text ?? ""
        let departure_time = formatDate(date: departureDateTextField.date)
        let return_time = formatDate(date: returnDateTextField.date)
        
        print("itinerary:\(trip_theme)")
        print("transport:\(transportation)")
        print("departureDate:\(departure_time)")
        print("returnDate:\(return_time)")
        print("departureLocation:\(departure_location)")
        print("returnLocation:\(return_location)")

        // 呼叫 API
        callAPI(trip_theme: trip_theme, transportation: transportation, departure_time: departure_time, return_time: return_time, departure_location: departure_location, return_location: return_location)
        
        // 在 API 完成後再啟用按鈕
        DispatchQueue.main.async {
            sender.isEnabled = true
        }
    }
    
    // 格式化日期
    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    var isNavigating = false // 新增一個布林變數來標記是否已在導航

    // 呼叫 API
    func callAPI(trip_theme: String, transportation: String, departure_time: String, return_time: String, departure_location: String, return_location: String) {
        let urlString = "https://fastapi-production-a532.up.railway.app/Trip/"
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "trip_theme": trip_theme,
            "transportation": transportation,
            "departure_time": departure_time,
            "return_time": return_time,
            "departure_location": departure_location,
            "return_location": return_location
        ]
        
        print("body:\(body)")
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)

        // 發送 API 請求
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("API request failed: \(error?.localizedDescription ?? "No error description")")
                return
            }

            // 打印 API 回應的內容
            if let responseString = String(data: data, encoding: .utf8) {
                print("API Response: \(responseString)")
            }

            // 解析回應
            do {
                let responseData = try JSONDecoder().decode(TripResponse.self, from: data)
                self.apiResponseData = responseData
                
                // 確保只進行一次 segue
                DispatchQueue.main.async {
                    if !self.isNavigating {
                        self.isNavigating = true
                        self.performSegue(withIdentifier: "showExploreDetail", sender: nil)
                    }
                }
            } catch {
                print("Failed to decode API response: \(error.localizedDescription)")
            }

        }
        
        task.resume()
    }

    // 重置 isNavigating 在下一個視圖控制器消失後
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.isNavigating = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 重置導航狀態，確保每次回到頁面都可以再次導航
        self.isNavigating = false
    }




    // 準備 segue 傳遞資料
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showExploreDetail" {
            if let destinationVC = segue.destination as? ExploreDetailController {
                // 將 API 回傳的資料傳遞到下一頁
                destinationVC.tripInfo = apiResponseData
                print("資料已成功傳送到下一頁")
            }
        }
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
