//
//  OptionsTableViewCell.swift
//  GeoQuiz
//
//  Created by Deforation on 7/22/15.
//  Copyright (c) 2015 Team F. All rights reserved.
//

import UIKit

class OptionsTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var toggle: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
