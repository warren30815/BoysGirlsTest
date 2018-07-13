//
//  DataCardPart2.swift
//  BoysGirls
//
//  Created by 許竣翔 on 2018/7/5.
//  Copyright © 2018年 許竣翔. All rights reserved.
//

import UIKit
import Photos
import BSImagePicker

class DataCardPart2: UIViewController {
    
    @IBOutlet weak var imagevie: UIImageView!
    
    var SelectedAssets = [PHAsset]()
    var PhotoArray = [UIImage]()
    var PhotoData = [Data]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        leftSwipe.direction = .left
        self.imagevie.addGestureRecognizer(leftSwipe)
        
    }

    @objc func swipeAction(swipe: UISwipeGestureRecognizer){
        print("qqqq")
    }
    func convertAssetToImages() -> Void {
        
        if SelectedAssets.count != 0{
            
            
            for i in 0 ..< SelectedAssets.count{
                
                let manager = PHImageManager.default()
                let option = PHImageRequestOptions()
                var thumbnail = UIImage()
                option.isSynchronous = true
                
                
                manager.requestImage(for: SelectedAssets[i], targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: option, resultHandler: {(result, info)->Void in
                    thumbnail = result!
                })
                
//                let data = UIImageJPEGRepresentation(thumbnail, 0.7)
//                let newImage = UIImage(data: data!)
                let newImage = compressImage(thumbnail, toByte: 100 * 1024)
                self.PhotoArray.append(newImage)
                
            }
            
        }
        DispatchQueue.main.async {
            self.imagevie.image = self.PhotoArray[0]
        }
//        self.imagevie.animationImages = self.PhotoArray
//        self.imagevie.animationDuration = 10
//        self.imagevie.startAnimating()
        print("complete photo array \(self.PhotoArray)")
    }
    
    func compressImage(_ image: UIImage, toByte maxLength: Int) -> UIImage {
        var compression: CGFloat = 1
        guard var data = UIImageJPEGRepresentation(image, compression),
            data.count > maxLength else { return image }
        print("Before compressing quality, image size =", data.count / 1024, "KB")
        
        // Compress by size
        var max: CGFloat = 1
        var min: CGFloat = 0
        for _ in 0 ..< 6 {
            compression = (max + min) / 2
            data = UIImageJPEGRepresentation(image, compression)!
            print("Compression =", compression)
            print("In compressing quality loop, image size =", data.count / 1024, "KB")
            if CGFloat(data.count) < CGFloat(maxLength) * 0.9 {
                min = compression
            } else if data.count > maxLength {
                max = compression
            } else {
                break
            }
        }
        print("After compressing quality, image size =", data.count / 1024, "KB")
        var resultImage: UIImage = UIImage(data: data)!
        if data.count < maxLength { return resultImage }
        
        // Compress by size
        var lastDataLength: Int = 0
        while data.count > maxLength, data.count != lastDataLength {
            lastDataLength = data.count
            let ratio: CGFloat = CGFloat(maxLength) / CGFloat(data.count)
            print("Ratio =", ratio)
            let size: CGSize = CGSize(width: Int(resultImage.size.width * sqrt(ratio)),
                                      height: Int(resultImage.size.height * sqrt(ratio)))
            UIGraphicsBeginImageContext(size)
            resultImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            resultImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            data = UIImageJPEGRepresentation(resultImage, compression)!
            print("In compressing size loop, image size =", data.count / 1024, "KB")
        }
        print("After compressing size loop, image size =", data.count / 1024, "KB")
        self.PhotoData.append(data)
        return resultImage
    }
    
    @IBAction func selectPhoto(_ sender: UIButton) {
        let vc = BSImagePickerViewController()
        vc.maxNumberOfSelections = 4
        vc.selectionCharacter = "✓"
        self.bs_presentImagePickerController(vc, animated: true,
                                             select: { (asset: PHAsset) -> Void in
                                                // User selected an asset.
                                                // Do something with it, start upload perhaps?
        }, deselect: { (asset: PHAsset) -> Void in
            // User deselected an assets.
            // Do something, cancel upload?
        }, cancel: { (assets: [PHAsset]) -> Void in
            // User cancelled. And this where the assets currently selected.
        }, finish: { (assets: [PHAsset]) -> Void in
            // User finished with these assets
            for i in 0 ..< assets.count
            {
                self.SelectedAssets.append(assets[i])
            }
            
            self.convertAssetToImages()
        }, completion: nil)
    }
    
    
    @IBAction func nextpage(_ sender: UIButton) {
        UserDefaults.standard.set(PhotoData, forKey: "datacardphoto")
        performSegue(withIdentifier: "2to3", sender: nil)
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


extension SignUpView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        // 取得從 UIImagePickerController 選擇的檔案
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            selectedImageFromPicker = pickedImage
        }
        
        // 可以自動產生一組獨一無二的 ID 號碼，方便等一下上傳圖片的命名
        let uniqueString = NSUUID().uuidString
        
        
//        if let user = Auth.auth().currentUser {
//            uid = user.uid
        
            // 當判斷有 selectedImage 時，我們會在 if 判斷式裡將圖片上傳
            if let selectedImage = selectedImageFromPicker {
                
                
//                let storageRef = Storage.storage().reference().child("\(uniqueString).png")
                
                if let uploadData = UIImagePNGRepresentation(selectedImage) {
                    // 這行就是 FirebaseStorage 關鍵的存取方法。
//                    storageRef.putData(uploadData, metadata: nil, completion: { (data, error) in
//                        print("put ing")
//                        if error != nil {
//                            print("無法putdata嗚嗚嗚嗚")
//                            // 若有接收到錯誤，我們就直接印在 Console 就好，在這邊就不另外做處理。
//                            print("Error: \(error!.localizedDescription)")
//                            return
//                        }
//                        print("putdata ok")
//                        // 連結取得方式就是：data?.downloadURL()?.absoluteString。
//                        storageRef.downloadURL(completion: { (url, error) in
//
//                            // 我們可以 print 出來看看這個連結事不是我們剛剛所上傳的照片。
//                            print("Photo Url: \(String(describing: url))")
//
//                            // 存放在database
//                            let databaseRef = Database.database().reference(withPath: "ID/\(self.uid)/Profile/Photo")
//                            databaseRef.setValue(url?.absoluteString, withCompletionBlock: { (error, dataRef) in
//
//                                if error != nil {
//                                    print("無法存嗚嗚嗚嗚")
//                                    print("Database Error: \(error!.localizedDescription)")
//                                }
//                                else {
//
//                                    print("圖片已儲存")
//                                }
//
//                            })
                    
                            
//                        })
//                    })
                }
            }
            dismiss(animated: true, completion: nil)
            
            
//        }
        
        
    }
    
}
