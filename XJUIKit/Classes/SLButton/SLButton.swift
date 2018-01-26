//
//  SLButton.swift
//  Jianghu
//
//  Created by shanlin on 2017/10/26.
//  Copyright © 2017年 善林(上海)金融信息服务有限公司. All rights reserved.
//

import UIKit

public class SLButton: UIButton {

    fileprivate var style: SLButtonStyle!
    public init(frame: CGRect, style: SLButtonStyle) {
        super.init(frame: frame)
        self.style = style
        setupUI()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        guard let imageView = imageView else { return }
        guard let titleLabel = titleLabel else { return }
        
        if style.buttonType == .leftIcon {
            
            imageView.frame = CGRect(x: style.leftIconMargin, y: 0, width: imageView.bounds.width, height: imageView.bounds.height)
            imageView.center.y = self.bounds.height * 0.5
            
            titleLabel.frame = CGRect(x: imageView.frame.maxX + style.horizontalMargin, y: 0, width: titleLabel.bounds.width, height: titleLabel.bounds.height)
            titleLabel.center.y = imageView.center.y

        }else if style.buttonType == .rightIcon {
            
            imageView.frame = CGRect(x: self.bounds.width - style.rightIconMargin - imageView.bounds.width, y: 0, width: imageView.bounds.width, height: imageView.bounds.height)
            imageView.center.y = self.bounds.height * 0.5
            
            titleLabel.frame = CGRect(x: imageView.frame.origin.x - style.horizontalMargin - titleLabel.bounds.width, y: 0, width: titleLabel.bounds.width, height: titleLabel.bounds.height)
            titleLabel.center.y = imageView.center.y
            
        }else if style.buttonType == .topIcon{
            
            imageView.frame = CGRect(x: 0, y: style.topIconMargin, width: imageView.bounds.width, height: imageView.bounds.height)
            imageView.center.x = self.bounds.width * 0.5
            
            titleLabel.frame = CGRect(x: 0, y: imageView.frame.maxY + style.verticalMargin, width: titleLabel.bounds.width, height: titleLabel.bounds.height)
            titleLabel.center.x = imageView.center.x
        }else if style.buttonType == .bottomIcon {
            imageView.frame = CGRect(x: 0, y: self.bounds.height - imageView.bounds.height - style.bottomIconMargin, width: imageView.bounds.width, height: imageView.bounds.height)
            imageView.center.x = self.bounds.width * 0.5
            
            titleLabel.frame = CGRect(x: 0, y: imageView.frame.origin.y - style.verticalMargin - titleLabel.bounds.height, width: titleLabel.bounds.width, height: titleLabel.bounds.height)
            titleLabel.center.x = imageView.center.x
        }
    }
}

extension SLButton {
    fileprivate func setupUI() {
        
        setImage(style.icon, for: .normal)
        setImage(style.icon, for: .highlighted)
        imageView?.isUserInteractionEnabled = false
        
        setTitle(style.title, for: .normal)
        setTitleColor(style.titleColor, for: .normal)
        titleLabel?.font = style.titleFont
        titleLabel?.textAlignment = .center
        sizeToFit()
        titleLabel?.numberOfLines = 0
        
        // self.bounds.width 表示文字和图片的宽度
        switch style.buttonType {
            case .leftIcon?:
                 self.frame.size.width = self.bounds.width + style.leftIconMargin * 2 + style.horizontalMargin
                 self.bounds.size.height = self.getRealHeight(width: self.frame.size.width)
                 self.frame.size.height = style.btnHeight != 32 ? style.btnHeight : (self.bounds.height + 2 * style.topIconMargin)
            case .rightIcon?:
                 self.frame.size.width = self.bounds.width + style.rightIconMargin * 2 + style.horizontalMargin
                 self.bounds.size.height = self.getRealHeight(width: self.frame.size.width)
                 self.frame.size.height = style.btnHeight != 32 ? style.btnHeight : (self.bounds.height + 2 * style.topIconMargin)
            case .topIcon?:
                 self.frame.size.width = self.bounds.width + style.horizontalMargin
                 self.bounds.size.height = self.getRealHeight(width: self.frame.size.width)
                 var imgH: CGFloat = imageView?.bounds.height ?? 0
                 imgH = style.title.characters.count == 0 ? imgH : self.bounds.height
                 self.frame.size.height =  imgH + style.verticalMargin + style.topIconMargin * 2
            case .bottomIcon?:
                self.frame.size.width = self.bounds.width + style.horizontalMargin
                self.bounds.size.height = self.getRealHeight(width: self.frame.size.width)
                var imgH: CGFloat = imageView?.bounds.height ?? 0
                imgH = style.title.characters.count == 0 ? imgH : self.bounds.height
                self.frame.size.height = imgH + style.verticalMargin + style.bottomIconMargin * 2
        default:
            return
        }
        
    }
}

extension SLButton {
    fileprivate func getRealHeight(width: CGFloat) -> CGFloat {
        let realSize = titleLabel?.text?.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: style.titleFont], context: nil).size
        return (imageView?.bounds.height ?? 0) + (realSize?.height ?? 0)
    }
}
