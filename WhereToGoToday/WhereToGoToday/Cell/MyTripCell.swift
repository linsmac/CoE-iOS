import UIKit

class MyTripCell: UITableViewCell {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    
    @IBAction func moreButtonTapped(_ sender: UIButton) {
        // 處理更多功能按鈕的邏輯
    }
    
}
