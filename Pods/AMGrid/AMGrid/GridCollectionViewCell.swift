//
//  GridCollectionViewCell.swift
//  HousesPoc
//
//  Created by ArunMak on 30/09/18.
//  Copyright © 2018 ArunMak. All rights reserved.
//

import UIKit

public class GridCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak public var houseImageView: UIImageView!
    @IBOutlet weak  public var houseNameLbl: UILabel!
  
    @IBOutlet weak public var favouriteImageView: UIImageView!
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.houseNameLbl.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        self.houseNameLbl.textColor = .black
        self.houseNameLbl.textAlignment = .center
        // Initialization code
    }

}
