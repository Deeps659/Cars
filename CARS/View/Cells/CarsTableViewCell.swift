//
//  Cells.swift
//  CARS
//
//  Created by DEEPALI MAHESHWARI on 28/12/20.
//  Copyright © 2020 DEEPALI MAHESHWARI. All rights reserved.
//

import UIKit

class CarsTableViewCell : UITableViewCell {
   
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    func configureCell(car : Car) {
        titleLabel.text = car.title
        descLabel.text = car.ingress
        dateLabel.text = is24Hour() ? car.dateTime?.getFormattedDateString(format: "24") : car.dateTime?.getFormattedDateString(format: "12")
        setupImageView(imageUrl: car.image!)
    }
    
    private func setupImageView(imageUrl : String) {
        carImage.loadImage(urlSting: imageUrl)
        carImage.addEffectOnBottom()
    }
    
    private func is24Hour() -> Bool {
        let dateFormat = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.current)!
        return dateFormat.firstIndex(of: "a") == nil
    }
    
}
