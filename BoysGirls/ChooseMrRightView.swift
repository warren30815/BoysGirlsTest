//
//  ChooseMrRightView.swift
//  BoysGirls
//
//  Created by 許竣翔 on 2018/6/25.
//  Copyright © 2018年 許竣翔. All rights reserved.
//

import UIKit

class ChooseMrRightView: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {

    @IBOutlet weak var OrderCollectionView: UICollectionView!
    @IBOutlet weak var MemberCollectionView: UICollectionView!
    
    var orderimgarray = ["1","2","3","4"]
    var memberimgarray = ["4","3","2","1"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == OrderCollectionView{
            return orderimgarray.count
        }
        return memberimgarray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == OrderCollectionView{
            let cell = OrderCollectionView.dequeueReusableCell(withReuseIdentifier: "order", for: indexPath) as! ChooseMrRightCollectionViewCell
            cell.OrderListimg.image = UIImage(named: orderimgarray[indexPath.row])
            return cell
        }else{
            let cell = MemberCollectionView.dequeueReusableCell(withReuseIdentifier: "member", for: indexPath) as! ChooseMrRightCollectionViewCell
            cell.MemberListimg.image = UIImage(named: memberimgarray[indexPath.row])
            return cell
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
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
