

import Foundation

protocol CarsServiceProtocol {
    func getCars(limit : Int, offset : Int, successCallback: @escaping ([Car]) -> Void, failureCallback: @escaping ([Car], Error) -> Void)
}

final class CarsService : CarsServiceProtocol {

    private let networkManager = NetworkManager(session: URLSession.shared)
    private let databaseManager = DatabaseManager.shared
    private let baseUrl = "https://www.apphusetreach.no/application/119267/"

    func getCars(limit : Int, offset : Int, successCallback: @escaping ([Car]) -> Void, failureCallback: @escaping ([Car], Error) -> Void) {
        getItems(limit: limit, offset: offset, successCallback: successCallback, failureCallback: failureCallback)
    }

    // MARK: Private Methods

    private func getItems(limit : Int, offset : Int, successCallback: @escaping ([Car]) -> Void, failureCallback: @escaping ([Car], Error) -> Void) {
        //var items: [Car] = []
        let GET_REVIEWS_ENDPOINT = "article/get_articles_list"
        let url = URL(string: baseUrl + GET_REVIEWS_ENDPOINT)
        networkManager.loadData(url: url) { [weak self] result in
            switch(result) {
                case .success(let data):
                    
                    let decoder = JSONDecoder()
                    decoder.userInfo[CodingUserInfoKey.context!] = self?.databaseManager.persistentContainer.viewContext
                    let article = try? decoder.decode(Article.self, from: data)
                    guard let cars = article?.content else {
                        print("cars not found")
                        return
                    }
                    self?.databaseManager.sync()
                    DispatchQueue.main.async {
                        successCallback(cars)
                    }

                case .failure(let error):
                    //fetch cars saved in db
                    let cars = self?.databaseManager.loadFromDB()
                    DispatchQueue.main.async {
                        if let cars = cars {
                            failureCallback(cars, error)
                        } else {
                            failureCallback([Car](), error)
                        }
                        
                    }
            }
        }

    }


}
