//
//  DataCardPart1.swift
//  BoysGirls
//
//  Created by 許竣翔 on 2018/7/5.
//  Copyright © 2018年 許竣翔. All rights reserved.
//

import UIKit

class DataCardPart1: UIViewController {

    let userdefault = UserDefaults.standard
    @IBOutlet weak var school: UITextField!
    @IBOutlet weak var department: UITextField!
    @IBOutlet weak var height: UITextField!
    @IBOutlet weak var weight: UITextField!
    @IBOutlet weak var age: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    @IBAction func nextpage(_ sender: UIButton) {
        if school.text != "" ||
            department.text != "" ||
            height.text != "" ||
            weight.text != "" ||
            age.text != ""{
                userdefault.set(school.text, forKey: "datacardschool")
                userdefault.set(department.text, forKey: "datacarddepartment")
                userdefault.set(height.text, forKey: "datacardheight")
                userdefault.set(weight.text, forKey: "datacardweight")
                userdefault.set(age.text, forKey: "datacardage")
            performSegue(withIdentifier: "1to2", sender: nil)

        }else{
            let AlertController = UIAlertController(title: "未完成", message: "請輸入所有欄位", preferredStyle: .alert)
            let action = UIAlertAction(title: "確認", style: .default) { (Void) in
            }
            AlertController.addAction(action)
            present(AlertController, animated: true, completion: nil)
        }
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
