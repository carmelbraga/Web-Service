//
//  BreakingNewsTableViewCell.swift
//  Breaking News
//
//  Created by Carmel Braga on 4/24/20.
//  Copyright © 2020 Carmel Braga. All rights reserved.
//

import UIKit

class BreakingNewsTableViewCell: UITableViewCell {

    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bylineLabel: UILabel!
    @IBOutlet weak var publishedDateLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
