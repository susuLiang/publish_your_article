//
//  PublishArticleCell.swift
//  chatTogther
//
//  Created by Aries Yang on 2017/11/26.
//  Copyright © 2017年 Susu Liang. All rights reserved.
//

import UIKit

class PublishArticleCell: UITableViewCell {
    
    @IBOutlet weak var authorButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
//        likeButton = UIButton(type: .custom)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
