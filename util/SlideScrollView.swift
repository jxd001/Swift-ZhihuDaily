//
//  SlideScrollView.swift
//  ZhihuDaily
//
//  Created by XuDong Jin on 14-6-12.
//  Copyright (c) 2014年 XuDong Jin. All rights reserved.
//

import UIKit

protocol SlideScrollViewDelegate {
    
    func SlideScrollViewDidClicked(index:Int)
    
}



class SlideScrollView: UIView,UIScrollViewDelegate {

    var viewSize:CGRect = CGRect()
    var scrollView:UIScrollView = UIScrollView()
    var imageArray:NSArray = NSArray()
    var titleArray:NSArray = NSArray()
    var pageControl:UIPageControl = UIPageControl()
    var currentPageIndex:Int = 0
    var noteTitle:UILabel = UILabel()
    
    var delegate:SlideScrollViewDelegate?
   
    func initWithFrameRect(rect:CGRect,imgArr:NSArray,titArr:NSArray)->AnyObject{
        
        var view:UIView = UIView(frame:rect)
        
        self.userInteractionEnabled=true;
        
        var tempArray:NSMutableArray=NSMutableArray(array: imgArr);
        tempArray.insertObject(imgArr[imgArr.count-1], atIndex:0)
        tempArray.addObject(imgArr[0])
        imageArray=NSArray(array:tempArray)
        titleArray=NSArray(array:titArr)
        viewSize=rect;
        var pageCount:Int=imageArray.count
        scrollView=UIScrollView(frame:CGRect(origin: CGPoint(x: 0,y: 0),size: CGSize(width: viewSize.size.width,height: viewSize.size.height)))
        scrollView.pagingEnabled = true
        var contentWidth = 320*pageCount
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false

        scrollView.scrollEnabled = true
        scrollView.pagingEnabled = true
        scrollView.scrollsToTop = false
        scrollView.delegate = self
        
        for var i=0; i<pageCount; i++ {
            var imgURL:String=imageArray[i] as! String
            var imgView:UIImageView=UIImageView()
            
            var viewWidth = Int(viewSize.size.width)*i
            imgView.frame = CGRect(origin: CGPoint(x: CGFloat(viewWidth), y:CGFloat(0)),size: CGSize(width: viewSize.size.width,height: viewSize.size.height))

            imgView.setImage(imgURL,placeHolder: UIImage(named: "avatar.png"))
            imgView.contentMode = UIViewContentMode.ScaleToFill
            imgView.userInteractionEnabled = true

            imgView.tag = i
            
            var tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "imagePressed:")

            tap.numberOfTapsRequired = 1
            tap.numberOfTouchesRequired = 1
            imgView.addGestureRecognizer(tap)
            scrollView.addSubview(imgView)
        }
        
        scrollView.contentOffset = CGPoint(x:viewSize.size.width, y:0)
        
        self.addSubview(scrollView)

        //文字层
        var myHeight:CGFloat = 24;
        
        var shadowImg:UIImageView = UIImageView()
        shadowImg.frame = CGRect(origin: CGPoint(x: 0,y: 130),size: CGSize(width: 320,height: 80))
        shadowImg.image = UIImage(named:"shadow.png")
        self.addSubview(shadowImg)
        
        let noteView:UIView = UIView(frame:CGRect(origin:CGPoint(x:0, y:170),size:CGSize(width:320,height:CGFloat(myHeight))));
        noteView.userInteractionEnabled = false;
        noteView.backgroundColor = UIColor(red:0/255.0,green:0/255.0,blue:0/255.0,alpha:0)
        
        let pageControlWidth:CGFloat = (CGFloat(pageCount-2))*10.0+CGFloat(40)
        let pagecontrolHeight:CGFloat = myHeight
        
        pageControl = UIPageControl(
            frame:CGRect(origin:CGPoint(x:CGFloat(Float(self.viewSize.size.width)/2-Float(pageControlWidth/2)), y:0),
            size:CGSize(width:CGFloat(pageControlWidth),height:CGFloat(pagecontrolHeight))))

        pageControl.currentPage=0;
        pageControl.numberOfPages=(pageCount-2);
        noteView.addSubview(pageControl)
        
        noteTitle = UILabel()
        noteTitle.textColor = UIColor.whiteColor()
        noteTitle.font = UIFont.boldSystemFontOfSize(16)
        noteTitle.numberOfLines = 0
        noteTitle.lineBreakMode = NSLineBreakMode.ByCharWrapping
        noteTitle.text = self.titleArray[0] as? String
        noteTitle.frame = CGRect(origin: CGPoint(x: 10,y: 130),size: CGSize(width: 300,height: 50))
        self.addSubview(noteTitle)

        self.addSubview(noteView)

        var timer:NSTimer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "autoShowNextPage", userInfo: nil, repeats: true)
        
        return self
    }
    
    func autoShowNextPage() {

        if pageControl.currentPage + 1 < titleArray.count {
            currentPageIndex = pageControl.currentPage + 1
            self.changeCurrentPage()
        }else{
            currentPageIndex = 0;
            self.changeCurrentPage()
        }
    }
    
    func changeCurrentPage (){
        var offX = scrollView.frame.size.width * CGFloat(currentPageIndex+1)
        scrollView.setContentOffset(CGPoint(x:offX, y:scrollView.frame.origin.y), animated:true)
        self.scrollViewDidScroll(scrollView);
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //感觉swift算数运算的时候好麻烦啊，一个运算里必须要所有的值都保持一致才行，所以一个运算才变成了下面这一大段难看的代码，本来应该是这样的：
        // var page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1
        //应该是我没搞明白swift的真谛吧，我不相信有这么麻烦，求大神指教啊

        let pageWidth:Int = Int(scrollView.frame.size.width)
        let offX:Int = Int(scrollView.contentOffset.x)
        let a = offX - pageWidth / 2 as Int
        let b = a / pageWidth as Int
        let c = floor(Double(b))
        let page:Int = Int(c) + 1
        
        currentPageIndex=page
        pageControl.currentPage=(page-1)
        var titleIndex=page-1
        if (titleIndex==titleArray.count) {
        titleIndex=0;
        }
        if (titleIndex<0) {
        titleIndex=titleArray.count-1;
        }
        noteTitle.text = self.titleArray[titleIndex] as? String

    }
    
    func imagePressed (tap:UITapGestureRecognizer){
        delegate?.SlideScrollViewDidClicked(tap.view!.tag)
    }

}
