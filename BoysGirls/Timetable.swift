//
//  Timetable.swift
//  BoysGirls
//
//  Created by 許竣翔 on 2018/7/4.
//  Copyright © 2018年 許竣翔. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn

class Timetable: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let userdefault = UserDefaults.standard
    var event = ["報名","姊妹優惠","資料卡"]
    var uid: String!
    // 用來比對是否超過日期
    let date = Date()
    var calendar = Calendar.current

    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uid = userdefault.string(forKey: "uid")
        calendar.timeZone = TimeZone(identifier: "Asia/Taipei")!
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return event.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "timetable", for: indexPath) as! TimetableCell
        cell.time.text = event[indexPath.row]
        cell.status.image = UIImage(named: "circle")
        cell.content.text = event[indexPath.row]
//        cell.selectionStyle = .none
        return cell
    }
    // 讓某些row無法選取，用控制變數去當作條件式
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.row != 0{
            return nil
        }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nextView = storyboard.instantiateViewController(withIdentifier: "ChooseArea")
            navigationController?.pushViewController(nextView, animated: true)
        }else{
            
        }
    }
    
    @IBAction func Logout(_ sender: UIBarButtonItem) {
        do{
            try Auth.auth().signOut()
            FBSDKLoginManager().logOut()
            GIDSignIn.sharedInstance().signOut()
            print("Logout")
            userdefault.set("No", forKey: "login_way")
            userdefault.removeObject(forKey: "nextVC")
            userdefault.removeObject(forKey: "if_signup")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nextVC = storyboard.instantiateViewController(withIdentifier: "LoginVC")
            self.present(nextVC,animated:true,completion:nil)
        }catch{
            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
