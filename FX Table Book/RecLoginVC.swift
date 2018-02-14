//
//  RecLoginVC.swift
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
import SwiftGifOrigin

class RecLoginVC: ViewController,UITextFieldDelegate {

    @IBOutlet weak var password: SkyFloatingLabelTextField!
    @IBOutlet weak var email: SkyFloatingLabelTextField!
     var popupController:CNPPopupController?
    override func viewDidLoad() {
        super.viewDidLoad()
        PKHUD.sharedHUD.dimsBackground = false
        PKHUD.sharedHUD.contentView.alpha = 1
        password.delegate = self
        email.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        if textField.tag < 2{
            let nextResponder = self.view.viewWithTag(nextTag) as? UITextField
            nextResponder?.becomeFirstResponder()
        }
        else{
            textField.resignFirstResponder()
            validateLogin()
        }
        return false
    }
    
    
    
    @IBAction func loginbtn(_ sender: Any) {
        validateLogin()
    }
    
    
    func validateLogin(){
        if (password.text?.isEmpty)! && (email.text?.isEmpty)!{
            self.showPopupWithStyle(CNPPopupStyle.centered,_heading: "ERROR" ,_error: "All fields are compulsory", _icon: "fail")
            
        }
        else{
            PKHUD.sharedHUD.contentView = PKHUDProgressView()
            PKHUD.sharedHUD.show()
            doneLogin()
        }
    }
    
    func doneLogin(){
        let em=email.text!+"@fxtb.in";
        let pass=password.text!+password.text!;
        Auth.auth().signIn(withEmail: em, password: pass) { (user, error) in
            if let err=error {
                PKHUD.sharedHUD.hide(afterDelay: 1.0) { succ in
                    self.showPopupWithStyle(CNPPopupStyle.centered,_heading: "Login Error!",_error: err.localizedDescription, _icon: "fail")
                }
            }
            else{
                PKHUD.sharedHUD.hide(afterDelay: 1.0) { succ in
                    HUD.flash(.success, delay: 1.0)
                    UserDefaults.standard.set(em, forKey: "email")
                    UserDefaults.standard.set(pass, forKey: "password")
                    UserDefaults.standard.set(2, forKey: "status")
                    
                    let oldtoken = UserDefaults.standard.integer(forKey: "tokenno");
                   
                    if(oldtoken != 0){
                        UserDefaults.standard.set(oldtoken, forKey: "tokenno")
                    }
                    
                    else{
                        UserDefaults.standard.set(1, forKey: "tokenno")
                    }
                    
                    self.performSegue(withIdentifier: "mainvcsegue", sender: nil)
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
