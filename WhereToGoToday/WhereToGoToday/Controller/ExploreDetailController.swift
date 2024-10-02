import UIKit
import MapKit

struct TripDay {
    let day: String
    let activities: [String]
}


class ExploreDetailController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
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
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        tableView.reloadData()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            return 1  // 行程總覽
        default:
            let dayIndex = segmentedControl.selectedSegmentIndex - 1
            return tripInfo?.generatedTripInfo.days[dayIndex].activities.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let DetailCell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            // 行程總覽
            if let overview = tripInfo?.generatedTripInfo.tripOverview {
                DetailCell.textLabel?.text = "地點: \(overview.location)\n開始日期: \(overview.startDate)\n結束日期: \(overview.endDate)"
            }
        default:
            let dayIndex = segmentedControl.selectedSegmentIndex - 1
            let activity = tripInfo?.generatedTripInfo.days[dayIndex].activities[indexPath.row]
            DetailCell.textLabel?.text = activity?.location
        }

        return DetailCell
    }


    
}
