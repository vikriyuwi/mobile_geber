import SwiftUI

protocol RealtimeDatabaseServiceProtocol {
    func observeData<T: Decodable>(path: String, completion: @escaping (Result<[T], Error>) -> Void)
    func writeDataAutoId<T: Encodable>(path: String, data: T, completion: @escaping (Error?) -> Void)
}
