//
//  HomeViewController.swift
//  testSwift
//
//  Created by XuDong Jin on 14-6-10.
//  Copyright (c) 2014年 XuDong Jin. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController,SlideScrollViewDelegate {


    @IBOutlet var tableView : UITableView
    
    var dataArray = NSMutableArray()
    var slideArray = NSMutableArray()
    var slideImgArray = NSMutableArray()
    var slideTtlArray = NSMutableArray()
    
    
    let identifier = "cell"
    let url = "http://news-at.zhihu.com/api/3/news/latest"
    let launchImgUrl = "http://news-at.zhihu.com/api/3/start-image/640*960"
    
    
    let kImageHeight:Float = 400
    let kInWindowHeight:Float = 200
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.title = "今日热闻"
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        var nib = UINib(nibName:"HomeViewCell", bundle: nil)
        self.tableView?.registerNib(nib, forCellReuseIdentifier: identifier)
        
        self.edgesForExtendedLayout = UIRectEdge.Top
        
        showLauchImage()
        
        loadData()
    }
    
    func loadData()
    {

        YRHttpRequest.requestWithURL(url,completionHandler:{ data in
            if data as NSObject == NSNull()
            {
                UIView.showAlertView("提示",message:"加载失败")
                return
            }

            var arr = data["stories"] as NSArray

            for data : AnyObject  in arr
            {
                self.dataArray.addObject(data)
            }
            
            var topArr = data["top_stories"] as NSArray
            self.slideArray = NSMutableArray(array:topArr)
            for topData : AnyObject in topArr
            {
                var dic = topData as NSDictionary
                var imgUrl = dic["image"] as String
                self.slideImgArray.addObject(imgUrl)
                
                var title = dic["title"] as String
                self.slideTtlArray.addObject(title)
            }
            
            self.tableView!.reloadData()

        })
        
    }
    
    func showLauchImage () {
        YRHttpRequest.requestWithURL(launchImgUrl,completionHandler:{ data in
            if data as NSObject == NSNull()
            {
                return
            }
            
            var imgUrl = data["img"] as String
            
            var height = UIScreen.mainScreen().bounds.size.height
            var img = UIImageView(frame:CGRectMake(0, 0, 320, height))
            img.backgroundColor = UIColor.blackColor()
            img.contentMode = UIViewContentMode.ScaleAspectFit
            
            var window = UIApplication.sharedApplication().keyWindow
            window.addSubview(img)
            img.setImage(imgUrl,placeHolder:nil)
            
            var lbl = UILabel(frame:CGRectMake(0,height-50,320,20))
            lbl.backgroundColor = UIColor.clearColor()
            lbl.text = data["text"] as String
            lbl.textColor = UIColor.lightGrayColor()
            lbl.textAlignment = NSTextAlignment.Center
            lbl.font = UIFont.systemFontOfSize(14)
            window.addSubview(lbl)
            
            UIView.animateWithDuration(3,animations:{
                var height = UIScreen.mainScreen().bounds.size.height
                var rect = CGRectMake(-100,-100,320+200,height+200)
                img.frame = rect
                },completion:{
                    (Bool completion) in
                    
                    if completion {
                        UIView.animateWithDuration(1,animations:{
                            img.alpha = 0
                            lbl.alpha = 0
                            },completion:{
                                (Bool completion) in
                                
                                if completion {
                                    img.removeFromSuperview()
                                    lbl.removeFromSuperview()
                                }
                            })
                    }
                })
        })
        
    }
    
   
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int{
        return 2
    }
    
    func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        if section==0{
            return 1
        }
        else
        {
            return self.dataArray.count
        }
    }
    
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat
    {
        if indexPath.section==0{
            return kInWindowHeight
        }
        else{
            return 106
        }
    }
    
    func tableView(tableView: UITableView?, cellForRowAtIndexPath indexPath: NSIndexPath?) -> UITableViewCell? {
        
        var cell:UITableViewCell
        if indexPath!.section==0{
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
            cell.backgroundColor = UIColor.clearColor()
            cell.contentView.backgroundColor = UIColor.clearColor()
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.clipsToBounds = true
            
            if self.slideImgArray.count > 0{
                var slideRect = CGRect(origin:CGPoint(x:0,y:0),size:CGSize(width:320,height:self.kImageHeight))
                
                var slideView = SlideScrollView(frame: slideRect)
                slideView.delegate = self
                slideView.initWithFrameRect(slideRect,imgArr:self.slideImgArray,titArr:self.slideTtlArray)
//                self.view.addSubview(slideView)
//                self.tableView.tableHeaderView = slideView
                cell.addSubview(slideView)
            }
        }
        else{
            var c = tableView?.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as? HomeViewCell
            var index = indexPath!.row
            var data = self.dataArray[index] as NSDictionary
            c!.data = data
            cell = c!
        }
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!)
    {
        if indexPath!.section==0 {return}
        tableView.deselectRowAtIndexPath(indexPath!,animated: true)
        var index = indexPath!.row
        var data = self.dataArray[index] as NSDictionary
        var detailCtrl = DetailViewController(nibName :"DetailViewController", bundle: nil)
        detailCtrl.aid = data["id"] as Int
        self.navigationController.pushViewController(detailCtrl, animated: true)
    }
    
    func SlideScrollViewDidClicked(index:Int)
    {
        if index == 0 {return} // when you click scrollview too soon after the view is presented
        var data = self.slideArray[index-1] as NSDictionary
        var detailCtrl = DetailViewController(nibName :"DetailViewController", bundle: nil)
        detailCtrl.aid = data["id"] as Int
        self.navigationController.pushViewController(detailCtrl, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
