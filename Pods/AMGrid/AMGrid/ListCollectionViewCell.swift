//
//  MyCollectionViewCell.swift
//  uicollectionviewcell-from-xib
//
//  Created by ArunMak on 30/09/18.
//  Copyright © 2017 bett. All rights reserved.
//

import UIKit

public class ListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak public var houseImageView: UIImageView!
    
    @IBOutlet weak public var houseNameLbl: UILabel!
    @IBOutlet weak public var houseDescLbl: UILabel!
    override public func awakeFromNib() {
        super.awakeFromNib()
    }

}
