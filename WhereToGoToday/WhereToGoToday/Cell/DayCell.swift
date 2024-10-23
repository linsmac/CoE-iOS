import UIKit

class DayCell: UITableViewCell {
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var stayDurationLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var transportationModeLabel: UILabel!
    @IBOutlet weak var travelTimeLabel: UILabel!
    @IBOutlet weak var customView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 設置 customView 的外框和圓角
        customView.layer.borderColor = UIColor.darkGray.cgColor
        customView.layer.borderWidth = 0.5
    }
    
    func configure(with activity: Activity?) {
        locationLabel.text = activity?.location ?? "N/A"
        stayDurationLabel.text = "\(activity?.stayDuration ?? "0") 分鐘"
        addressLabel.text = activity?.address ?? ""

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "HH:mm"

        if let startTimeString = activity?.startTime,
           let startDate = dateFormatter.date(from: startTimeString) {
            startTimeLabel.text = displayFormatter.string(from: startDate)
        } else {
            startTimeLabel.text = "N/A"
        }

        if let endTimeString = activity?.endTime,
           let endDate = dateFormatter.date(from: endTimeString) {
            endTimeLabel.text = displayFormatter.string(from: endDate)
        } else {
            endTimeLabel.text = "N/A"
        }

        if let transportation = activity?.transportation {
            transportationModeLabel.text = "交通方式: \(transportation.mode)"
            if let travelTime = transportation.travelTime, let timeInMinutes = Int(travelTime) {
                travelTimeLabel.text = "行駛時間: \(timeInMinutes) 分鐘"
            } else {
                travelTimeLabel.text = "行駛時間: N/A"
            }
        } else {
            transportationModeLabel.text = "交通方式: N/A"
            travelTimeLabel.text = "行駛時間: N/A"
        }
    }
}
