//
//  MyTripViewController.swift
//  WhereToGoToday
//
//  Created by Gorgais Yeh on 2024/9/4.
//

import UIKit


class MyTripsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var myTripList: UITableView!
    
    struct Trip {
        let name: String
        let date: String
        let image: UIImage
    }

    var trips: [Trip] = [
        Trip(name: "Summer Vacation", date: "2024-06-01 - 2024-06-10", image: UIImage(named: "trip1") ?? UIImage()),
        Trip(name: "Winter Wonderland", date: "2024-12-15 - 2024-12-22", image: UIImage(named: "trip2") ?? UIImage())
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        myTripList.dataSource = self
        myTripList.delegate = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTripCell", for: indexPath) as! MyTripCell
        let trip = trips[indexPath.row]
        cell.backgroundImageView.image = trip.image
        cell.nameLabel.text = trip.name
        cell.dateLabel.text = trip.date
        return cell
    }
}




    



