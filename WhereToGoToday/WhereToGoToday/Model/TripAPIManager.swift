// TripManager.swift
import Foundation

class TripAPIManager {
    static let shared = TripAPIManager()
    
    func fetchTripData(tripTheme: String, transportation: String, departureTime: String, returnTime: String, departureLocation: String, returnLocation: String, completion: @escaping (Result<TripResponse, Error>) -> Void) {
        let urlString = "https://fastapi-x70s.onrender.com/Trip/"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "trip_theme": tripTheme,
            "transportation": transportation,
            "departure_time": departureTime,
            "return_time": returnTime,
            "departure_location": departureLocation,
            "return_location": returnLocation
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        // 發送 API 請求
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: -2, userInfo: nil)))
                return
            }
            
            do {
                let responseData = try JSONDecoder().decode(TripResponse.self, from: data)
                completion(.success(responseData))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
