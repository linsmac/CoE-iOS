
import UIKit
import CoreData


class MyTripsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var myTripList: UITableView!
    
    struct Trip {
        let name: String
        let date: String
        let image: UIImage
    }

    var trips: [Trip] = []
    
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


    //表格載入行程數量
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }

    //將每個行程資訊（名稱、日期、圖片）顯示在表格中
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTripCell", for: indexPath) as! MyTripCell
        let trip = trips[indexPath.row]
        cell.backgroundImageView.image = trip.image
        cell.nameLabel.text = trip.name
        cell.dateLabel.text = trip.date
        return cell
    }
    
    func fetchTrips() {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<TripEntity> = TripEntity.fetchRequest()

        do {
            let fetchedTrips = try context.fetch(fetchRequest)
            
            // 設定日期格式化器
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd" // 只顯示年月日

            // 將 `TripEntity` 轉換為 `MyTripsViewController.Trip`
            trips = fetchedTrips.map { tripEntity in
                let startDateString = tripEntity.startDate.flatMap { dateFormatter.string(from: $0) } ?? "Unknown"
                let endDateString = tripEntity.endDate.flatMap { dateFormatter.string(from: $0) } ?? "Unknown"
                let dateString = "\(startDateString) - \(endDateString)"
                
                return MyTripsViewController.Trip(
                    name: tripEntity.location ?? "Unknown",
                    date: dateString,
                    image: UIImage(named: "defaultTripImage") ?? UIImage() // 替換為實際圖片邏輯
                )
            }
            
            myTripList.reloadData()
            
        } catch {
            print("Failed to fetch trips: \(error)")
        }
    }



}

