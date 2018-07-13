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
    
    var orderimgarray = [String]()
    var memberimgarray = ["1","2","3","4"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.MemberCollectionView.dragInteractionEnabled = true
        self.MemberCollectionView.dragDelegate = self
        self.MemberCollectionView.dropDelegate = self
        
        self.OrderCollectionView.dragInteractionEnabled = true
        self.OrderCollectionView.dropDelegate = self
        self.OrderCollectionView.dragDelegate = self
        self.OrderCollectionView.reorderingCadence = .fast //default value - .immediate
        // Do any additional setup after loading the view.
    }
    
    func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView)
    {
        let items = coordinator.items
        if items.count == 1, let item = items.first, let sourceIndexPath = item.sourceIndexPath
        {
            var dIndexPath = destinationIndexPath
            if dIndexPath.row >= collectionView.numberOfItems(inSection: 0)
            {
                dIndexPath.row = collectionView.numberOfItems(inSection: 0) - 1
            }
            collectionView.performBatchUpdates({
                if collectionView === self.OrderCollectionView
                {
                    self.orderimgarray.remove(at: sourceIndexPath.row)
                    self.orderimgarray.insert(item.dragItem.localObject as! String, at: dIndexPath.row)
                }
                else
                {
                    self.memberimgarray.remove(at: sourceIndexPath.row)
                    self.memberimgarray.insert(item.dragItem.localObject as! String, at: dIndexPath.row)
                }
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [dIndexPath])
            })
            coordinator.drop(items.first!.dragItem, toItemAt: dIndexPath)
        }
    }
    
    func copyItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView)
    {
        collectionView.performBatchUpdates({
            var indexPaths = [IndexPath]()
            for (index, item) in coordinator.items.enumerated()
            {
                let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)
                if collectionView === self.OrderCollectionView
                {
                    self.orderimgarray.insert(item.dragItem.localObject as! String, at: indexPath.row)
                }
                else
                {
                    self.memberimgarray.insert(item.dragItem.localObject as! String, at: indexPath.row)
                }
                indexPaths.append(indexPath)
            }
            collectionView.insertItems(at: indexPaths)
        })
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

// MARK: - UICollectionViewDragDelegate Methods
extension ChooseMrRightView : UICollectionViewDragDelegate
{
    // Drag過程中實際傳輸的數據
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem]
    {
        let item = collectionView == MemberCollectionView ? self.memberimgarray[indexPath.row] : self.orderimgarray[indexPath.row]
        let itemProvider = NSItemProvider(object: item as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
//    // 多選用
//    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem]
//    {
//        let item = collectionView == MemberCollectionView ? self.memberimgarray[indexPath.row] : self.orderimgarray[indexPath.row]
//        let itemProvider = NSItemProvider(object: item as NSString)
//        let dragItem = UIDragItem(itemProvider: itemProvider)
//        dragItem.localObject = item
//        return [dragItem]
//    }
    // 長按時cell變化的形狀
    func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters?
    {
        if collectionView == MemberCollectionView
        {

            let previewParameters = UIDragPreviewParameters()
            let cell = collectionView.cellForItem(at: indexPath)
            let point = cell?.contentView.center
            previewParameters.visiblePath = UIBezierPath(arcCenter: point!, radius: 20, startAngle: 0, endAngle: CGFloat(Double.pi*2), clockwise: true)
            return previewParameters
        }
        return nil
    }
}

// MARK: - UICollectionViewDropDelegate Methods
extension ChooseMrRightView : UICollectionViewDropDelegate
{
    // 見官方文檔 https://developer.apple.com/documentation/uikit/drag_and_drop/making_a_view_into_a_drop_destination
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool
    {
        return session.canLoadObjects(ofClass: NSString.self)
    }
    // 拖曳完成後的更新行為(移動：.move，複製：.copy，禁止：.forbidden)
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal
    {
        if collectionView === self.MemberCollectionView
        {
            if collectionView.hasActiveDrag
            {
                return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            }
            else
            {
                return UICollectionViewDropProposal(operation: .forbidden)
            }
        }
        else
        {
            if collectionView.hasActiveDrag
            {
                return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            }
            else
            {
                return UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
            }
        }
    }
    // Coordinator有一個destinationIndexPath屬性可以告訴我們用戶想把數據拖放到哪裡
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator)
    {
        let destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath
        {
            destinationIndexPath = indexPath
        }
        else
        {
            // Get last index path of table view.
            let section = collectionView.numberOfSections - 1
            let row = collectionView.numberOfItems(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }
        
        switch coordinator.proposal.operation
        {
            case .move:
                self.reorderItems(coordinator: coordinator, destinationIndexPath:destinationIndexPath, collectionView: collectionView)
                break
            
            case .copy:
                self.copyItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
            
            default:
                return
        }
    }
}

