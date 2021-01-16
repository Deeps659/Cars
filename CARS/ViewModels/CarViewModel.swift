//
//  CarViewModel.swift
//  CARS
//
//  Created by DEEPALI MAHESHWARI on 29/12/20.
//  Copyright © 2020 DEEPALI MAHESHWARI. All rights reserved.
//

import Foundation

protocol CarViewModelProtocol {
    var delegate : CarViewModelDelegate? { get set }
    func getCars()
    func getCarsCount() -> Int
    func getCarAtIndex(_ index : Int) -> Car
}

protocol CarViewModelDelegate:class {
    func success()
    func failure(error : Error)
}

class CarViewModel : CarViewModelProtocol {
    
    var delegate: CarViewModelDelegate?
    private let service : CarsServiceProtocol
    private var cars: [Car] = []
    
    init(service : CarsServiceProtocol) {
        self.service = service
    }
    
    func getCars() {
        service.getCars(limit: 10, offset: 0, successCallback: {
            [weak self] carsArr in
            self?.cars.append(contentsOf: carsArr)
            self?.delegate?.success()
        }) { [weak self] carsFromDb, error in
            self?.cars.append(contentsOf: carsFromDb)
            self?.delegate?.failure(error: error)
        }
    }
    
    func getCarsCount() -> Int {
        return cars.count
    }
    
    func getCarAtIndex(_ index : Int) -> Car {
        return cars[index]
    }
    
}


