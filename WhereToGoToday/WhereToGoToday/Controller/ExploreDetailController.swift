import UIKit
import MapKit

struct TripDay {
    let day: String
    let activities: [String]
}


class ExploreDetailController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    var tripInfo: TripResponse?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化地圖
        let initialLocation = CLLocation(latitude: 25.0330, longitude: 121.5654)
        centerMapOnLocation(location: initialLocation)
        
        // 設定 TableView 的委派和資料來源
        tableView.delegate = self
        tableView.dataSource = self
        
        print("初始化詳細頁面")
        
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // 第一個 section 是 generated_trip_info，後面每個 section 是一天的活動
        return 1 + (tripInfo?.generatedTripInfo.days.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            // 第一個 section 是 generated_trip_info，只有一個 row
            return 1
        } else {
            // 每一天的活動數量決定 row 的數量
            return tripInfo?.generatedTripInfo.days[section - 1].activities.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "行程總覽"
        } else {
            // 根據 section 決定標題
            return tripInfo?.generatedTripInfo.days[section - 1].label
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let DetailCell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)
        
        if indexPath.section == 0 {
            // 顯示行程總覽
            if let overview = tripInfo?.generatedTripInfo.tripOverview {
                DetailCell.textLabel?.text = "地點: \(overview.location)\n開始日期: \(overview.startDate)\n結束日期: \(overview.endDate)\n描述: \(overview.description)"
            }
        } else {
            // 顯示每天的活動
            let dayIndex = indexPath.section - 1
            if let activity = tripInfo?.generatedTripInfo.days[dayIndex].activities[indexPath.row] {
                DetailCell.textLabel?.text = "地點: \(activity.location)\n活動: \(activity.activity)\n交通方式: \(activity.transportation?.mode ?? "")"
                DetailCell.detailTextLabel?.text = "停留時間: \(activity.stayDuration ?? "N/A")"
            }
        }
        
        return DetailCell
    }


    
}
