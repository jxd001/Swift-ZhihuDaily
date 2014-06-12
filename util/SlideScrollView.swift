//
//  SlideScrollVoew.swift
//  ZhihuDaily
//
//  Created by XuDong Jin on 14-6-12.
//  Copyright (c) 2014年 XuDong Jin. All rights reserved.
//

import UIKit

protocol EScrollerViewDelegate {
    
    func EScrollerViewDidClicked(index:Int)
    
}

class SlideScrollView: UIView,UIScrollViewDelegate {

    var viewSize:CGRect = CGRect()
    var scrollView:UIScrollView = UIScrollView()
    var imageArray:NSArray = NSArray()
    var titleArray:NSArray = NSArray()
    var pageControl:UIPageControl = UIPageControl()
    var currentPageIndex:Int = 0
    var noteTitle:UILabel = UILabel()
    
   
    func initWithFrameRect(rect:CGRect,imgArr:NSArray,titArr:NSArray)->AnyObject{
        
        self.userInteractionEnabled=true;
        
        var tempArray:NSMutableArray=NSMutableArray(array: imgArr);
        tempArray.insertObject(imgArr[imgArr.count-1], atIndex:0)
        tempArray.addObject(imgArr[0])
        imageArray=NSArray(array:tempArray);
        viewSize=rect;
        var pageCount:Int=imageArray.count;
        scrollView=UIScrollView(frame:CGRect(origin: CGPoint(x: 0,y: 0),size: CGSize(width: viewSize.size.width,height: viewSize.size.height)))
        scrollView.pagingEnabled = true;
        var contentWidth = 320*pageCount

        scrollView.contentSize = CGSize(width:Float(1000), height:viewSize.size.height+1000)
        
        scrollView.showsHorizontalScrollIndicator = false;
        scrollView.showsVerticalScrollIndicator = false;
        scrollView.scrollsToTop = false;
        scrollView.delegate = self;
        for var i=0; i<pageCount; i++ {
            var imgURL:String=imageArray[i] as String
            var imgView:UIImageView=UIImageView()
            
            var viewWidth = Int(viewSize.size.width)*i
            imgView.frame = CGRect(origin: CGPoint(x: Float(viewWidth),y: 0),size: CGSize(width: viewSize.size.width,height: viewSize.size.height))

            imgView.setImage(imgURL,placeHolder: UIImage(named: "avatar.png"))
            
            imgView.contentMode = UIViewContentMode.ScaleToFill
            
            imgView.tag=i
            
            var tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "imagePressed")

            tap.numberOfTapsRequired = 1
            tap.numberOfTouchesRequired = 1
            imgView.userInteractionEnabled = true
            imgView.addGestureRecognizer(tap)
            scrollView.addSubview(imgView)
        }
        scrollView.contentOffset = CGPoint(x:viewSize.size.width, y:0)
        
        self.userInteractionEnabled = true
        self.addSubview(scrollView)
//
//        //说明文字层
//        float myHeight = height?height:34;
//        
//        UIView *noteView=[[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-myHeight,self.bounds.size.width,myHeight)];
//        noteView.userInteractionEnabled = NO;
//        [noteView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
//        
//        float pageControlWidth=(pageCount-2)*10.0f+40.f;
//        float pagecontrolHeight=myHeight;
//        pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake((self.frame.size.width-pageControlWidth),0, pageControlWidth, pagecontrolHeight)];
//        pageControl.currentPage=0;
//        pageControl.numberOfPages=(pageCount-2);
//        [noteView addSubview:pageControl];
//        
//        noteTitle.userInteractionEnabled = NO;
//        noteTitle=[[UILabel alloc] initWithFrame:CGRectMake(5, 0, self.frame.size.width-pageControlWidth-15, myHeight)];
//        [noteTitle setText:[titleArray objectAtIndex:0]];
//        [noteTitle setBackgroundColor:[UIColor clearColor]];
//        [noteTitle setFont:[UIFont systemFontOfSize:13]];
//        [noteTitle setTextColor:[UIColor whiteColor]];
//        [noteView addSubview:noteTitle];
//        
//        [self addSubview:noteView];
//        
        var timer:NSTimer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "autoShowNextPage", userInfo: nil, repeats: true)


        return self
    }
    
    func autoShowNextPage() {
        println("111")
        if pageControl.currentPage + 1 < titleArray.count {
            currentPageIndex = pageControl.currentPage + 1
            self.changeCurrentPage()
        }else{
            currentPageIndex = 0;
            self.changeCurrentPage()
        }
    }
    
    func changeCurrentPage (){
        var offX = scrollView.frame.size.width * Float(currentPageIndex+1)
        scrollView.setContentOffset(CGPoint(x:offX, y:scrollView.frame.origin.y), animated:true)
        self.scrollViewDidScroll(scrollView);
    }
    
    func imagePressed () {
        println("click")
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView!) {
        var pageWidth:Int = Int(scrollView.frame.size.width)
        var offX:Int = Int(scrollView.contentOffset.x)
        var a = offX - pageWidth / 2 as Int
        var b = a / pageWidth as Int
        var c = floor(Double(b))
        var page:Int = Int(c) + 1
        currentPageIndex=page
        pageControl.currentPage=(page-1)
        var titleIndex=page-1
        if (titleIndex==titleArray.count) {
        titleIndex=0;
        }
        if (titleIndex<0) {
        titleIndex=titleArray.count-1;
        }
//        [noteTitle setText:[titleArray objectAtIndex:titleIndex]];
    }


}
