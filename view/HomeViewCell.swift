//
//  HomeViewCell.swift
//  testSwift
//
//  Created by XuDong Jin on 14-6-10.
//  Copyright (c) 2014年 XuDong Jin. All rights reserved.
//

import UIKit

class HomeViewCell: UITableViewCell {
    
    @IBOutlet var thumbImage : UIImageView!
    @IBOutlet var titleTextView : UITextView!

    var data:NSDictionary?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        var dic:NSDictionary = self.data!
        
        self.titleTextView.text = dic["title"] as String
        
        var thumbArr = dic["images"] as NSArray
        var thumbUrl = thumbArr[0] as String
        
        self.thumbImage.setImage(thumbUrl,placeHolder: UIImage(named: "avatar.png"))
    }
}
