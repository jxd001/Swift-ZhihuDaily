//
//  HomeViewController.swift
//  testSwift
//
//  Created by XuDong Jin on 14-6-10.
//  Copyright (c) 2014年 XuDong Jin. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController,SlideScrollViewDelegate {


    @IBOutlet var tableView : UITableView!
    
    var dataArray = NSMutableArray()
    var slideArray = NSMutableArray()
    var slideImgArray = NSMutableArray()
    var slideTtlArray = NSMutableArray()
    
    
    let identifier = "cell"
    let url = "https://news-at.zhihu.com/api/3/news/latest"
    
    let kImageHeight:CGFloat = 400
    let kInWindowHeight:CGFloat = 200
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.title = "今日热闻"
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            if data as! NSObject == NSNull()
            {
                UIView.showAlertView("提示",message:"加载失败")
                return
            }

            var arr = data["stories"] as! NSArray

            for data : AnyObject  in arr
            {
                self.dataArray.addObject(data)
            }
            
            var topArr = data["top_stories"] as! NSArray
            self.slideArray = NSMutableArray(array:topArr)
            for topData : AnyObject in topArr
            {
                var dic = topData as! NSDictionary
                var imgUrl = dic["image"] as! String
                self.slideImgArray.addObject(imgUrl)
                
                var title = dic["title"] as! String
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
            var c = tableView?.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath!) as? HomeViewCell
            var index = indexPath!.row
            var data = self.dataArray[index] as! NSDictionary
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
        var data = self.dataArray[index] as! NSDictionary
        var detailCtrl = DetailViewController(nibName :"DetailViewController", bundle: nil)
        detailCtrl.aid = data["id"] as! Int
        self.navigationController!.pushViewController(detailCtrl, animated: true)
    }
    
    func SlideScrollViewDidClicked(index:Int)
    {
        var data = self.slideArray[index-1] as! NSDictionary
        var detailCtrl = DetailViewController(nibName :"DetailViewController", bundle: nil)
        detailCtrl.aid = data["id"] as! Int
        self.navigationController!.pushViewController(detailCtrl, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
