//
//  SLTextFieldRightView.swift
//  测试TextField
//
//  Created by shanlin on 2017/11/27.
//  Copyright © 2017年 shanlin. All rights reserved.


import UIKit

class SLTextFieldRightView: UIView {
    
    typealias RightViewBtnCallBack = (_ btn: UIButton) -> ()
    var closeCallBack: RightViewBtnCallBack?
    var rightBtnTextCallBack: RightViewBtnCallBack?
    var rightBtnImageCallBack: RightViewBtnCallBack?
    var rightBtnTransformCallBack: RightViewBtnCallBack?

    lazy var closeBtn: UIButton = UIButton()
    lazy var rightBtn: UIButton = UIButton()
    lazy var contentView: UIView = UIView()
    lazy var transformBtn: UIButton = UIButton()
    
    fileprivate var style: SLTextFieldStyle!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(frame: CGRect, style: SLTextFieldStyle) {
        super.init(frame: frame)
        self.style = style
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        closeBtn.frame = CGRect(x: style.closeToRightViewX, y: 0, width: closeBtn.bounds.width, height: closeBtn.bounds.height)
        closeBtn.center.y = self.center.y
        
        contentView.frame = CGRect(x: closeBtn.frame.maxX, y: 0, width: self.bounds.width - closeBtn.frame.maxX, height: self.bounds.height)
        contentView.center.y = closeBtn.center.y
        
        rightBtn.frame = CGRect(x: style.closeToRightViewPadding, y: 0, width: rightBtn.bounds.width, height: rightBtn.bounds.height)
        rightBtn.center.y = closeBtn.center.y - style.closeVerticalRightView
        
        transformBtn.frame = CGRect(x: (rightBtn.bounds.width - transformBtn.bounds.width) * 0.5 + style.closeToRightViewPadding, y: 0, width: transformBtn.bounds.width, height: transformBtn.bounds.height)
        transformBtn.center.y = rightBtn.center.y
    }
}

extension SLTextFieldRightView {
    fileprivate func setupUI() {
        addSubview(closeBtn)
        closeBtn.setImage(style.rightCloseNormal, for: .normal)
        closeBtn.setImage(style.rightCloseHL, for: .highlighted)
        closeBtn.addTarget(self, action: #selector(closeClick), for: .touchUpInside)
        closeBtn.sizeToFit()
        closeBtn.isHidden = true
        
        addSubview(contentView)
        setupRightBtn()
        setupRightTransformBtn()
    }
    
    fileprivate func setupRightBtn() {
        contentView.addSubview(rightBtn)
        
        var sel: Selector = #selector(rightEmptyClick)
        switch style.rightStyle {
        case .rightCloseOnly:
            
            rightBtn.setTitle("", for: .normal)
            rightBtn.setImage(UIImage(), for: .normal)
            
        case .rightText:
            
            rightBtn.setTitle(style.rightCodeText, for: .normal)
            rightBtn.setTitleColor(style.rightTextColor, for: .normal)
            rightBtn.setTitleColor(style.rightTextColorHL, for: .highlighted)
            rightBtn.titleLabel?.font = style.rightTextFont
            rightBtn.titleLabel?.textAlignment = .center
            sel = #selector(rightBtnTextClick)
            
        case .rightImage:
            
            if style.isGraphicsCode {
                rightBtn.isEnabled = false
                rightBtn.setImage(style.rightImageGraphicsCodeNormal, for: .normal)
            }else {
                rightBtn.isEnabled = true
                rightBtn.setImage(style.rightImageEyeNormal, for: .normal)
                rightBtn.setImage(style.rightImageEyeHL, for: .highlighted)
            }
            rightBtn.contentMode = .scaleAspectFill
            sel = #selector(rightBtnImageClick(_:))
            
        case .customView:
            print("customView")
        }
        rightBtn.sizeToFit()
        rightBtn.addTarget(self, action: sel, for: .touchUpInside)
    }
    
    fileprivate func setupRightTransformBtn() {
        contentView.addSubview(transformBtn)
        transformBtn.setImage(style.rightImageTransformNormal, for: .normal)
        transformBtn.addTarget(self, action: #selector(rightTransfromClick(_:)), for: .touchUpInside)
        transformBtn.sizeToFit()
        
        if style.isGraphicsCode {
            transformBtn.isHidden = false
        }else {
            transformBtn.isHidden = true
        }
    }
}

extension SLTextFieldRightView {
    
    @objc fileprivate func closeClick() {
        if closeCallBack != nil {
            closeCallBack!(closeBtn)
        }
    }
    @objc fileprivate func rightBtnTextClick() {
        if rightBtnTextCallBack != nil {
            rightBtnTextCallBack!(rightBtn)
        }
    }
    
    @objc fileprivate func rightBtnImageClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let image = sender.isSelected ? style.rightImageEyeSelected : style.rightImageEyeNormal
        rightBtn.setImage(image, for: .normal)
        if rightBtnImageCallBack != nil {
            rightBtnImageCallBack!(sender)
        }
    }
    
    @objc fileprivate func rightEmptyClick() {
        /// 空置
    }
    
    @objc fileprivate func rightTransfromClick(_ sender: UIButton) {
        // 1.0更换图片:
        sender.isSelected = !sender.isSelected
        
        /// 1.1:
        sender.setImage(style.rightImageTransformLoading, for: .normal)
        sender.isUserInteractionEnabled = false
        rightBtn.setImage(style.rightImageGraphicsCodeNormal, for: .normal)
        
        // 2.0开始转动按钮
        starAnim()
        
        // 3.0暴露给外界进行进行接口请求
        if rightBtnTransformCallBack != nil {
            rightBtnTransformCallBack!(sender)
        }
    }
    
    fileprivate func starAnim() {
        let anim = CABasicAnimation(keyPath: "transform.rotation.z")
        anim.fromValue = self.transformBtn.frame.origin.x
        anim.toValue = Double.pi
        anim.duration = 10
        anim.repeatCount = MAXFLOAT
        anim.fillMode = kCAFillModeForwards
        anim.isRemovedOnCompletion = false
        anim.isCumulative = true
        self.transformBtn.layer.add(anim, forKey: "positon")
    }
    
     func removeAnim() {
        /// 1. 移除动画
        transformBtn.layer.removeAllAnimations()
        /// 2. 转动按钮的点击事件打开
        transformBtn.isUserInteractionEnabled = true
    }
}

