import UIKit
import CoreData

struct Trip {
    let id: UUID // 新增此屬性
    let name: String
    let date: String
    let image: UIImage
    
    func toTripResponse() -> TripResponse {
        // 模擬生成一個 TripResponse 物件
        let tripOverview = TripOverview(location: name, startDate: date, endDate: date, description: "")
        let generatedTripInfo = GeneratedTripInfo(tripOverview: tripOverview, days: [])
        return TripResponse(generatedTripInfo: generatedTripInfo)
    }
}

class MyTripManager {
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
                    id: tripEntity.id ?? UUID(), // 從 `TripEntity` 取得 `id`
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
    
    func fetchTripDetails(by id: UUID, completion: @escaping (TripEntity?) -> Void) {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<TripEntity> = TripEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        do {
            let fetchedTrips = try context.fetch(fetchRequest)
            completion(fetchedTrips.first)
        } catch {
            print("Failed to fetch trip details: \(error)")
            completion(nil)
        }
    }

}
