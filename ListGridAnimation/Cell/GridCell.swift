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
    @IBOutlet weak var stackView: UIStackView!
    var isGridFlowLayoutUsed: Bool?
    
    func bind(colorName: String, isGridFlowLayoutUsed: Bool)
    {
        imageView.backgroundColor = UIColor(hex: colorName)
        self.isGridFlowLayoutUsed = isGridFlowLayoutUsed
        label.text = colorName
        if(isGridFlowLayoutUsed)
        {
            self.label.textAlignment = .center
            self.stackView.axis = .vertical
        }
        else {
            self.label.textAlignment = .natural
            self.stackView.axis = .horizontal
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if(isGridFlowLayoutUsed ?? true)
        {
            self.label.textAlignment = .center
            self.stackView.axis = .vertical
        }
        else {
            self.label.textAlignment = .natural
            self.stackView.axis = .horizontal
        }
    }
}
