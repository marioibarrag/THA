import Foundation

protocol NetworkManagerProtocol {
    func fetchData<Model: Decodable>(from url: String, offset: Int?, model: Model.Type, completion: @escaping (Result<Model,NetworkError>) -> Void)
}

class NetworkManager: NetworkManagerProtocol {
    
    func fetchData<Model: Decodable>(from urlString: String, offset: Int?, model: Model.Type = Model.self, completion: @escaping (Result<Model, NetworkError>) -> Void) {
        var urlString = urlString
        
        if let offset = offset {
            urlString += "&$offset=\(offset)"
        }
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.badURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(.failure(.other))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.badResponse))
                return
            }
            
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(Model.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(.badDecode))
                    return
                }
            }
        }.resume()
    }
    
}
