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
    var isNavigating = false
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserName()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isNavigating = false
    }
    
    // 重置 isNavigating 在下一個視圖控制器消失後
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.isNavigating = false
    }
    
    // MARK: - Private Methods
    private func loadUserName() {
        if let savedName = UserDefaults.standard.string(forKey: "userName") {
            print("目前儲存的使用者名稱是: \(savedName)")
            //            UserDefaults.standard.removeObject(forKey: "userName")
            //            print("使用者名稱已刪除")
        } else {
            print("尚未儲存使用者名稱")
        }
    }
 
    // MARK: - Action for the "Explore" button
    @IBAction func exploreButtonTapped(_ sender: UIButton) {
        sender.isEnabled = false
        fetchTripData()
        DispatchQueue.main.async {
            sender.isEnabled = true
        }
    }
    
    // MARK: - Action for the "Clear" button
    @IBAction func clearButtonTapped(_ sender: UIButton) {
        clearTextFields()
    }
    
    private func fetchTripData() {
        let tripTheme = itineraryTextField.text ?? ""
        let transportation = transportTextField.text ?? ""
        let departureLocation = departureLocationTextField.text ?? ""
        let returnLocation = returnLocationTextField.text ?? ""
        let departureTime = formatDate(date: departureDateTextField.date)
        let returnTime = formatDate(date: returnDateTextField.date)

        TripAPIManager.shared.fetchTripData(tripTheme: tripTheme, transportation: transportation, departureTime: departureTime, returnTime: returnTime, departureLocation: departureLocation, returnLocation: returnLocation) { [weak self] result in
            switch result {
            case .success(let tripResponse):
                self?.apiResponseData = tripResponse
                DispatchQueue.main.async {
                    self?.navigateToExploreDetail()
                }
            case .failure(let error):
                print("Failed to fetch trip data: \(error.localizedDescription)")
            }
        }
    }
    
    private func navigateToExploreDetail() {
        if !isNavigating {
            isNavigating = true
            performSegue(withIdentifier: "showExploreDetail", sender: nil)
        }
    }
    
    // 格式化日期
    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    private func clearTextFields() {
        itineraryTextField.text = ""
        transportTextField.text = ""
        departureLocationTextField.text = ""
        returnLocationTextField.text = ""
        departureDateTextField.setDate(Date(), animated: true)
        returnDateTextField.setDate(Date(), animated: true)
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
  

}
