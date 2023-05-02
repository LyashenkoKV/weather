//
//  Extension.swift
//  WeatherProject
//
//  Created by Konstantin Lyashenko on 06.04.2023.
//

import UIKit

extension UIView {
    func addGradientLayer(topColor: UIColor, bottomColor: UIColor) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.type = .radial
        gradient.colors = [topColor.cgColor, bottomColor.cgColor]
        gradient.locations = [0.0, 1.0]
        
        if UIDevice.current.orientation.isLandscape {
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        } else {
            gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        }
        self.layer.insertSublayer(gradient, at: 0)
    }
}
