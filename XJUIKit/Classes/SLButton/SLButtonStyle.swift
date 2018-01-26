//
//  SLButtonStyle.swift
//  Jianghu
//
//  Created by shanlin on 2017/10/26.
//  Copyright © 2017年 善林(上海)金融信息服务有限公司. All rights reserved.
//

import UIKit


public enum SLButtonType {
    /// 图标在左边
    case leftIcon
    /// 图标在右边
    case rightIcon
    /// 图标在上面
    case topIcon
    /// 图标在底部
    case bottomIcon
}
public class SLButtonStyle {
    
    public init() {}
    /// 默认图标在左边 
    public var buttonType: SLButtonType? = .leftIcon
    /// 图标
    public var icon: UIImage = SLButtonStyle.getImageResource(imageName: "icon_downDark@2x.png")
    /// 文字
    public var title: String = "上海市"
    /// 文字颜色
    public var titleColor: UIColor = UIColor.black
    /// 文字字体
    public var titleFont: UIFont = UIFont.systemFont(ofSize: 13)
    
    /// 左边icon的间距： 当图标在(左边)设置有效
    public var leftIconMargin: CGFloat = 5
    /// 右边icon的间距： 当图标在(右边)设置有效
    public var rightIconMargin: CGFloat = 5
    /// 水平间距（图标和文字之间的间距）
    public var horizontalMargin: CGFloat = 5
    
    /// 顶部icon的间距： 当图标在(顶部)设置有效
    public var topIconMargin: CGFloat = 5
    /// 底部icon的间距： 当图标在(底部)设置有效
    public var bottomIconMargin: CGFloat = 5
    /// 垂直间距 (图标和文字之间的间距）
    public var verticalMargin: CGFloat = 5
    
    /// 按钮的默认高度: 当文字和图片处于水平的时候、设置有效果！
    public var btnHeight: CGFloat = 32
}


extension SLButtonStyle {
    class func getImageResource(imageName: String) -> UIImage {
        let b = (imageName as NSString).range(of: "@2x.png").length != 0
        assert(b == true, "资源包需要全名输入、包括@2x.png后缀")
        let currentBundle = Bundle(for: self)
        guard let path = currentBundle.path(forResource: imageName, ofType: nil, inDirectory: "XJUIKit.bundle") else { return UIImage() }
        return UIImage(contentsOfFile: path) ?? UIImage()
    }
}
