//
//  EditTableVC.swift
//  FX Table Book
//
//  Created by Shripal Jain on 13/02/18.
//  Copyright © 2018 shripaljain. All rights reserved.
//

import UIKit
import Firebase
import PKHUD


class EditTableVC: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableview: UITableView!
    
    
    var arr = [Any]()
    var tabelid = [String]()
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate=self
        tableview.dataSource=self
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableview.reloadData()
    }
    
    func loadData(){
        db.collection("tables")
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                self.arr = [Any]()
                self.tabelid = [String]()
                for i in 0..<documents.count{
                    self.arr.append(documents[i].data())
                    
                    self.tabelid.append(documents[i].documentID)
                }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tblcell", for: indexPath) as! TableTVC
        
        var data:[String:Any] = arr[indexPath.row] as! [String : Any]
        
        cell.tno.text = data["tableno"] as? String
        cell.tdesc.text = data["tabledesc"] as? String
        cell.tcap.text = data["tablecapacity"] as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let xindex:Int = indexPath.row
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            print("share button tapped")
            PKHUD.sharedHUD.contentView = PKHUDProgressView()
            PKHUD.sharedHUD.show()
            self.deletecell(id: self.tabelid[xindex])
        }
        
        delete.backgroundColor = UIColor.lightGray
        
        return [delete]
    }
    
    func deletecell(id:String){
        self.db.collection("tables").document(id).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
                self.loadData()
                self.tableview.reloadData()
                PKHUD.sharedHUD.hide(afterDelay: 1.0) { succ in
                    HUD.flash(.success, delay: 1.0)
                }
            }
        }
    }

}
