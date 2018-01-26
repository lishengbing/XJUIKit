//
//  XJTextView.swift
//  XJTextView
//
//  Created by shanlin on 2017/11/20.
//  Copyright © 2017年 shanlin. All rights reserved.
//

import UIKit

public class XJTextView: UITextView {
    
    fileprivate lazy var placeHoderLabel: UILabel = UILabel()
    fileprivate var style: XJTextViewStyle!
    
    public typealias TextViewCallBack = (_ textView: XJTextView, _ textNumber: String, _ isHasText: Bool) -> ()
    public var textCallBack: TextViewCallBack?
    
    
    public init(frame: CGRect, textContainer: NSTextContainer?, style: XJTextViewStyle) {
        super.init(frame: frame, textContainer: textContainer)
        self.style = style
        setupUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        let x = style.placeHoderPoint.x
        let y = style.placeHoderPoint.y
        let w = self.bounds.width - x * 2
        let realSize = style.placeHoderText.boundingRect(with: CGSize(width: w, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: style.placeHoderfont], context: nil).size
        placeHoderLabel.frame = CGRect(x: x, y: y, width: w, height: realSize.height)
    }
}

extension XJTextView {
    fileprivate func setupUI() {
        addSubview(placeHoderLabel)
        placeHoderLabel.text = style.placeHoderText
        placeHoderLabel.numberOfLines = 0
        placeHoderLabel.font = style.placeHoderfont
        placeHoderLabel.textColor = style.placeHoderTextColor
        placeHoderLabel.sizeToFit()
        textContainerInset = style.textContainerInset
        delegate = self
        textColor = style.textColor
        font = style.textViewFont
        tintColor = style.tintColor
        keyboardDismissMode = .onDrag
        alwaysBounceVertical = true
    }
}

extension XJTextView: UITextViewDelegate {
    public func textViewDidChange(_ textView: UITextView) {
        dealTextViewDidChange(textView)
    }
    
    public func dealTextViewDidChange(_ textView: UITextView) {
        /// 是否显示和隐藏placeHoderLabel
        placeHoderLabel.isHidden = textView.hasText
        
        /// 去掉空格
        let title = textView.text.trimmingCharacters(in: CharacterSet(charactersIn: " "))
        let isHasText = title.characters.count == 0 ? false : true
        
        /// 计算输入的文字
        if textView.text.characters.count <= style.maxNumber {
            if textCallBack != nil {
                textCallBack!(self, "\(textView.text.characters.count) / \(style.maxNumber)", isHasText)
            }
        }else {
            textView.text = (textView.text as NSString).substring(to: style.maxNumber)
            if textCallBack != nil {
                textCallBack!(self, "\(style.maxNumber) / \(style.maxNumber)", isHasText)
            }
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.endEditing(true)
    } 
}
