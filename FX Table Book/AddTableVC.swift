//
//  AddTableVC.swift
//  FX Table Book
//
//  Created by Shripal Jain on 13/02/18.
//  Copyright © 2018 shripaljain. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import FirebaseFirestore
import PKHUD
import CNPPopupController

class AddTableVC: UIViewController,UITextFieldDelegate {

    let db = Firestore.firestore()
    var popupController:CNPPopupController?
    
    @IBOutlet weak var tno: SkyFloatingLabelTextField!
    
    @IBOutlet weak var tcap: SkyFloatingLabelTextField!
    
    @IBOutlet weak var tdesc: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        PKHUD.sharedHUD.dimsBackground = false
        PKHUD.sharedHUD.contentView.alpha = 1
        tno.delegate=self
        tcap.delegate=self
        tdesc.delegate=self
        // Do any additional setup after loading the view.
    }

 
    @IBAction func addtablebtn(_ sender: Any) {
        validate()
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        if textField.tag < 3{
            let nextResponder = self.view.viewWithTag(nextTag) as? UITextField
            nextResponder?.becomeFirstResponder()
        }
        else{
            textField.resignFirstResponder()
            validate()
        }
        return false
    }
    
    func validate(){
        if (tno.text?.isEmpty)! && (tcap.text?.isEmpty)!{
            self.showPopupWithStyle(CNPPopupStyle.centered,_heading: "ERROR" ,_error: "All fields are compulsory", _icon: "error")
            
        }
        else{
            PKHUD.sharedHUD.contentView = PKHUDProgressView()
            PKHUD.sharedHUD.show()
            addtb()
        }
    }
    
    func addtb(){
        var ref: DocumentReference? = nil
        ref = db.collection("tables").addDocument(data: [
            "tableno": tno.text!,
            "tablecapacity": tcap.text!,
            "tabledesc": tdesc.text!,
            "occ":false
        ]) { err in
            if let err = err {
                PKHUD.sharedHUD.hide(afterDelay: 1.0) { succ in
                    self.showPopupWithStyle(CNPPopupStyle.centered,_heading: "Login Error!",_error: err.localizedDescription, _icon: "error")
                }
            } else {
                PKHUD.sharedHUD.hide(afterDelay: 1.0) { succ in
                    
                    self.view.endEditing(true)
                    HUD.flash(.success, delay: 1.0)
                
                    
                    self.tno.text=""
                    self.tcap.text=""
                    self.tdesc.text=""
                }
                
            }
        }
    }
    
}
