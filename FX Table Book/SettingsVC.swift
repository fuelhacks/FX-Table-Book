//
//  SettingsVC.swift
//  FX Table Book
//
//  Created by Shripal Jain on 13/02/18.
//  Copyright © 2018 shripaljain. All rights reserved.
//

import UIKit
import Firebase
import SkyFloatingLabelTextField
import PKHUD
import CNPPopupController

class SettingsVC: UIViewController {
    var popupController:CNPPopupController?
    let db = Firestore.firestore()
    @IBOutlet weak var avgtime: SkyFloatingLabelTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        getsettings()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getsettings()
    }

    func getsettings(){
        let docRef = db.collection("settings").document("GQIyZhq7mxaIFdZg0AMw")
        
        docRef.getDocument { (document, error) in
            if let document = document {
                print("Document data: \(document.data())")
                let data = document.data()
                let avgt = data["avgtime"] ?? ""
                print(avgt)
                self.avgtime.text = "\(avgt)"
                
            } else {
                print("Document does not exist")
            }
        }
    }
    

    @IBAction func save(_ sender: Any) {
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        let settings = db.collection("settings").document("GQIyZhq7mxaIFdZg0AMw")
        
        
        settings.updateData([
            "avgtime": Int(avgtime.text!) ?? 10
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                PKHUD.sharedHUD.hide(afterDelay: 1.0) { succ in
                    HUD.flash(.success, delay: 1.0)
                    self.view.endEditing(true)
                }
                print("Document successfully updated")
            }
        }
    }
    
    
    @IBAction func resettoken(_ sender: Any) {
        
        UserDefaults.standard.set(1, forKey: "tokenno")
        
    self.showPopupWithStyle(CNPPopupStyle.centered,_heading: "Token Reset Preformed" ,_error: "Token No will start from 1", _icon: "timer")
    }
    
    func showPopupWithStyle(_ popupStyle: CNPPopupStyle, _heading: String, _error:String, _icon:String) {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
        paragraphStyle.alignment = NSTextAlignment.center
        
        let title = NSAttributedString(string: _heading, attributes: [NSAttributedStringKey.font: UIFont(name: "Avenir Next", size: CGFloat(20))!, NSAttributedStringKey.paragraphStyle: paragraphStyle])
        let lineOne = NSAttributedString(string: _error , attributes: [NSAttributedStringKey.font: UIFont(name: "Avenir Next", size: CGFloat(16))!, NSAttributedStringKey.paragraphStyle: paragraphStyle])
        
        let button = CNPPopupButton.init(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setImage(UIImage(named: "exit") , for: .normal)
        
        
        button.layer.cornerRadius = 4;
        button.selectionHandler = { (button) -> Void in
            self.popupController?.dismiss(animated: true)
            print("Block for button: \(String(describing: button.titleLabel?.text))")
        }
        
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0;
        titleLabel.attributedText = title
        titleLabel.textColor = UIColor(red: 250.0/255.0, green: 75.0/255.0, blue: 37.0/255.0, alpha: 1.0)
        
        let lineOneLabel = UILabel()
        lineOneLabel.numberOfLines = 0;
        lineOneLabel.attributedText = lineOne;
        
        
        let imageView = UIImageView.init(image: UIImage.gif(name: _icon))
        
        imageView.frame.size.height = 88
        imageView.frame.size.width = 88
        let popupController = CNPPopupController(contents:[imageView, titleLabel, lineOneLabel, button])
        popupController.theme = CNPPopupTheme.default()
        popupController.theme.popupStyle = popupStyle
        popupController.delegate = self as? CNPPopupControllerDelegate
        self.popupController = popupController
        popupController.present(animated: true)
    }
}
