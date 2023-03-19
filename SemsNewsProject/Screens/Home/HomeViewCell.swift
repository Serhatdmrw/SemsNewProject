//
//  HomeViewCell.swift
//  SemsNewsProject
//
//  Created by Serhat Demir on 16.03.2023.
//

import UIKit

class HomeViewCell: UITableViewCell {

    @IBOutlet weak var cellSubView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellSubView.layer.cornerRadius = 32
    }
}
