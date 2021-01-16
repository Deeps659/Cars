//
//  CarsViewModelTest.swift
//  CARSTests
//
//  Created by DEEPALI MAHESHWARI on 03/01/21.
//  Copyright © 2021 DEEPALI MAHESHWARI. All rights reserved.
//

import XCTest
@testable import CARS

class CarsViewModelTest: XCTestCase {
    
    var sut: CarViewModel?
    var mockService: CarsService?
    
    override func setUp() {
        super.setUp()
        mockService = CarsService()
        sut = CarViewModel(service: mockService!)
    }
    
    override func tearDown() {
      super.tearDown()
      sut = nil
      mockService = nil
    }
    

    func testFetchCars()  {
        sut?.getCars()
        XCTAssertTrue((mockService?.isCarsFetched)!)
    }
    
    func testGetCarsCount()  {
        sut?.getCars()
        mockService?.fetchSuccess()
        XCTAssertEqual(sut?.getCarsCount(), 1)
    }

    func testGetCarAtIndex()  {
        sut?.getCars()
        mockService?.fetchSuccess()
        XCTAssertNotNil(sut?.getCarAtIndex(0))
    }
    
    func testFetchCars_failure() {
        sut?.getCars()
        mockService?.fetchFail(error: HTTPError.emptyData)
        XCTAssertEqual(sut?.getCarsCount(), 0)
    }

}

//Mock classes
extension CarsViewModelTest {
    
    
    
    class CarsService : CarsServiceProtocol {
        var isCarsFetched = false
        var successClosure: (([Car]) -> Void)!
        var failureClosure: (([Car], Error) -> Void)!
        
        
        func getCars(limit: Int, offset: Int, successCallback: @escaping ([Car]) -> Void, failureCallback: @escaping ([Car], Error) -> Void) {
            isCarsFetched = true
            successClosure = successCallback
            failureClosure = failureCallback
        }
        
        func fetchSuccess() {
            let testCar = Car()
            successClosure([testCar])
        }
        
        func fetchFail(error: HTTPError) {
            failureClosure([Car](), error)
        }
        
        
    }
}
