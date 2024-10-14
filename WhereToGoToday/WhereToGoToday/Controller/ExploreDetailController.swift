import UIKit
import MapKit

struct TripDay {
    let day: String
    let activities: [String]
}


class ExploreDetailController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewUnder: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var savaDetailButton: UIButton!
    
    var tripInfo: TripResponse?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化地圖
        let initialLocation = CLLocation(latitude: 25.0330, longitude: 121.5654)
        centerMapOnLocation(location: initialLocation)
        
        // 設定 TableView 的委派和資料來源
        tableView.delegate = self
        tableView.dataSource = self
        
        // 初始設置 Segmented Control
        setupSegmentedControl()
        
        print("初始化詳細頁面")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        tableView.reloadData()
    }
    
    func setupSegmentedControl() {
        segmentedControl.removeAllSegments()
        segmentedControl.insertSegment(withTitle: "行程總覽", at: 0, animated: false)
        
        if let days = tripInfo?.generatedTripInfo.days {
            for (index, day) in days.enumerated() {
                segmentedControl.insertSegment(withTitle: day.label, at: index + 1, animated: false)
            }
        }
        
        segmentedControl.selectedSegmentIndex = 0
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // 第一個 section 是 generated_trip_info，後面每個 section 是一天的活動
        return 1
    }
    
    //告訴 UITableView 每個 section 需要顯示多少列
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            return 1  // 行程總覽
        default:
            let dayIndex = segmentedControl.selectedSegmentIndex - 1
            return tripInfo?.generatedTripInfo.days[dayIndex].activities.count ?? 0
        }
    }
    
    //設定每個 cell 內的資料
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if segmentedControl.selectedSegmentIndex == 0 {
            // 使用總覽行程的自訂 Cell
            let overviewCell = tableView.dequeueReusableCell(withIdentifier: "OverviewCell", for: indexPath) as! OverviewCell
            if let overview = tripInfo?.generatedTripInfo.tripOverview {
                overviewCell.locationLabel.text = overview.location
                overviewCell.dateLabel.text = "\(overview.startDate) ~ \(overview.endDate)"
                overviewCell.descriptionLabel.text = overview.description
                overviewCell.descriptionLabel.numberOfLines = 0  // 允許自動換行
            }
            return overviewCell
        } else {
            // 使用每天行程的自訂 Cell
            let dayCell = tableView.dequeueReusableCell(withIdentifier: "DayCell", for: indexPath) as! DayCell
            let dayIndex = segmentedControl.selectedSegmentIndex - 1
            let activity = tripInfo?.generatedTripInfo.days[dayIndex].activities[indexPath.row]

            // 設置活動資訊
            dayCell.locationLabel.text = activity?.location ?? "N/A" // 如果為空白，顯示空白

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX") // 確保格式正確解析

            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "HH:mm"  // 用於顯示時、分

            if let startTimeString = activity?.startTime, let startDate = dateFormatter.date(from: startTimeString) {
                dayCell.startTimeLabel.text = displayFormatter.string(from: startDate)
            } else {
                dayCell.startTimeLabel.text = "N/A"
            }

            if let endTimeString = activity?.endTime, let endDate = dateFormatter.date(from: endTimeString) {
                dayCell.endTimeLabel.text = displayFormatter.string(from: endDate)
            } else {
                dayCell.endTimeLabel.text = "N/A"
            }

            // 設定停留時間，當為 nil 時顯示 0
            dayCell.stayDurationLabel.text = "\(activity?.stayDuration ?? "0")分鐘"
            dayCell.addressLabel.text = activity?.address ?? ""

            // 設定交通方式和行駛時間
            if let transportation = activity?.transportation {
                dayCell.transportationModeLabel.text = "交通方式: \(transportation.mode)" // 顯示交通方式
                if let travelTime = transportation.travelTime, let timeInMinutes = Int(travelTime) {
                    dayCell.travelTimeLabel.text = "行駛時間: \(timeInMinutes) 分鐘" // 顯示行駛時間
                } else {
                    dayCell.travelTimeLabel.text = "行駛時間: N/A"
                }
            } else {
                dayCell.transportationModeLabel.text = "交通方式: N/A"
                dayCell.travelTimeLabel.text = "行駛時間: N/A"
            }
            
            

            return dayCell
        }
    }


    
}
