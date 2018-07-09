//
//  LoginView.swift
//  BoysGirls
//
//  Created by 許竣翔 on 2018/6/4.
//  Copyright © 2018年 許竣翔. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FBSDKLoginKit
import GoogleSignIn

class LoginView: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate {

    var uid = ""
    let userdefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func FBloginButton(_ sender: UIButton) {
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email","user_friends"], from: self) { (result, error) in
            
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            // Perform login by calling Firebase APIs
            Auth.auth().signInAndRetrieveData(with: credential, completion: { (authresult, error) in
                if error == nil{
                    self.userdefault.set(authresult?.user.uid, forKey: "uid")
                    self.userdefault.set("FB", forKey: "login_way")
                    if let profile = authresult?.additionalUserInfo?.profile{
                        if let picture = profile["picture"] as? NSDictionary,
                            let data = picture["data"] as? NSDictionary,
                            let url = data["url"] as? String{
                            print("profile",profile)
                        }
                    }
//                    self.userdefault.set(authresult?.additionalUserInfo?.profile, forKey: "profile_picture")
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let nextVC = storyboard.instantiateViewController(withIdentifier: "tabbar")
                    self.present(nextVC,animated:true,completion:nil)
                }else{
                    return
                }
            })
        }
    }
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
//        fetchProfile()
        if error == nil{
            userdefault.set("FB", forKey: "login_way")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nextVC = storyboard.instantiateViewController(withIdentifier: "tabbar")
            self.present(nextVC,animated:true,completion:nil)
        }
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("logout")
    }
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
    @IBAction func GoogleLoginButton(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
        let queue = OperationQueue()
        queue.addOperation {
            while(true){
                let nextVC = self.userdefault.object(forKey: "nextVC")
                if nextVC != nil{
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let nextView = storyboard.instantiateViewController(withIdentifier: "tabbar")
                    self.present(nextView,animated:true,completion:nil)
                    queue.cancelAllOperations()
                    break
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension UIViewController{
    
    func fetchProfile(){
        print("attempt to fetch profile......")
        
        let parameters = ["fields": "email, name, picture.type(large)"]
        
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start(completionHandler: {
            connection, result, error -> Void in
            
            if error != nil {
                print("登入失敗")
                print("longinerror =\(error)")
            } else {
                
                if let resultNew = result as? [String:Any]{
                    
                    print("成功登入")
                    let email = resultNew["email"]  as! String
                    print(email)
                    let Name = resultNew["name"] as! String
                    print(Name)
                    
                    if let picture = resultNew["picture"] as? NSDictionary,
                        let data = picture["data"] as? NSDictionary,
                        let url = data["url"] as? String {
                        print(url) //臉書大頭貼的url, 再放入imageView內秀出來
                    }
                }
            }
        })
    }
}
