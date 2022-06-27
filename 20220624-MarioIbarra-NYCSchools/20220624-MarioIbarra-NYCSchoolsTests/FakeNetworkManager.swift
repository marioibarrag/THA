import Foundation
@testable import _0220624_MarioIbarra_NYCSchools

class FakeNetworkManager: NetworkManagerProtocol {
    
    var data: Data?
    var error: NetworkError?
    
    func fetchData<Model>(from url: String, offset: Int?, model: Model.Type, completion: @escaping (Result<Model, NetworkError>) -> Void) where Model : Decodable {
        
        if let data = data {
            do {
                let result = try JSONDecoder().decode(Model.self, from: data)
                completion(.success(result))
            } catch { }
        }
        
        if let error = error {
            completion(.failure(error))
        }
    }
    
    
}
