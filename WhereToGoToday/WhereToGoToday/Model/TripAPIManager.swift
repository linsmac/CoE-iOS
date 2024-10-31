// TripManager.swift
import Foundation

class TripAPIManager {
    static let shared = TripAPIManager()
    
    weak var delegate: TripAPIManagerDelegate?
    
    func fetchTripData(tripTheme: String, transportation: String, departureTime: String, returnTime: String, departureLocation: String, returnLocation: String, completion: @escaping (Result<TripResponse, Error>) -> Void) {
        let urlString = "https://fastapi-x70s.onrender.com/Trip/"
        guard let url = URL(string: urlString) else {
            delegate?.didFailToFetchTripData(error: NSError(domain: "Invalid URL", code: -1, userInfo: nil))
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
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            if let error = error {
                self.delegate?.didFailToFetchTripData(error: error)
                return
            }
            
            guard let data = data else {
                self.delegate?.didFailToFetchTripData(error: NSError(domain: "No Data", code: -2, userInfo: nil))
                return
            }
            
            do {
                let responseData = try JSONDecoder().decode(TripResponse.self, from: data)
                self.delegate?.didFetchTripData(responseData)
            } catch {
                self.delegate?.didFailToFetchTripData(error: error)
            }
        }
        task.resume()
    }
}

protocol TripAPIManagerDelegate: AnyObject {
    func didFetchTripData(_ tripResponse: TripResponse)
    func didFailToFetchTripData(error: Error)
}

