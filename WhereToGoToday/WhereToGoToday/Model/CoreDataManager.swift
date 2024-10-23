import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    let persistentContainer: NSPersistentContainer

    private init() {
        persistentContainer = NSPersistentContainer(name: "DataModel")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
    }

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving Core Data: \(error)")
            }
        }
    }

    //刪除全部core data中的資料
    func deleteAllTrips() {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = TripEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            try context.save()
            print("Successfully deleted all trips from Core Data.")
        } catch {
            print("Failed to delete trips: \(error)")
        }
    }

    // 新增 Trip 相關的處理方法
    func saveTrip(tripInfo: TripResponse) throws {
        let newTrip = TripEntity(context: context)
        newTrip.id = UUID() // Core Data 自動生成唯一的 UUID
        newTrip.location = tripInfo.generatedTripInfo.tripOverview.location
        newTrip.startDate = convertToDate(tripInfo.generatedTripInfo.tripOverview.startDate)
        newTrip.endDate = convertToDate(tripInfo.generatedTripInfo.tripOverview.endDate)
        newTrip.tripDescription = tripInfo.generatedTripInfo.tripOverview.description

        // 儲存原始 JSON
        if let jsonData = try? JSONEncoder().encode(tripInfo) {
            newTrip.originalJSON = jsonData
        }

        // 儲存 days 和 activities
        for day in tripInfo.generatedTripInfo.days {
            let newDay = DayEntity(context: context)
            newDay.label = day.label
            newDay.date = convertToDate(day.date)
            newDay.trip = newTrip
            
            for activity in day.activities {
                let newActivity = ActivityEntity(context: context)
                newActivity.location = activity.location
                newActivity.startTime = convertToDateTime(activity.startTime)
                newActivity.endTime = convertToDateTime(activity.endTime)
                newActivity.activityType = activity.activity
                newActivity.stayDuration = activity.stayDuration
                newActivity.address = activity.address
                newActivity.transportationMode = activity.transportation?.mode
                newActivity.travelTime = activity.transportation?.travelTime
                newActivity.day = newDay
            }
        }

        try context.save()
    }
    
    // 日期轉換方法
    private func convertToDate(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: dateString)
    }

    private func convertToDateTime(_ dateTimeString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter.date(from: dateTimeString)
    }
}
