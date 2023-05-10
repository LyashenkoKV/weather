//
//  Extension.swift
//  WeatherProject
//
//  Created by Konstantin Lyashenko on 06.04.2023.
//

import UIKit

extension UIView {
    private static var gradientLayerKey: UInt8 = 0
    private var gradientLayer: CAGradientLayer? {
        get {
            return objc_getAssociatedObject(self, &UIView.gradientLayerKey) as? CAGradientLayer
        }
        set {
            objc_setAssociatedObject(self, &UIView.gradientLayerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func addGradientLayer(topColor: UIColor, bottomColor: UIColor) {
        if let oldGradient = gradientLayer {
            oldGradient.removeFromSuperlayer()
        }
        
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.type = .radial
        gradient.colors = [topColor.cgColor, bottomColor.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.name = "GradientLayer"
        gradient.shouldRasterize = true
        layer.insertSublayer(gradient, at: 0)
        
        gradientLayer = gradient
    }
}
