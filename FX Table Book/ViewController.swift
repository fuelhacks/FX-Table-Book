//
//  ViewController.swift
//  FX Table Book
//
//  Created by Shripal Jain on 12/02/18.
//  Copyright © 2018 shripaljain. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
   
    
    @IBAction func custloginbtn(_ sender: Any) {
        performSegue(withIdentifier: "custloginvcsegue", sender: nil)
    }
    
    @IBAction func recloginbtn(_ sender: Any) {
        performSegue(withIdentifier: "recloginvcsegue", sender: nil)
    }
    
    
}

