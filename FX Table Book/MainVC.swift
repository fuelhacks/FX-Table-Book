//
//  MainVC.swift
//  FX Table Book
//
//  Created by Shripal Jain on 12/02/18.
//  Copyright © 2018 shripaljain. All rights reserved.
//

import UIKit
import SideMenu
import Firebase
import PKHUD
import CNPPopupController

class MainVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource{
    
    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBOutlet weak var donebtn: UIBarButtonItem!
    @IBOutlet weak var pickerview: UIPickerView!
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var totaltb: UILabel!
    @IBOutlet weak var inqueue: UILabel!
    @IBOutlet weak var occ: UILabel!
    var popupController:CNPPopupController?
    
    let db = Firestore.firestore()
    
    var arr1 = [[String:Any]]()
    var arr2 = [[String:Any]]()
    var docid1 = [String]()
    var docid2 = [String]()
    var tables = [[String:Any]]()
    var tablesid = [String]()
    
    var currenttabid = ""
    var currenttabno = ""
    var currenttabstr = ""
    var currentuser = ""

    let sections = ["Allocated", "Queue"]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        pickerview.delegate = self
        pickerview.dataSource = self
        pickerview.showsSelectionIndicator = true
        setupSideMenu()
        reloaddb()
        tableview.reloadData()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        reloaddb()
        tableview.reloadData()
        PKHUD.sharedHUD.hide(afterDelay: 1.0) { succ in
        }
        
    }
    
    
    
    func listensnaps(){
        db.collection("waitinglist").whereField("status", isEqualTo: 1)
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                self.occ.text = "\((querySnapshot?.documents.count)!)"
                self.arr1 = [[String:Any]]()
                self.docid1 = [String]()
                for i in 0..<documents.count{
                        self.arr1.append(documents[i].data())
                        self.docid1.append(documents[i].documentID)
                    print(documents[i].documentID);
                }
                self.tableview.reloadSections( [0], with: .automatic)
                
        }
        
        self.db.collection("waitinglist").whereField("status", isEqualTo: -1).order(by: "tokenno")
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                self.inqueue.text = "\((querySnapshot?.documents.count)!)"
                self.arr2 = [[String:Any]]()
                self.docid2 = [String]()
                for i in 0..<documents.count{
                    self.arr2.append(documents[i].data())
                    self.docid2.append(documents[i].documentID)
                    print(documents[i].documentID);
                }
                
                self.tableview.reloadSections( [1], with: .automatic)
        }
        
        
        db.collection("tables")
            .addSnapshotListener { querySnapshot, error in
                guard (querySnapshot?.documents) != nil else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                self.totaltb.text = "\((querySnapshot?.documents.count)!)"
                
        }
    }
    
    func reloaddb(){
        db.collection("waitinglist").whereField("status", isEqualTo: 1).order(by: "tableno").getDocuments
            { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                self.occ.text = "\((querySnapshot?.documents.count)!)"
                self.arr1 = [[String:Any]]()
                self.docid1 = [String]()
                for i in 0..<documents.count{
                    self.arr1.append(documents[i].data())
                    self.docid1.append(documents[i].documentID)
                    print(documents[i].documentID);
                }
                self.tableview.reloadSections( [0], with: .automatic)
                
        }
        
        self.db.collection("waitinglist").whereField("status", isEqualTo: -1).order(by: "tokenno").getDocuments{ querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                self.inqueue.text = "\((querySnapshot?.documents.count)!)"
                self.arr2 = [[String:Any]]()
                self.docid2 = [String]()
                for i in 0..<documents.count{
                    self.arr2.append(documents[i].data())
                    self.docid2.append(documents[i].documentID)
                    print(documents[i].documentID);
                }
                
                self.tableview.reloadSections( [1], with: .automatic)
        }
        
        db.collection("tables").getDocuments{ querySnapshot, error in
            guard (querySnapshot?.documents) != nil else {
                print("Error fetching documents: \(error!)")
                return
            }
            self.totaltb.text = "\((querySnapshot?.documents.count)!)"
        }
        
        db.collection("tables").whereField("occ", isEqualTo: false).getDocuments{ querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
           
            self.tables = [[String:Any]]()
            self.tablesid = [String]()
            
            
            
            for i in 0..<documents.count{
                self.tables.append(documents[i].data())
                self.tablesid.append(documents[i].documentID)
                
            }
            
            if(documents.count>0){
                let tbc = self.tables[0]
                self.currenttabid = self.tablesid[0]
                self.currenttabno = tbc["tableno"] as! String
                
                let lbl = tbc["tableno"] as! String
                let cap = tbc["tablecapacity"] as! String
                self.currenttabstr = "Table No \(lbl) / Capacity \(cap)"
            }
            self.pickerview.reloadAllComponents()
            
        }
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupSideMenu()
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        
        reloaddb()
        
    }

    @IBAction func openmenu(_ sender: Any) {
        performSegue(withIdentifier: "menusegue", sender: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    fileprivate func setupSideMenu() {
        // Define the menus
        SideMenuManager.default.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
        
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuFadeStatusBar = false
        
    }
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return arr1.count
        }
        else{
            return arr2.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section]
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "maincell", for: indexPath) as! MainTVC
        if(indexPath.section == 0){
            let data = arr1[indexPath.row];
            cell.msg.setTitle("Table No", for: .normal)
            cell.custname.text = (data["name"] as? String)?.capitalized
            cell.custmobile.text = data["mobile"] as? String
            var mob = data["mobile"] as? String
            var nop:String = ""
            nop = data["nop"]! as! String
            cell.nop.text = "\(nop) Person"
            cell.allotedtb.text = data["tableno"] as? String
            cell.callbtn.tag = Int(mob!)!
        }
        if(indexPath.section == 1){
            let data = arr2[indexPath.row]
            print(data)
            cell.msg.setTitle("Token", for: .normal)
            cell.custname.text = (data["name"] as? String)?.capitalized;
            cell.custmobile.text = data["mobile"] as? String
            var nop:String = ""
            nop = data["nop"]! as! String
            cell.nop.text = "\(nop) Person"
            
            var tn:Int = 0
            tn = data["tokenno"]! as! Int
            cell.allotedtb.text = "\(tn) "
           // cell.allotedtb.text = data["tokenno"] as? String
            var mob = data["mobile"] as? String
            cell.callbtn.tag = Int(mob!)!
        }
        
        
        
        
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func reloadfreetable(id:String){
        
        db.collection("tables").whereField("occ", isEqualTo: false).getDocuments{ querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            
            self.tables = [[String:Any]]()
            self.tablesid = [String]()
            for i in 0..<documents.count{
                self.tables.append(documents[i].data())
                self.tablesid.append(documents[i].documentID)
            }
            self.pickerview.reloadAllComponents()
            if(documents.count>0){
            self.pickerview.alpha = 1
            self.toolbar.alpha = 1
            }
            else{
                self.showPopupWithStyle(CNPPopupStyle.centered,_heading: "No Free Tables",_error:"At the moment all the tables are preoccupied", _icon: "error")
            }
            
        }
        
        
        currentuser = id
    }
        
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        var xindex:Int = indexPath.row
        if(indexPath.section == 1){
            let allottable = UITableViewRowAction(style: .normal, title: "Allot Table") { action, index in
                
                self.reloadfreetable(id: self.docid2[xindex])
                
                
            }
            allottable.backgroundColor = UIColor.darkGray
            
            let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
                print("share button tapped")
                PKHUD.sharedHUD.contentView = PKHUDProgressView()
                PKHUD.sharedHUD.show()
                self.deletecell(id: self.docid2[xindex])
            }
            
            delete.backgroundColor = UIColor.lightGray
            
            return [allottable, delete]
        }
        else{
            
            let doneeating = UITableViewRowAction(style: .normal, title: "Done Eating!") { action, index in
                
                PKHUD.sharedHUD.contentView = PKHUDProgressView()
                PKHUD.sharedHUD.show()
                self.doneating(id: self.docid1[xindex], tbid: self.arr1[xindex]["tableid"] as! String)
                
            }
            doneeating.backgroundColor = UIColor.lightGray
            
            
            return [ doneeating]
        }
        
        
        
    }
        
    func deletecell(id:String?){
        self.db.collection("waitinglist").document(id!).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                    self.reloaddb()
                    self.tableview.reloadData()
                    PKHUD.sharedHUD.hide(afterDelay: 1.0) { succ in
                        HUD.flash(.success, delay: 1.0)
                    }
                }
            }
            
            
    }
    
    func allottabel(id:String, tableid:String){
        
    }
    
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tables.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let tbc = self.tables[row]
        let lbl = tbc["tableno"] as! String
        let cap = tbc["tablecapacity"] as! String
        return "Table No \(lbl) / Capacity \(cap)";
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let tbc = self.tables[row]
        self.currenttabid = tablesid[row]
        self.currenttabno = tbc["tableno"] as! String
    
        let lbl = tbc["tableno"] as! String
        let cap = tbc["tablecapacity"] as! String
        currenttabstr = "Table No \(lbl) / Capacity \(cap)"
    }
    
    @IBAction func canceldone(_ sender: Any) {
        pickerview.alpha = 0
        toolbar.alpha = 0
    }
    
    @IBAction func selecttable(_ sender: Any) {
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        pickerview.alpha = 0
        toolbar.alpha = 0
        
        print(currenttabid);
        let tblref = db.collection("tables").document(currenttabid)
        
        // Set the "capital" field of the city 'DC'
        tblref.updateData([
            "occ": true
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        
        let userref = db.collection("waitinglist").document(currentuser)
        
        userref.updateData([
            "status": 1,
            "tableno": currenttabno,
            "tableid" : currenttabid
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
                
            }
        }

        PKHUD.sharedHUD.hide(afterDelay: 1.0) { succ in
            self.reloaddb()
            HUD.flash(.success, delay: 1.0)
            
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
    
    func doneating(id:String,tbid:String){
        print("DE")
        print(id)
        print(tbid)
        let tblref = db.collection("tables").document(tbid)
        
        // Set the "capital" field of the city 'DC'
        tblref.updateData([
            "occ": false
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        
        db.collection("waitinglist").document(id).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        
        PKHUD.sharedHUD.hide(afterDelay: 1.0) { succ in
            self.reloaddb()
            HUD.flash(.success, delay: 1.0)
            
        }
        
        
    }
    
}
    
    
    
    
    
    



