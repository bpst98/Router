//
//  TableViewCell.swift
//  Router
//
//  Created by Bhanu Pratap Singh Thapliyal on 08/07/18.
//  Copyright © 2018 Bhanu Pratap Singh Thapliyal. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var iconimageView: UIImageView!
    
    @IBOutlet weak var primaryLabel: UILabel!
    
    @IBOutlet weak var SecondaryLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
