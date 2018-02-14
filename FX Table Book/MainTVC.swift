//
//  MainTVC.swift
//  FX Table Book
//
//  Created by Shripal Jain on 13/02/18.
//  Copyright © 2018 shripaljain. All rights reserved.
//

import UIKit

class MainTVC: UITableViewCell {

    @IBOutlet weak var custname: UILabel!
    @IBOutlet weak var custmobile: UILabel!
    @IBOutlet weak var nop: UILabel!
    @IBOutlet weak var allotedtb: UILabel!
    @IBOutlet weak var msg: UIButton!
    @IBOutlet weak var callbutton: UIButton!
    
    @IBOutlet weak var callbtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func phone(phoneNum: String) {
        if let url = URL(string: "tel://\(phoneNum)") {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url as URL)
            }
        }
    }
    
    
    @IBAction func callclick(_ sender: UIButton) {
        print(sender.tag)
        phone(phoneNum: String(sender.tag))
    
    }
    
    

}
