import UIKit
import CoreData

struct Trip {
    let name: String
    let date: String
    let image: UIImage
}

class TripManager {
    private var trips: [Trip] = []

    func getTrips() -> [Trip] {
        return trips
    }

    func fetchTrips(completion: @escaping () -> Void) {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<TripEntity> = TripEntity.fetchRequest()

        do {
            let fetchedTrips = try context.fetch(fetchRequest)
            
            // 設定日期格式化器
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"

            // 將 `TripEntity` 轉換為 `Trip`
            self.trips = fetchedTrips.map { tripEntity in
                let startDateString = tripEntity.startDate.flatMap { dateFormatter.string(from: $0) } ?? "Unknown"
                let endDateString = tripEntity.endDate.flatMap { dateFormatter.string(from: $0) } ?? "Unknown"
                let dateString = "\(startDateString) - \(endDateString)"
                
                return Trip(
                    name: tripEntity.location ?? "Unknown",
                    date: dateString,
                    image: UIImage(named: "defaultTripImage") ?? UIImage()
                )
            }

            completion()
        } catch {
            print("Failed to fetch trips: \(error)")
        }
    }
}
