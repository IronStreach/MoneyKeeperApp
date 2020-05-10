//
//  TableViewCell.swift
//  MoneyKeeper
//
//  Created by Станислав Никишков on 08.05.2020.
//  Copyright © 2020 Станислав Никишков. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

        @IBOutlet weak var nameLabel: UILabel!
        @IBOutlet weak var summLabel: UILabel!
}
