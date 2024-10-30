import UIKit
import CoreData

struct Trip {
    let id: UUID
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
    private let context = CoreDataManager.shared.context

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
    
    // 新增 deleteTrip 方法
    func deleteTrip(withId id: UUID, completion: @escaping (Bool) -> Void) {
        let fetchRequest: NSFetchRequest<TripEntity> = TripEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        do {
            let fetchedTrips = try context.fetch(fetchRequest)
            if let tripEntityToDelete = fetchedTrips.first {
                context.delete(tripEntityToDelete)
                try context.save()
                
                // 更新 trips 陣列
                trips.removeAll { $0.id == id }
                
                completion(true) // 刪除成功
            } else {
                completion(false) // 找不到要刪除的行程
            }
        } catch {
            print("Failed to delete trip: \(error)")
            completion(false) // 刪除失敗
        }
    }

}
