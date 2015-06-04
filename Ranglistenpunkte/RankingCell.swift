//
//  RankingCell.swift
//  Ranglistenpunkte
//
//  Created by Martin Kautz on 04.12.14.
//  Copyright (c) 2014 Martin Kautz. All rights reserved.
//

import UIKit

class RankingCell: UITableViewCell {

    @IBOutlet weak var posLabel:UILabel!
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var sailLabel:UILabel!
    @IBOutlet weak var scoreLabel:UILabel!
    @IBOutlet weak var yearLabel:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        posLabel.textColor      = UIColor(red: 13.0/255.0, green: 63.0/255.0, blue: 94.0/255.0, alpha: 1.0)
        nameLabel.textColor     = UIColor(red: 13.0/255.0, green: 63.0/255.0, blue: 94.0/255.0, alpha: 1.0)
        sailLabel.textColor     = UIColor(red: 13.0/255.0, green: 63.0/255.0, blue: 94.0/255.0, alpha: 1.0)
        scoreLabel.textColor    = UIColor(red: 13.0/255.0, green: 63.0/255.0, blue: 94.0/255.0, alpha: 1.0)
        yearLabel.textColor     = UIColor(red: 13.0/255.0, green: 63.0/255.0, blue: 94.0/255.0, alpha: 1.0)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
