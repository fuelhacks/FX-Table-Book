//
//  CustomButton.swift
//  FX Table Book
//
//  Created by Shripal Jain on 12/02/18.
//  Copyright © 2018 shripaljain. All rights reserved.
//

import UIKit

@IBDesignable class CustomButton: UIButton {
    @IBInspectable var cornerRadius:CGFloat = 3.0{
        didSet{
            self.layer.cornerRadius = cornerRadius
            self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            self.layer.shadowOffset = CGSize(width: 0.0,height: 2.0)
            self.layer.shadowOpacity = 1.0
            self.layer.shadowRadius = 2.0
            self.layer.borderWidth = 1.0
            self.layer.borderColor = hexStringToUIColor(hex: "#2A577F").cgColor
        }
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}

