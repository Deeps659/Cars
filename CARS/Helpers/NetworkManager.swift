import Foundation

enum Result<Success, Failure : Error> {
    case success(Success)
    case failure(Failure)
}

enum HTTPError: Error {
    case invalidURL
    case emptyData
}

protocol URLSessionProtocol {
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    
    func dataTask(with request: URL, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol { func resume() }

class NetworkManager {
    
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    func loadData(url: URL?, completion: @escaping (Result<Data, Error>) -> ()) {
        guard let url = url else {
            completion(.failure(HTTPError.invalidURL))
            return
        }
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(HTTPError.emptyData))
                return
            }
            completion(.success(data))
            
            
        }.resume()
        
        
    }
    
}



//MARK: Conform the protocol
extension URLSession: URLSessionProtocol {
    func dataTask(with request: URL, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
    }
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}
