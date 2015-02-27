//
//  DetailViewController.swift
//  testSwift
//
//  Created by XuDong Jin on 14-6-11.
//  Copyright (c) 2014年 XuDong Jin. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController,UIScrollViewDelegate {
    
    @IBOutlet var webView : UIWebView!
    var aid:Int!
    var topImage:UIImageView = UIImageView()
    var url = "http://news-at.zhihu.com/api/3/news/" as String
    
    let kImageHeight:Float = 400
    let kInWindowHeight:Float = 200

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.scrollView.delegate = self

        loadData()
    }
    
    func loadData()
    {
        url = "\(url)\(aid)"
        
        YRHttpRequest.requestWithURL(url,completionHandler:{ data in

            if data as NSObject == NSNull()
            {
                UIView.showAlertView("提示",message:"加载失败")
                return
            }
            
            var type = data["type"] as Int
            
            var keys = data.allKeys as NSArray
            if keys.containsObject("image")
            {
                var imgUrl = data["image"] as String
                self.topImage.frame = CGRect(origin: CGPoint(x: 0,y: -100),size: CGSize(width: 320,height: 300))
                self.topImage.setImage(imgUrl,placeHolder: UIImage(named: "avatar.png"))
                self.topImage.contentMode = UIViewContentMode.ScaleAspectFill
                self.topImage.clipsToBounds = true
                self.webView.scrollView.addSubview(self.topImage)
                
                var shadowImg:UIImageView = UIImageView()
                shadowImg.frame = CGRect(origin: CGPoint(x: 0,y: 120),size: CGSize(width: 320,height: 80))
                shadowImg.image = UIImage(named:"shadow.png")
                self.webView.scrollView.addSubview(shadowImg)
                
                var titleLbl:UILabel = UILabel()
                titleLbl.textColor = UIColor.whiteColor()
                titleLbl.font = UIFont.boldSystemFontOfSize(16)
                titleLbl.numberOfLines = 0
                titleLbl.lineBreakMode = NSLineBreakMode.ByCharWrapping
                titleLbl.text = data["title"] as? String
                titleLbl.frame = CGRect(origin: CGPoint(x: 10,y: 130),size: CGSize(width: 300,height: 50))
                self.webView.scrollView.addSubview(titleLbl)
                
                var copyLbl:UILabel = UILabel()
                var copy = data["image_source"]
                copyLbl.textColor = UIColor.lightGrayColor()
                copyLbl.font = UIFont(name: "Arial",size:10)
                copyLbl.text = "图片：\(copy)"
                copyLbl.frame = CGRect(origin: CGPoint(x: 10,y: 180),size: CGSize(width: 300,height: 10))
                copyLbl.textAlignment = NSTextAlignment.Right
                self.webView.scrollView.addSubview(copyLbl)
            }
            
            
            var body = data["body"] as String
            var css = data["css"] as NSArray
            var cssUrl = css[0] as String
            
            body = "<link href='\(cssUrl)' rel='stylesheet' type='text/css' />\(body)"
            
            self.webView.loadHTMLString(body, baseURL:nil )
            
        })
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView!)
    {
        var yOffset = self.webView.scrollView.contentOffset.y
        updateOffsets()
    }
    
    func updateOffsets() {
        var yOffset   = self.webView.scrollView.contentOffset.y
        var threshold = kImageHeight - kInWindowHeight
        
        if Double(yOffset) > Double(-threshold) && Double(yOffset) < -64 {
            self.topImage.frame = CGRect(origin: CGPoint(x: 0,y: -100+yOffset/2),size: CGSize(width: 320,height: 300-yOffset/2));
        }
        else if yOffset < -64 {
            self.topImage.frame = CGRect(origin: CGPoint(x: 0,y: -100+yOffset/2),size: CGSize(width: 320,height: 300-yOffset/2));
        }
        else {
            self.topImage.frame = CGRect(origin: CGPoint(x: 0,y: -100),size: CGSize(width: 320,height: 300));
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
