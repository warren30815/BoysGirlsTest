//
//  Setting.swift
//  BoysGirls
//
//  Created by 許竣翔 on 2018/7/9.
//  Copyright © 2018年 許竣翔. All rights reserved.
//

import UIKit
import Alamofire

class Setting: UIViewController {

    @IBOutlet weak var profile_picture: UIImageView!
    let userdefault = UserDefaults.standard
    var login_way: String!
    var uid: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        login_way = userdefault.string(forKey: "login_way")
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if login_way == "FB"{
            let FB_ID = self.userdefault.string(forKey: "FB_ID")
            let url = "https://graph.facebook.com/" + FB_ID! + "/picture?width=400&height=400"
            Alamofire.request(url).responseJSON { (response) in
                self.profile_picture.image = UIImage(data: response.data!)
            }
        }else{
            let url = self.userdefault.string(forKey: "Google_profile_picture") ?? "https"
            Alamofire.request(URL(string: url)!).responseJSON { (response) in
                self.profile_picture.image = UIImage(data: response.data!)
            }
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
