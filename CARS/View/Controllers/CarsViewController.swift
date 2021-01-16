//
//  CarsViewController.swift
//  CARS
//
//  Created by DEEPALI MAHESHWARI on 28/12/20.
//  Copyright © 2020 DEEPALI MAHESHWARI. All rights reserved.
//

import UIKit

class CarsViewController: UIViewController, CarViewModelDelegate {

   
    @IBOutlet weak var tableView: UITableView!
    private var viewModel : CarViewModelProtocol!
    
    override func viewDidLoad() {
        viewModel = CarViewModel(service: CarsService())
        viewModel.delegate = self
        viewModel.getCars()
    }
    
    func success() {
        self.tableView.reloadData()
    }
    
    func failure(error : Error) {
        self.tableView.reloadData()
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension CarsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getCarsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CarsTableViewCell", for: indexPath) as! CarsTableViewCell
        let car = viewModel.getCarAtIndex(indexPath.row)
        cell.configureCell(car: car)
        return cell
        
    }
    
}
