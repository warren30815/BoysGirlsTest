//
//  TimetableCell.swift
//  BoysGirls
//
//  Created by 許竣翔 on 2018/7/4.
//  Copyright © 2018年 許竣翔. All rights reserved.
//

import UIKit

class TimetableCell: UITableViewCell {
    
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var status: UIImageView!
    @IBOutlet weak var content: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
