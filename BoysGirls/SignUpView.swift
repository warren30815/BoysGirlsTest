//
//  SignUpView.swift
//  BoysGirls
//
//  Created by 許竣翔 on 2018/6/4.
//  Copyright © 2018年 許竣翔. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class SignUpView: UIViewController {

    @IBOutlet weak var Name: UITextField!
    // 性別
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Phone: UITextField!
    // 生日
    
    var uid: String!
    let userdefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uid = userdefault.string(forKey: "uid")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 這是前往LogInViewController的按鈕，但在到下一個ViewController之前，先「確認註冊資料填寫完畢」
    @IBAction func Confirm_Button_Tapped(_ sender: UIButton) {
        
        if Name.text != "" && Email.text != "" && Phone.text != ""{
            Database.database().reference(withPath: "ID/\(uid!)/Profile/Name").setValue(Name.text)
//            Database.database().reference(withPath: "ID/\(self.uid)/Profile/Gender").setValue(Gender.text)
            Database.database().reference(withPath: "ID/\(uid!)/Profile/Email").setValue(Email.text)
            Database.database().reference(withPath: "ID/\(uid!)/Profile/Phone").setValue(Phone.text)
            // 跳到主畫面，並設定為已註冊
            Database.database().reference(withPath: "ID/\(uid!)/Profile/Enrollment").setValue("Yes")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nextVC = storyboard.instantiateViewController(withIdentifier: "tabbar")
            self.present(nextVC, animated: true, completion: nil)
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

