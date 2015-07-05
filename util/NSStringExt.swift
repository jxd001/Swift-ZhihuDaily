//
//  NSStringExtension.swift
//  JokeClient-Swift
//
//  Created by YANGReal on 14-6-6.
//  Copyright (c) 2014年 YANGReal. All rights reserved.
//
import UIKit
import Foundation

extension String {
   
    func stringHeightWith(fontSize:CGFloat,width:CGFloat)->CGFloat
    {
        let font = UIFont.systemFontOfSize(fontSize)
        let size = CGSizeMake(width,CGFloat.max)
       // var attr = [font:NSFontAttributeName]
      

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .ByWordWrapping;
        let  attributes = [NSFontAttributeName:font,
            NSParagraphStyleAttributeName:paragraphStyle.copy()]
        
        let text = self as NSString
        let rect = text.boundingRectWithSize(size, options:.UsesLineFragmentOrigin, attributes: attributes, context:nil)
      
        return (rect.size.height)
        
    }
    
    func dateStringFromTimestamp(timeStamp:NSString)->String
    {
        let ts = timeStamp.doubleValue
        
        //var date = NSDate.timeIntervalSince1970: NSTimeInterval { get }
        let  formatter = NSDateFormatter ()
        formatter.dateFormat = "yyyy年MM月dd日 HH:MM:ss"
//        var date = formatter.dateFromString(timeStamp)
//        println(date)
//        return "2014-01-01"
//       // return formatter.stringFromDate(date)
//        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:1296035591];
//        NSLog(@"1296035591  = %@",confromTimesp);
//        NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
//        NSLog(@"confromTimespStr =  %@",confromTimespStr);
        
        let date = NSDate(timeIntervalSince1970 : ts)
         return  formatter.stringFromDate(date)
        
    }
    
}
