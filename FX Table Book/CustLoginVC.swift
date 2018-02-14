//
//  CustLoginVC.swift
//  FX Table Book
//
//  Created by Shripal Jain on 12/02/18.
//  Copyright © 2018 shripaljain. All rights reserved.
//

import UIKit
import Firebase
import SkyFloatingLabelTextField
import PKHUD
import CNPPopupController

class CustLoginVC: ViewController {

    @IBOutlet weak var mobile: SkyFloatingLabelTextField!
    
    
    @IBOutlet weak var token: SkyFloatingLabelTextField!
    
    let db = Firestore.firestore()
      var popupController:CNPPopupController?
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func loginbtn(_ sender: Any) {
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        let tokenno = Int(self.token.text!) ?? -1
        
        print(tokenno)
        db.collection("waitinglist")
            .whereField("mobile", isEqualTo: mobile.text ?? "0")
            .whereField("tokenno", isEqualTo: tokenno)
            .getDocuments() { (querySnapshot, err) in
                guard let documents = querySnapshot?.documents else {
                    print("Error of G\(err!)")
    self.showPopupWithStyle(CNPPopupStyle.centered,_heading: "Invalid Login Details",_error: "Please use your token as password", _icon: "fail")
                    return
                }
                if(documents.count == 1){
                    PKHUD.sharedHUD.hide(afterDelay: 1.0) { succ in
                    print(documents[0].data())
                       UserDefaults.standard.set(3, forKey: "status")
                    UserDefaults.standard.set(self.mobile.text, forKey: "mobile")
                    UserDefaults.standard.set(documents[0].data()["tokenno"], forKey: "ctokenno")
                    
                        self.performSegue(withIdentifier: "waitingvcsegue", sender: nil)
                        
                    }
                }
                else{
                    PKHUD.sharedHUD.hide(afterDelay: 1.0) { succ in
                    self.showPopupWithStyle(CNPPopupStyle.centered,_heading: "Invalid Login Details",_error: "Please use your token as password", _icon: "fail")
                    }
                }
                
        }
        
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
        
        
        let imageView = UIImageView.init(image: UIImage.gif(name: "error"))
        
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
