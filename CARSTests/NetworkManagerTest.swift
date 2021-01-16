//
//  NetworkManagerTest.swift
//  CARSTests
//
//  Created by DEEPALI MAHESHWARI on 04/01/21.
//  Copyright © 2021 DEEPALI MAHESHWARI. All rights reserved.
//

import XCTest
@testable import CARS

class NetworkManagerTest: XCTestCase {
    
    var sut: NetworkManager?
    var session = MockURLSession()
    
    override func setUp() {
        super.setUp()
        sut = NetworkManager(session: session)
    }
    
    override func tearDown() {
      super.tearDown()
      sut = nil
    }
    
    func testLoadWithUrl() {
        guard let url = URL(string: "https://mockurl") else {
           fatalError("URL can't be empty")
        }
        sut?.loadData(url: url, completion: { result in
            // Return data
        })
        XCTAssert(session.lastURL == url)
           
       }
    
    func testloadResumeCalled() {
        let dataTask = MockURLSessionDataTask()
        session.nextDataTask = dataTask
        guard let url = URL(string: "https://mockurl") else {
            fatalError("URL can't be empty")
        }
        
        sut?.loadData(url: url, completion: { result in
            // Return data
        })
        
        XCTAssert(dataTask.resumeWasCalled)
    }

    func testLoadShouldReturnData() {
        let expectedData = "{}".data(using: .utf8)
        
        session.nextData = expectedData
        
        var actualData: Data?
        
        sut?.loadData(url: URL(string: "http://mockurl")!, completion: { result in
            switch(result) {
                case .success(let data):
                    actualData = data
                case .failure(let error):
                    print(error)
            }
        })
        
        XCTAssertNotNil(actualData)
    }
    
    func testLoadShouldReturnError() {
        
        session.nextError = HTTPError.invalidURL
        
        var actualError: Error?
        
        sut?.loadData(url: URL(string: "http://mockurl")!, completion: { result in
            switch(result) {
                case .success(let data):
                    print(data)
                case .failure(let error):
                    actualError = error
            }
        })
        XCTAssertNotNil(actualError)
    }
    

}



extension NetworkManagerTest {
    
    //MARK: MOCK
    class MockURLSession: URLSessionProtocol {

        var nextDataTask = MockURLSessionDataTask()
        var nextData: Data?
        var nextError: Error?
        
        private (set) var lastURL: URL?
        
        func successHttpURLResponse(request: URL) -> URLResponse {
            return HTTPURLResponse(url: request, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
        }
        
        func dataTask(with request: URL, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
            lastURL = request
            
            completionHandler(nextData, successHttpURLResponse(request: request), nextError)
            return nextDataTask
        }

    }

    class MockURLSessionDataTask: URLSessionDataTaskProtocol {
        private (set) var resumeWasCalled = false
        
        func resume() {
            resumeWasCalled = true
        }
    }
}
