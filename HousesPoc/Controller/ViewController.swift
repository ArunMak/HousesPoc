//
//  ViewController.swift
//  HousesPoc
//
//  Created by ArunMak on 30/09/18.
//  Copyright © 2018 ArunMak. All rights reserved.
//

import UIKit
import CoreData
import AMGrid
class ViewController: UIViewController {
    // MARK: Instance Variables
    let MyCollectionViewCellId: String = "ListCollectionViewCell"
    let gridCollectionViewCellId: String = "GridCollectionViewCell"
    var detailView:HouseDetailView!
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    var house: [NSManagedObject] = []
    
    // MARK: View life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         if Generics.sharedInstance.cellType {
            menuButton.setImage(UIImage(named: "menu.png"), for: .normal)
         }else{
             menuButton.setImage(UIImage(named: "grid.png"), for: .normal)
        }
         fetchAllHouses()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateDb), name: Notification.Name("UpdateDb"), object: nil)
        let nibCell = UINib(nibName: MyCollectionViewCellId, bundle: Bundle(for: ListCollectionViewCell.self))
        collectionView.register(nibCell, forCellWithReuseIdentifier: MyCollectionViewCellId)
        let nibGridCell = UINib(nibName: gridCollectionViewCellId, bundle: Bundle(for: GridCollectionViewCell.self))
        collectionView.register(nibGridCell, forCellWithReuseIdentifier: gridCollectionViewCellId)
       
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Menu ButtonAction
    @IBAction func saveButtonAction(_ sender: Any) {
        if Generics.sharedInstance.cellType {
            menuButton.setImage(UIImage(named: "grid.png"), for: .normal)
            Generics.sharedInstance.cellType = false
        }else{
            menuButton.setImage(UIImage(named: "menu.png"), for: .normal)
            Generics.sharedInstance.cellType = true
        }
        collectionView.reloadData()
    }
    
    // MARK: Notifiation center delegate method
    @objc func updateDb(notification: Notification) {
        fetchAllHouses()
        // Take Action on Notification
    }
    
    func fetchAllHouses(){
        if CoreDataManager.sharedManager.fetchAllHouses() != nil{
            house = CoreDataManager.sharedManager.fetchAllHouses()!
        }
         collectionView.reloadData()
    }
    
    // MARK: Orientation method
     func shouldAutorotate() -> Bool {
        // Lock autorotate
        return false
    }
    
     func supportedInterfaceOrientations() -> Int {
        
        // Only allow Portrait
        return Int(UIInterfaceOrientationMask.portrait.rawValue)
    }
    
     func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        
        // Only allow Portrait
        return UIInterfaceOrientation.portrait
    }

}

// MARK: Collection View datasource
extension ViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return house.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let houseObj  = house[indexPath.row]
        print(houseObj)
        if Generics.sharedInstance.cellType {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCellId, for: indexPath) as! ListCollectionViewCell
            cell.houseNameLbl.text = houseObj.value(forKey: "houseName") as? String
            cell.houseDescLbl.text = houseObj.value(forKeyPath: "houseDesc") as? String
            cell.houseImageView.image = UIImage(named: (houseObj.value(forKeyPath: "houseImage") as? String)!)
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: gridCollectionViewCellId, for: indexPath) as! GridCollectionViewCell
            cell.houseNameLbl.text = houseObj.value(forKeyPath: "houseName") as? String
            cell.houseImageView.image = UIImage(named: (houseObj.value(forKeyPath: "houseImage") as? String)!)
            if (houseObj.value(forKeyPath: "favourite") as? Bool)! {
                cell.favouriteImageView.isHidden = false
            }else{
                 cell.favouriteImageView.isHidden = true
            }
           // cell.backgroundColor = UIColor.blue
            return cell
        }
    }
        
    
}
// MARK: Collection View Delegate Methods
extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let houseObj  = house[indexPath.row]
         print(houseObj)
        detailView = HouseDetailView(house: houseObj as! Houses)
        UIApplication.shared.keyWindow!.addSubview(detailView)
        UIApplication.shared.keyWindow!.bringSubview(toFront: detailView)
        
    }
}
// MARK: Collection View Flow layout methods
extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        print((collectionView.bounds.size.width/3))
        print(self.view.frame.size.width)
        if Generics.sharedInstance.cellType{
            return CGSize.init(width: UIScreen.main.bounds.width - 20, height: 80)
        }else{
            return CGSize(width: (collectionView.bounds.size.width/3), height: (collectionView.bounds.size.width/3))
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        if  Generics.sharedInstance.cellType {
            let inset = 10
            return UIEdgeInsetsMake(CGFloat(inset), CGFloat(inset), CGFloat(inset), CGFloat(inset))
        }else{
            return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    
    
    
}




