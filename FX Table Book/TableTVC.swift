//
//  TableTVC.swift
//  FX Table Book
//
//  Created by Shripal Jain on 13/02/18.
//  Copyright © 2018 shripaljain. All rights reserved.
//

import UIKit

class TableTVC: UITableViewCell {

    
    @IBOutlet weak var tno: UILabel!
    
    @IBOutlet weak var tcap: UILabel!
    
    @IBOutlet weak var tdesc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
