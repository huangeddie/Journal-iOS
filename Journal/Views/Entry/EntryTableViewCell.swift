//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Edward Huang on 2/14/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var passageLabel: UILabel!
    
    var entry: Entry!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
