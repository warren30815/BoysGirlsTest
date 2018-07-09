//
//  ConfirmView.swift
//  BoysGirls
//
//  Created by 許竣翔 on 2018/6/4.
//  Copyright © 2018年 許竣翔. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class ConfirmView: UIViewController {

    var uid = ""
    @IBOutlet weak var loadImage: UIImageView!
    @IBOutlet weak var name_check: UILabel!
    @IBOutlet weak var gender_check: UILabel!
    @IBOutlet weak var email_check: UILabel!
    @IBOutlet weak var phone_check: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = Auth.auth().currentUser {
            uid = user.uid
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func viewDetail(_ sender: UIButton) {
        
        // 指 ref 是 firebase中的特定路徑，導引到特定位置，像是「FIRDatabase.database().reference(withPath: "ID/\(self.uid)/Profile/Name")」
        var ref: DatabaseReference
        
        //從database抓取url，再從storage下載圖片
        //先在database找到存放url的路徑
        ref = Database.database().reference(withPath: "ID/\(self.uid)/Profile/Photo")
        //observe 到 .value
        ref.observe(.value, with: { (snapshot) in
            //存放在這個 url
            let url = snapshot.value as! String
            
            let maxSize : Int64 = 15 * 1024 * 1024 //大小：15MB，可視情況改變
            
            //從Storage抓這個圖片
            Storage.storage().reference(forURL: url).getData(maxSize: maxSize, completion: { (data, error) in
                if error != nil {
                    print(error)
                    return
                }
                
                guard let imageData = UIImage(data: data!) else { return }
                
                //非同步的方式，load出來
                DispatchQueue.main.async {
                    self.loadImage.image = imageData
                }
                
                
            })
            
            
        })
        
        
        // 接下來也是很重要的一步，從Firebase拿取資料，並顯示為label(name, gender, email, phone)
        
        // 前面有個var ref，把這一串路徑除存在變數中
        ref = Database.database().reference(withPath: "ID/\(self.uid)/Profile/Name")
        
        // .observe 顧名思義就是「察看」的意思，也就是說ref.observe(.value)->查看「這串導引到特定位置的路徑」的value
        // snapshot只是一個代稱(習慣為snapshot)，通常搭配.value，是指「這串路徑下的值」
        ref.observe(.value, with: { (snapshot) in
            let name = snapshot.value as! String // 假設 name 是這串路徑下的值，
            // as! String 是因為下一行程式碼self.name_check.text為label，因此必須為String
            self.name_check.text = name // self.name_check.text這個label為上一行程式碼所假設的 name
            self.name_check.isHidden = false // 再把原本隱藏的顯示出來
        })
        
        
        // 下面就都一樣的意思，只是換成Gender、Email、Phone
        ref = Database.database().reference(withPath: "ID/\(self.uid)/Profile/Gender")
        ref.observe(.value, with: { (snapshot) in
            let gender = snapshot.value as! String
            self.gender_check.text = gender
            self.gender_check.isHidden = false
        })
        
        ref = Database.database().reference(withPath: "ID/\(self.uid)/Profile/Email")
        ref.observe(.value, with: { (snapshot) in
            let email = snapshot.value as! String
            self.email_check.text = email
            self.email_check.isHidden = false
        })
        
        ref = Database.database().reference(withPath: "ID/\(self.uid)/Profile/Phone")
        ref.observe(.value, with: { (snapshot) in
            let phone = snapshot.value as! String
            self.phone_check.text = phone
            self.phone_check.isHidden = false
        })
        
        
        
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
