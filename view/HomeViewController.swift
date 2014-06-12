//
//  HomeViewController.swift
//  testSwift
//
//  Created by XuDong Jin on 14-6-10.
//  Copyright (c) 2014年 XuDong Jin. All rights reserved.
//

import UIKit


class HomeViewController: UIViewController {


    @IBOutlet var tableView : UITableView
    
    var dataArray = NSMutableArray()
    var slideImgArray = NSMutableArray()
    var slideTtlArray = NSMutableArray()
    
    let identifier = "cell"
    let url = "http://news-at.zhihu.com/api/3/news/latest"
    
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
            cell.sep
            cell.clipsToBounds = true
            
            if self.slideImgArray.count > 0{
                var slideRect = CGRect(origin:CGPoint(x:0,y:0),size:CGSize(width:320,height:kImageHeight))
                
                var slideView = SlideScrollView()
                slideView.initWithFrameRect(slideRect,imgArr:self.slideImgArray,titArr:self.slideTtlArray)
                println(self.slideImgArray.count)
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
        tableView.deselectRowAtIndexPath(indexPath!,animated: true)
        var index = indexPath!.row
        var data = self.dataArray[index] as NSDictionary
        var detailCtrl = DetailViewController(nibName :"DetailViewController", bundle: nil)
        detailCtrl.aid = data["id"] as Int
        self.navigationController.pushViewController(detailCtrl, animated: true)
    }
    

    func scrollViewDidScroll(scrollView: UIScrollView!)
    {
        var yOffset = self.tableView.contentOffset.y
        updateOffsets()
    }
    
    func updateOffsets() {
        var yOffset   = self.tableView.contentOffset.y;
        var threshold = kImageHeight - kInWindowHeight;
    
//        if yOffset > -threshold && yOffset < 0 {
//            self.scrollView.contentOffset = CGPointMake(0.0, floorf(yOffset / 2.0));
//        }
//        else if yOffset < 0 {
//            self.scrollView.contentOffset = CGPointMake(0.0, yOffset + floorf(threshold / 2.0));
//        }
//        else {
//            self.scrollView.contentOffset = CGPointMake(0.0, yOffset);
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
