import SwiftUI
@testable import geber

class MockRealtimeDatabaseService: RealtimeDatabaseServiceProtocol {
    var shouldReturnError = false
    
    var mockData: [HelpRequestModel] = [
        HelpRequestModel(timestamps: Date(), name: "User1", location: "East Area", detailLocation: "A01", vehicle: VehicleModel(model: "Mio", plateNumber: "A 1111 BC", color: "White")),
        HelpRequestModel(timestamps: Date(), name: "User2", location: "West Area", detailLocation: "B05", vehicle: VehicleModel(model: "Vario 125", plateNumber: "B 1945 IND", color: "Black"))
    ]

    
    func observeData<T>(path: String, completion: @escaping (Result<[T], any Error>) -> Void) where T : Decodable {
        if shouldReturnError {
            completion(.failure(NSError(domain: "MockError", code: 500, userInfo: nil)))
        } else {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: mockData, options: [])
                let decodedData = try JSONDecoder().decode([T].self, from: jsonData)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func writeDataAutoId<T>(path: String, data: T, completion: @escaping ((any Error)?) -> Void) where T : Encodable {
        if shouldReturnError {
            completion(NSError(domain: "MockError", code: 500, userInfo: nil))
        } else {
            completion(nil)
        }
    }
}
