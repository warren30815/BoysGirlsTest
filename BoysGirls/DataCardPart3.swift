//
//  DataCardPart3.swift
//  BoysGirls
//
//  Created by 許竣翔 on 2018/7/5.
//  Copyright © 2018年 許竣翔. All rights reserved.
//

import UIKit

class DataCardPart3: UIViewController {

    @IBOutlet weak var Aboutme: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func nextpage(_ sender: UIButton) {
        if Aboutme.text != nil{
            UserDefaults.standard.set(Aboutme.text, forKey: "datacardaboutme")
            performSegue(withIdentifier: "3to4", sender: nil)
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
