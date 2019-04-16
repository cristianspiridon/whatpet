//
//  InfoTableViewCell.swift
//  WhatPet
//
//  Created by Cristian Spiridon on 16/04/2019.
//  Copyright © 2019 Cristian Spiridon. All rights reserved.
//

import UIKit

class InfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textview: UITextView!
    
    var data:KeyInfo? {
        didSet {
            label.text    = "  " + data!.key
            textview.text = data?.value
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
