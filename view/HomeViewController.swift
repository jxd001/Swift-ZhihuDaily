//
//  HomeViewController.swift
//  testSwift
//
//  Created by XuDong Jin on 14-6-10.
//  Copyright (c) 2014年 XuDong Jin. All rights reserved.
//

import UIKit

let WINDOW_HEIGHT = UIScreen.mainScreen().bounds.size.height
let WINDOW_WIDTH  = UIScreen.mainScreen().bounds.size.width
let identifier = "cell"

let url = "http://news-at.zhihu.com/api/4/stories/latest?client=0"
let continueUrl = "http://news-at.zhihu.com/api/4/stories/before/"

let launchImgUrl = "https://news-at.zhihu.com/api/4/start-image/640*1136?client=0"

let kImageHeight:Float = 400
let kInWindowHeight:Float = 200

class HomeViewController: UIViewController,SlideScrollViewDelegate {


    @IBOutlet var tableView : UITableView!
    
    var dataKey = NSMutableArray()
    var dataFull = NSMutableDictionary() //date as key, above
    var slideArray = NSMutableArray()
    var slideImgArray = NSMutableArray()
    var slideTtlArray = NSMutableArray()
    
    var bloading = false;
    
    var dateString = ""
    
    //MARK:-
    
   override  init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.title = "今日热闻"
    }

   required init(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        let nib = UINib(nibName:"HomeViewCell", bundle: nil)
        self.tableView?.registerNib(nib, forCellReuseIdentifier: identifier)
        
        self.edgesForExtendedLayout = UIRectEdge.Top
        
        showLauchImage()
        
        loadData()
    }
    
    func loadData()
    {
        if(bloading){
            return;
        }
        self.bloading = true;
        var curUrl = url;
        if(dateString.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0){
            curUrl = continueUrl.stringByAppendingString(dateString);
        }

        YRHttpRequest.requestWithURL(curUrl,completionHandler:{ data in
            self.bloading = false;
            if data as! NSObject == NSNull()
            {
                UIView.showAlertView("提示",message:"加载失败")
                return
            }

            
            if(self.dateString.isEmpty){
                let topArr = data["top_stories"] as! NSArray
                self.slideArray = NSMutableArray(array:topArr)
                for topData : AnyObject in topArr
                {
                    let dic = topData as! NSDictionary
                    let imgUrl = dic["image"] as! String
                    self.slideImgArray.addObject(imgUrl)
                    
                    let title = dic["title"] as! String
                    self.slideTtlArray.addObject(title)
                }
            }
            
            self.dateString = data["date"] as! String
            
            
            let arr = data["stories"] as! NSArray
            self.dataKey.addObject(self.dateString);
            self.dataFull.addEntriesFromDictionary([self.dateString : arr])
            
            self.tableView!.reloadData()

        })
        
    }
    
    func showLauchImage () {
        YRHttpRequest.requestWithURL(launchImgUrl,completionHandler:{ data in
            if data as! NSObject == NSNull()
            {
                return
            }
            
            let imgUrl = data["img"] as! String
            
            let height = UIScreen.mainScreen().bounds.size.height
            let width = UIScreen.mainScreen().bounds.size.width
            let img = UIImageView(frame:CGRectMake(0, 0, width, height))
            img.backgroundColor = UIColor.blackColor()
            img.contentMode = UIViewContentMode.ScaleAspectFit
            
            let window = UIApplication.sharedApplication().keyWindow
            window!.addSubview(img)
            img.setImage(imgUrl,placeHolder:nil)
            
            let lbl = UILabel(frame:CGRectMake(0,height-50,width,20))
            lbl.backgroundColor = UIColor.clearColor()
            lbl.text = data["text"] as? String
            lbl.textColor = UIColor.lightGrayColor()
            lbl.textAlignment = NSTextAlignment.Center
            lbl.font = UIFont.systemFontOfSize(14)
            window!.addSubview(lbl)
            
            UIView.animateWithDuration(3,animations:{
                let height = UIScreen.mainScreen().bounds.size.height
                let rect = CGRectMake(-100,-100,width+200,height+200)
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
    
    //MARK:
    //MARK: -------tableView delegate&datasource
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int{
        return 1 + self.dataKey.count
    }
    
    func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        if section==0{
            return 1
        }
        else
        {
            let array1 = self.dataFull[self.dataKey[section-1] as! String] as! NSArray
            return array1.count
        }
    }
    
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat
    {
        if indexPath.section==0{
            return CGFloat(kInWindowHeight)
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
                let width = UIScreen.mainScreen().bounds.size.height
                let slideRect = CGRect(origin:CGPoint(x:0,y:0),size:CGSize(width:width,height:CGFloat(kImageHeight)))
                
                let slideView = SlideScrollView(frame: slideRect)
                slideView.delegate = self
                slideView.initWithFrameRect(slideRect,imgArr:self.slideImgArray,titArr:self.slideTtlArray)
//                self.view.addSubview(slideView)
//                self.tableView.tableHeaderView = slideView
                cell.addSubview(slideView)
            }
        }
        else{
            let c = tableView?.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath!) as? HomeViewCell
            let index = indexPath!.row
            let array1 = self.dataFull[self.dataKey[(indexPath?.section)!-1] as! String] as! NSArray
            let data = array1[index] as! NSDictionary
            c!.data = data
            cell = c!
        }
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!)
    {
        if indexPath!.section==0 {return}
        tableView.deselectRowAtIndexPath(indexPath!,animated: true)
        let index = indexPath!.row
        let array1 = self.dataFull[self.dataKey[(indexPath?.section)!-1] as! String] as! NSArray
        let data = array1[index] as! NSDictionary
        let detailCtrl = DetailViewController(nibName :"DetailViewController", bundle: nil)
        detailCtrl.aid = data["id"] as! Int
        self.navigationController!.pushViewController(detailCtrl, animated: true)
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if(section <= 1)
        {
            return 0
        }
        return 30 //NavigationBar Height
    }
    

    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let lbl = UILabel(frame:CGRectMake(0,0,320,30))
        lbl.backgroundColor = UIColor.lightGrayColor()
        if(section > 0){
            lbl.text = self.dataKey[section-1] as? String
        }
        lbl.textColor = UIColor.whiteColor()
        lbl.textAlignment = NSTextAlignment.Center
        lbl.font = UIFont.systemFontOfSize(14)
        return lbl;
    }
    
    //MARK:
    //MARK:------slidescroll delegate
    

    func scrollViewDidScroll(scrollView: UIScrollView){
        if(scrollView.contentSize.height - scrollView.contentOffset.y - scrollView.frame.height < scrollView.frame.height/3){
            loadData()
        }
    }

    func SlideScrollViewDidClicked(index:Int)
    {
        if index == 0 {return} // when you click scrollview too soon after the view is presented
        let data = self.slideArray[index-1] as! NSDictionary
        let detailCtrl = DetailViewController(nibName :"DetailViewController", bundle: nil)
        detailCtrl.aid = data["id"] as! Int
        self.navigationController!.pushViewController(detailCtrl, animated: true)
    }
    
    //MARK:
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
