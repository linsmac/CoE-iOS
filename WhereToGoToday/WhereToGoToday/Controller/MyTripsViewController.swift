
import UIKit
import CoreData


class MyTripsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var myTripList: UITableView!
    
    private let tripManager = MyTripManager()
    
    //表格載入的起點
    override func viewDidLoad() {
        super.viewDidLoad()
        //dataSource定表格要顯示多少行程以及每個行程顯示什麼內容
        myTripList.dataSource = self
        //允許處理使用者與表格的互動(ex:點擊行程
        myTripList.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 每次顯示頁面時重新加載資料
        fetchTrips() // 假設 fetchTrips() 方法用於載入最新的行程資料
    }
    
    // Fetch trips
    private func fetchTrips() {
        tripManager.fetchTrips { [weak self] in
            DispatchQueue.main.async {
                self?.myTripList.reloadData()
            }
        }
    }


    //表格載入行程數量
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tripManager.getTrips().count
    }

    //將每個行程資訊（名稱、日期、圖片）顯示在表格中
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTripCell", for: indexPath) as! MyTripCell
        let trip = tripManager.getTrips()[indexPath.row]
        cell.backgroundImageView.image = getRandomBackgroundImage()
        cell.nameLabel.text = trip.name
        cell.dateLabel.text = trip.date
        return cell
    }
    
    func getRandomBackgroundImage() -> UIImage {
        let imageNames = ["background1", "background2", "background3"] // 替換為實際圖片名稱
        let randomIndex = Int.random(in: 0..<imageNames.count)
        return UIImage(named: imageNames[randomIndex]) ?? UIImage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMyTripDetail" {
            if let indexPath = myTripList.indexPathForSelectedRow,
               let detailVC = segue.destination as? MyTripExploreDetailController {
                let trip = tripManager.getTrips()[indexPath.row]
                let tripEntityID = trip.id

                // 從 Core Data 載入對應的 TripEntity 並傳遞資料
                tripManager.fetchTripDetails(by: tripEntityID) { tripEntity in
                    if let originalJSONData = tripEntity?.originalJSON {
                        // 將 originalJSON 解碼為 TripResponse
                        let decoder = JSONDecoder()
                        if let tripResponse = try? decoder.decode(TripResponse.self, from: originalJSONData) {
                            detailVC.tripInfo = tripResponse
                        }
                    }
                }
            }
        }
    }


}

