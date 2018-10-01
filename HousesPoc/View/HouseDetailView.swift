//
//  HouseDetailView.swift
//  HousesPoc
//
//  Created by ArunMak on 30/09/18.
//  Copyright © 2018 ArunMak. All rights reserved.
//

import UIKit
import CoreData
import MapKit
class HouseDetailView: UIView {
    // MARK: Instance Variables
    var houseObj: Houses
    var contentView: UIView!
    var favourite: Bool?
    var detailScrollView: UIScrollView!
    let annotation = MKPointAnnotation()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    
    }
    // MARK: View Initialization
    init(house : Houses){
        self.houseObj = house
        favourite = houseObj.value(forKey: "favourite") as? Bool
        print("favouite is \(favourite!)")
        super.init(frame: UIScreen.main.bounds)
        setupView()
    }
  
    // MARK: Back Button
    var backButton: UIButton {
       let backButton = UIButton(frame: CGRect(x: 10, y: 10, width: 35, height: 35) )
       backButton.setImage(UIImage(named: "back.png"), for: .normal)
       backButton.addTarget(self, action: #selector(moveBack), for: .touchUpInside)
        return backButton
    }
   // MARK: ImageView Creation
    var houseImageView: UIImageView {
      let houseImageView = UIImageView(frame: CGRect(x: 0, y: 30, width: self.frame.size.width, height: 200))
        houseImageView.image = UIImage(named: (houseObj.value(forKeyPath: "houseImage") as? String)!)
        houseImageView.contentMode = UIViewContentMode.scaleAspectFit
        houseImageView.isUserInteractionEnabled = true
        houseImageView.addSubview(backButton)
        houseImageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        houseImageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return houseImageView
    }
    // MARK: FavouriteButton
    var favouriteButton: UIButton{
       let favouriteButton = UIButton(type:  .custom)
        favouriteButton.frame = CGRect(x: (self.frame.size.width/2)-100, y: houseImageView.frame.size.height+houseImageView.frame.origin.y+10, width: 200, height: 40)
        favouriteButton.tintColor = UIColor.white
        if  favourite!{
            favouriteButton.setTitle("favourite", for: .normal)
            favouriteButton.backgroundColor = UIColor.red
        }else{
            favouriteButton.setTitle("unfavourite", for: .normal)
            favouriteButton.backgroundColor = UIColor.green
        }
        favouriteButton.layer.borderWidth = 1.0
      //  favouriteButton.backgroundColor = UIColor.red //--> set the background color and check
        favouriteButton.layer.cornerRadius = 8.0
        favouriteButton.layer.borderColor = UIColor.white.cgColor
        favouriteButton.addTarget(self, action: #selector(favouriteAction(sender:)), for: .touchUpInside)
        return favouriteButton
    }
    
    var contentHeaderLbl: UILabel {
        let contentHeaderLbl = UILabel(frame: CGRect(x: 10, y: 10, width: (self.frame.size.width-20), height: 40))
        contentHeaderLbl.text = String(format: "%@  %@", houseObj.value(forKeyPath: "houseId") as! CVarArg,houseObj.value(forKeyPath: "houseName") as! CVarArg)
        contentHeaderLbl.textAlignment = NSTextAlignment.center
        return contentHeaderLbl
    }
    
    var contentDescriptionLbl: UILabel {
        print( houseObj.value(forKey: "favourite") as Any )
        let contentDescriptionLbl = UILabel(frame: CGRect(x: contentHeaderLbl.frame.origin.x, y: contentHeaderLbl.frame.origin.y+contentHeaderLbl.frame.size.height+10, width: contentHeaderLbl.frame.size.width, height: self.heightForView(text: (houseObj.value(forKey: "houseDesc") as? String)!, font: contentHeaderLbl.font, width: contentHeaderLbl.frame.size.width)+20))
        contentDescriptionLbl.text = houseObj.value(forKey: "houseDesc") as? String
        contentDescriptionLbl.numberOfLines = 0
        contentDescriptionLbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        contentDescriptionLbl.sizeToFit()
        return contentDescriptionLbl
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame:CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
    // MARK: Setup Main View
    private func setupView() {
        backgroundColor = .white
        detailScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        detailScrollView.addSubview(houseImageView)
        detailScrollView.backgroundColor = UIColor.white
        detailScrollView.addSubview(favouriteButton)
        contentView = UIView(frame: CGRect(x: 0, y: favouriteButton.frame.size.height+favouriteButton.frame.origin.y+10, width: self.frame.size.width, height: contentDescriptionLbl.frame.origin.y+contentDescriptionLbl.frame.size.height+10))
        contentView.addSubview(contentHeaderLbl)
        contentView.addSubview(contentDescriptionLbl)
        detailScrollView.addSubview(contentView)
        self.addSubview(detailScrollView)
        self.setupMapView()
       
    }
    
   
   // MARK: Setup Map View
    func setupMapView() {
        let mapView = MKMapView()
        mapView.frame = CGRect(x: 0, y: contentView.frame.size.height+contentView.frame.origin.y+10, width: detailScrollView.frame.size.width, height: 300)
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        self.addSubview(mapView)
        annotation.coordinate = CLLocationCoordinate2D(latitude: 11.12, longitude: 12.11)
        mapView.addAnnotation(annotation)
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.05, 0.05)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(annotation.coordinate , span)
        mapView.setRegion(region, animated: true)
        detailScrollView.contentSize = CGSize(width: detailScrollView.frame.size.width, height: mapView.frame.size.height+mapView.frame.origin.y+20)
    }
    
   
    // MARK: Back Action
    @objc private func moveBack() {
       self.removeFromSuperview()
        setNeedsLayout()
    }
    
    // MARK: Favourite Action 
    @objc private func favouriteAction(sender: UIButton) {
        let button = sender
        if  favourite!{
            button.backgroundColor = UIColor.green
             button.setTitle("unfavourite", for: .normal)
            favourite = false
            CoreDataManager.sharedManager.update(name: houseObj.value(forKey: "houseName") as! String, id: houseObj.value(forKey: "houseId") as! Int16, description: houseObj.value(forKey: "houseDesc") as! String , image: houseObj.value(forKey: "houseImage") as! String, favourite: favourite! , house: houseObj)
           
            
        }else{
             button.backgroundColor = UIColor.red
             button.setTitle("favourite", for: .normal)
            favourite = true
            CoreDataManager.sharedManager.update(name: houseObj.value(forKey: "houseName") as! String, id: houseObj.value(forKey: "houseId") as! Int16, description: houseObj.value(forKey: "houseDesc") as! String , image: houseObj.value(forKey: "houseImage") as! String, favourite: favourite! , house: houseObj)
        }
        NotificationCenter.default.post(name: Notification.Name("UpdateDb"), object: nil)
       // setNeedsLayout()
    }
   
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
}
    
   

