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
    @IBOutlet weak var multiPicBg: UIView!
    @IBOutlet weak var multiPicLabel: UILabel!
    
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
        let dic:NSDictionary = self.data!
        
        self.titleTextView.text = dic["title"] as! String
        
        if let thumbArr = dic["images"] as? NSArray
        {
            let thumbUrl = thumbArr[0] as! String
            self.thumbImage.setImage(thumbUrl,placeHolder: UIImage(named: "avatar.png"))
        }
        
        multiPicBg.hidden = true
        multiPicLabel.hidden = true
        if let bMultiPic:Bool = dic["multipic"] as? Bool
        {
            if bMultiPic{
                multiPicBg.hidden = false
                multiPicLabel.hidden = false
            }
        }
    }
}
