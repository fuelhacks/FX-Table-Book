//
//  WaitingVC.swift
//  FX Table Book
//
//  Created by Shripal Jain on 12/02/18.
//  Copyright © 2018 shripaljain. All rights reserved.
//

import UIKit
import Firebase
import PKHUD

class WaitingVC: UIViewController {

    @IBOutlet weak var msg1: UILabel!
    
    @IBOutlet weak var msg2: UILabel!
    
    @IBOutlet weak var msg3: UILabel!
    @IBOutlet weak var minleft: UILabel!
    @IBOutlet weak var position: UILabel!
    var mobile:String!
    var token:Int!
    var avgtime:Int!
    var queno:Int!
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       token = UserDefaults.standard.integer(forKey: "ctokenno")
    mobile = UserDefaults.standard.string(forKey: "mobile")
        // Do any additional setup after loading the view.
        print(mobile)
        print(token)
        load()
    }
    
    func load(){
        db.collection("waitinglist")
            .whereField("mobile", isEqualTo: mobile ?? "0")
            .whereField("tokenno", isEqualTo: token ?? 0)
            .addSnapshotListener  { (querySnapshot, err) in
                guard let documents = querySnapshot?.documents else {
                    print("Error of G\(err!)")
                    return
                }
                if(documents.count == 1){
                    print(documents[0].data())
                    let status:Int = documents[0].data()["status"] as! Int
                    if(status == 1){
                        self.msg2.alpha = 1
                        self.msg1.alpha = 0
                        self.msg3.alpha = 0
                        self.position.text = "-- mins"
                        self.minleft.text = "-- Position"
                        
                    }
                    else{
                        self.msg3.alpha = 1
                        self.msg2.alpha = 0
                        self.msg1.alpha = 0
                        PKHUD.sharedHUD.contentView = PKHUDProgressView()
                        PKHUD.sharedHUD.show()
                        self.caltimeandpos()
                        
                    }
                    
                }
                else{
                    self.msg1.alpha = 1
                    self.msg2.alpha = 0
                    self.msg3.alpha = 0
                    self.position.text = "-- mins"
                    self.minleft.text = "-- Position"
                }
                
        }
        
    }

   
    @IBAction func logout(_ sender: Any) {
        UserDefaults.standard.set(1, forKey: "status")
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController:UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        let rootViewController:UIViewController = storyboard.instantiateViewController(withIdentifier: "firstview") as UIViewController
        navigationController.viewControllers = [rootViewController]
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = navigationController
    }
    
    func caltimeandpos(){
        let docRef = db.collection("settings").document("GQIyZhq7mxaIFdZg0AMw")
        
        docRef.getDocument { (document, error) in
            if let document = document {
                print("Document data: \(document.data())")
                let data = document.data()
                let avgt = data["avgtime"] ?? ""
                print(avgt)
                self.avgtime = avgt as! Int
                
                print(self.avgtime)
                
                self.db.collection("waitinglist")
                    .whereField("tokenno", isLessThanOrEqualTo: self.token)
                    .whereField("status", isEqualTo: -1)
                    .addSnapshotListener  { (querySnapshot, err) in
                        guard let documents = querySnapshot?.documents else {
                            print("Error of G\(err!)")
                            return
                        }
                        self.queno = documents.count
                        print(self.queno)
                        self.position.text = "Pos No. \(self.queno!)"
                        self.minleft.text = "\(self.queno * self.avgtime) mins"
                        PKHUD.sharedHUD.hide(afterDelay: 1.0) { succ in
                            
                        }
                }
            } else {
                print("Document does not exist")
            }
        }
        
        
     
        
        
    }
}
