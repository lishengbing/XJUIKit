//
//  XJTextViewStyle.swift
//  XJTextView
//
//  Created by shanlin on 2017/11/20.
//  Copyright © 2017年 shanlin. All rights reserved.
//

import UIKit

public class XJTextViewStyle {
    
    public init() {}
    
    /// textView
    public var textViewFont: UIFont = UIFont.systemFont(ofSize: 15)
    public var textColor: UIColor = UIColor.black.withAlphaComponent(0.5)
    
    
    /// placeHoderLabel frame 
    public var placeHoderPoint: CGPoint = CGPoint(x: 10, y: 10)
    public var placeHoderText: String = "请输入您的文字~"
    public var placeHoderTextColor: UIColor = UIColor.gray
    public var placeHoderfont: UIFont = UIFont.systemFont(ofSize: 15)
    
    
    /// 光标
    public var textContainerInset: UIEdgeInsets = UIEdgeInsetsMake(10, 6, 0, 6)
    public var tintColor: UIColor = UIColor.orange
    
    
    /// max number
    public var maxNumber: Int = 128
}
