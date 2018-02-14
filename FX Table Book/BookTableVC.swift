//
//  BookTableVC.swift
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

class BookTableVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var name: SkyFloatingLabelTextField!
    
    @IBOutlet weak var mobile: SkyFloatingLabelTextField!
    
    @IBOutlet weak var nop: SkyFloatingLabelTextField!
    
    var tokeno:Int!
    //var ref: DatabaseReference!
    //No Old Stuff Please...FirebaseFireStore it is
    let db = Firestore.firestore()
    var popupController:CNPPopupController?
    override func viewDidLoad() {
        super.viewDidLoad()
        PKHUD.sharedHUD.dimsBackground = false
        PKHUD.sharedHUD.contentView.alpha = 1
        name.delegate=self
        mobile.delegate=self
        nop.delegate=self
        tokeno = UserDefaults.standard.integer(forKey: "tokenno")
        //ref = Database.database().reference()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tokeno = UserDefaults.standard.integer(forKey: "tokenno")
    }
    
    
    @IBAction func bookbtn(_ sender: Any) {
        //self.ref.child("waitinglist").childByAutoId().setValue(["name": name.text, "mobile":mobile.text, "nop":nop.text])
        
        
        validate()
    
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
        if (name.text?.isEmpty)! && (mobile.text?.isEmpty)! && (nop.text?.isEmpty)!{
            self.showPopupWithStyle(CNPPopupStyle.centered,_heading: "ERROR" ,_error: "All fields are compulsory", _icon: "error")
            
        }
        else{
            PKHUD.sharedHUD.contentView = PKHUDProgressView()
            PKHUD.sharedHUD.show()
            addwl()
        }
    }
    
    
    
    func addwl(){
        var ref: DocumentReference? = nil
        ref = db.collection("waitinglist").addDocument(data: [
            "name": name.text!,
            "mobile": mobile.text!,
            "nop": nop.text!,
            "tokenno": tokeno,
            "status": -1,
            "created_at": NSDate().timeIntervalSince1970
        ]) { err in
            if let err = err {
                PKHUD.sharedHUD.hide(afterDelay: 1.0) { succ in
                    self.showPopupWithStyle(CNPPopupStyle.centered,_heading: "Login Error!",_error: err.localizedDescription, _icon: "error")
                }
            } else {
                PKHUD.sharedHUD.hide(afterDelay: 1.0) { succ in
                    
                    self.view.endEditing(true)
                    UserDefaults.standard.set(self.tokeno, forKey: "tokenno")
                    HUD.flash(.success, delay: 1.0)
                    
                //self.navigationController?.popToRootViewController(animated: true)
                    self.showPopupWithStyle(CNPPopupStyle.centered,_heading: "Token Number is Generated",_error: "Hi \(self.name.text!), your token no is \(self.tokeno!)", _icon: "timer")
                    self.name.text=""
                    self.mobile.text=""
                    self.nop.text=""
                    self.tokeno = self.tokeno + 1
                    UserDefaults.standard.set(self.tokeno, forKey: "tokenno")
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
