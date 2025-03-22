//
//  RealtimeDatabase.swift
//  geber
//
//  Created by Vikri Yuwi on 22/03/25.
//

import Foundation
import FirebaseDatabase

class RealtimeDatabaseService {
    static let shared = RealtimeDatabaseService()
    private let database = Database.database().reference()
    
    private init() {}
    
    func observeData<T: Decodable>(path: String, completion: @escaping (Result<[T], Error>) -> Void) {
        database.child(path).observe(.value) { snapshot in
            
            guard snapshot.exists(), let children = snapshot.children.allObjects as? [DataSnapshot] else {
                print("No children found or snapshot does not exist.")
                return
            }
            
            do {
                let result: [T] = try children.compactMap { childSnapshot in
                    guard let dictionary = childSnapshot.value as? [String: Any] else { return nil }
                    let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
                    return try JSONDecoder().decode(T.self, from: data)
                }
                
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func writeDataAutoId<T: Encodable>(path: String, data: T, completion: @escaping (Error?) -> Void) {
        do {
            let jsonData = try JSONEncoder().encode(data)
            let dict = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any]
            database.child(path).childByAutoId().setValue(dict) { error, _ in
                completion(error)
            }
        } catch {
            completion(error)
        }
    }
}
