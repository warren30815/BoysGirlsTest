//
//  PreviewDataCard.swift
//  BoysGirls
//
//  Created by 許竣翔 on 2018/7/5.
//  Copyright © 2018年 許竣翔. All rights reserved.
//

import UIKit

class PreviewDataCard: UIViewController {

    let userdefault = UserDefaults.standard
    var school: String!
    var departmant: String!
    var height: String!
    var weight: String!
    var age: String!
    var photo: [Data]!
    var aboutme: String!
    var like: String!
    var hope: String!
    
    @IBOutlet weak var Presentphoto: UIImageView!
    @IBOutlet weak var Presentschool: UILabel!
    @IBOutlet weak var Presentdepartment: UILabel!
    @IBOutlet weak var Presentheight: UILabel!
    @IBOutlet weak var Presentweight: UILabel!
    @IBOutlet weak var Presentage: UILabel!
    @IBOutlet weak var Presentaboutme: UITextView!
    @IBOutlet weak var Presentlike: UITextView!
    @IBOutlet weak var Presenthope: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        school = userdefault.string(forKey: "datacardschool")
        departmant = userdefault.string(forKey: "datacarddepartment")
        height = userdefault.string(forKey: "datacardheight")
        weight = userdefault.string(forKey: "datacardweight")
        age = userdefault.string(forKey: "datacardage")
        aboutme = userdefault.string(forKey: "datacardaboutme")
        like = userdefault.string(forKey: "datacardlike")
        hope = userdefault.string(forKey: "datacardhope")
        photo = userdefault.object(forKey: "datacardphoto") as! [Data]
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Presentphoto.image = UIImage(data: photo[0])
        Presentschool.text = school
        Presentdepartment.text = departmant
        Presentheight.text = height
        Presentweight.text = weight
        Presentage.text = age
        Presentaboutme.text = aboutme
        Presentlike.text = like
        Presenthope.text = hope
        Presentaboutme.isEditable = false
        Presentlike.isEditable = false
        Presenthope.isEditable = false
    }
    
    @IBAction func Back(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Submit(_ sender: UIButton) {
        let AlertController = UIAlertController(title: "確認資料無誤", message: "送出後就不能再修改囉", preferredStyle: .alert)
        let action = UIAlertAction(title: "送出", style: .default) { (Void) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nextView = storyboard.instantiateViewController(withIdentifier: "tabbar")
            self.present(nextView,animated:true,completion:nil)
        }
        let cancel = UIAlertAction(title: "取消", style: .destructive, handler: nil)
        AlertController.addAction(action)
        AlertController.addAction(cancel)
        present(AlertController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
