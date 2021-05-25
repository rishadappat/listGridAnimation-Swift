//
//  GridCell.swift
//  ListGridAnimation
//
//  Created by Rishad Appat on 25/05/2021.
//

import UIKit

class GridCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    func bind(colorName: String)
    {
        imageView.backgroundColor = UIColor(hex: colorName)
        label.text = colorName
    }
}
