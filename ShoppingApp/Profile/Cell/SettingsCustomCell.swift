//
//  SettingsCustomCell.swift
//  ShoppingApp
//
//  Created by Agata Menes on 05/12/2022.
//

import UIKit

class SettingsCustomCell: UITableViewCell {
    @IBOutlet weak var optionsLabel: UILabel!
    
    func setTitleLabel(title: String) {
        optionsLabel.text = title
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
