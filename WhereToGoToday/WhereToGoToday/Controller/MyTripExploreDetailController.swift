import UIKit
import MapKit

class MyTripExploreDetailController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewUnder: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
      
    var tripInfo: TripResponse?

    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedControl.overrideUserInterfaceStyle = .light
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initializeMap() // 確保在畫面完全載入後再初始化地圖
        setupSegmentedControl()
        setupTableView()
        print("初始化詳細頁面")
    }
    
    //初始化地圖
    private func initializeMap() {
        guard let mapView = mapView else {
            print("mapView is nil")
            return
        }
        let initialLocation = CLLocation(latitude: 25.0330, longitude: 121.5654)
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(center: initialLocation.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    private func setupSegmentedControl() {
        segmentedControl.removeAllSegments()
        segmentedControl.insertSegment(withTitle: "行程總覽", at: 0, animated: false)
        
        if let days = tripInfo?.generatedTripInfo.days {
            for (index, day) in days.enumerated() {
                segmentedControl.insertSegment(withTitle: day.label, at: index + 1, animated: false)
            }
        }
        
        segmentedControl.selectedSegmentIndex = 0
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
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
    
    private func navigateToMyTrips() {
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 1
        }
    }

    // MARK: - TableView DataSource and Delegate Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            return 1
        default:
            let dayIndex = segmentedControl.selectedSegmentIndex - 1
            return tripInfo?.generatedTripInfo.days[dayIndex].activities.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if segmentedControl.selectedSegmentIndex == 0 {
            return configureOverviewCell(for: tableView, at: indexPath)
        } else {
            return configureDayCell(for: tableView, at: indexPath)
        }
    }

    private func configureOverviewCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let overviewCell = tableView.dequeueReusableCell(withIdentifier: "OverviewCell", for: indexPath) as! OverviewCell
        if let overview = tripInfo?.generatedTripInfo.tripOverview {
            overviewCell.locationLabel.text = overview.location
            overviewCell.dateLabel.text = "\(overview.startDate) ~ \(overview.endDate)"
            overviewCell.descriptionLabel.text = overview.description
            overviewCell.descriptionLabel.numberOfLines = 0
        }
        return overviewCell
    }
    
    private func configureDayCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let dayCell = tableView.dequeueReusableCell(withIdentifier: "DayCell", for: indexPath) as! DayCell
        let dayIndex = segmentedControl.selectedSegmentIndex - 1
        let activity = tripInfo?.generatedTripInfo.days[dayIndex].activities[indexPath.row]
        
        dayCell.configure(with: activity)
        return dayCell
    }
}
