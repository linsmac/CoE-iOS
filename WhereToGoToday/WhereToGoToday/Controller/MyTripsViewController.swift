//
//  MyTripViewController.swift
//  WhereToGoToday
//
//  Created by Gorgais Yeh on 2024/9/4.
//

import UIKit


class MyTripsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var myTripList: UITableView!
    
    //表格載入的起點
    override func viewDidLoad() {
        super.viewDidLoad()
        //dataSource定表格要顯示多少行程以及每個行程顯示什麼內容
        myTripList.dataSource = self
        //允許處理使用者與表格的互動(ex:點擊行程
        myTripList.delegate = self
        
    }
    
    struct Trip {
        let name: String
        let date: String
        let image: UIImage
    }

    var trips: [Trip] = [
        Trip(name: "Summer Vacation", date: "2024-06-01 - 2024-06-10", image: UIImage(named: "trip1") ?? UIImage()),
        Trip(name: "Winter Wonderland", date: "2024-12-15 - 2024-12-22", image: UIImage(named: "trip2") ?? UIImage())
    ]


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
}




    



