//
//  SLTextFieldStyle.swift
//  测试TextField
//
//  Created by shanlin on 2017/10/26.
//  Copyright © 2017年 shanlin. All rights reserved.
//

import UIKit


public enum SLLeftViewMode {
    case leftImage
    case leftText
    case customView
}

public enum SLRightViewMode {
    case rightCloseOnly
    case rightImage
    case rightText
    case customView
}

public class SLTextFieldStyle: NSObject {
    public override init() {}
    
    /// placeHolder
    public var placeholderText: String = "请输入你的文字"
    public var placeholderTextColor: UIColor = UIColor.gray
    
    /// textField
    public var text: String = ""
    public var textColor: UIColor = UIColor.black
    public var textFont: UIFont = UIFont.systemFont(ofSize: 15)
    public var borderColor: UIColor = UIColor.white
    public var borderWidth: CGFloat = 0.5
    
    
    
    /// **************************pointer(光标)
    /// 光标pointer的颜色
    public var tintColor: UIColor = UIColor.orange
    /// 设置光标初始化位置，距离左边间距
    public var pointerLeftMargin: CGFloat = 15
    /// 等于-1的时候默认为右边view距离10公分 ，如果自定义的话就按照用户去设置
    public var pointerRightMargin: CGFloat = -1
    /// 光标位置和placeholder的间距： 这个属性默认没有左边图片的情况下可有效 ，默认两者是一致的起点
    public var pointerToPlaceHolderMargin: CGFloat = 0
    
    
    
    
    /// left margin && right margin
    /// 左边View距离左边的间距
    public var leftMargin: CGFloat = 15
    /// 右边View距离右边的间距
    public var rightMargin: CGFloat = 10
    /// 光标距离左边图标的距离
    public var pointerToLeftViewMargin: CGFloat = 6
    /// placeHolder距离左边图标的距离
    public var placeHolderToLeftViewMargin: CGFloat = 6
    
    
    
    
    /// 清空按钮加在右边view上的 起点X值
    public var closeToRightViewX: CGFloat = 0
    /// 清空按钮 距离 右边view的间距， 默认为 10公分
    public var closeToRightViewPadding: CGFloat = 10
    
    
    
    
    
    /// leftBgView && rightBgView
    public var leftBgViewBackgroundColor: UIColor = UIColor.clear
    public var rightBgViewBackgroundColor: UIColor = UIColor.clear
    /// left and  right (style)
    public var leftStyle: SLLeftViewMode = .leftImage
    public var rightStyle: SLRightViewMode = .rightCloseOnly
    
    
    
    
    /// 左边图片
    public var leftIcon: UIImage = SLTextFieldStyle.getImageResource(imageName: "icon_search2@2x.png")
    /// 左边文字
    public var leftLabelText: String = "手机号: "
    public var leftLabelTextColor: UIColor = UIColor.black
    public var leftLabelFont: UIFont = UIFont.systemFont(ofSize: 15)
    /// 左边自定义view
    public var leftCustomView: UIView = UIView()
    
    
    
    
    /// 右边短信验证码
    public var rightCodeText: String = "发送验证码"
    public var rightCodeResetText: String = "重新获取验证码"
    public var rightCodeTextTemplate: String = "60s"
    public var rightCodeTimerBeginValue: Int = 60
    public var rightTextColor: UIColor = UIColor.black
    public var rightTextColorHL: UIColor = UIColor.gray
    public var rightTextFont: UIFont = UIFont.systemFont(ofSize: 15)
    
    /// 右边图片（眼睛）
    public var rightImageEyeNormal: UIImage = SLTextFieldStyle.getImageResource(imageName: "inputField_eyeOpen@2x.png")
    public var rightImageEyeHL: UIImage = SLTextFieldStyle.getImageResource(imageName: "inputField_eyeOpen@2x.png")
    public var rightImageEyeSelected: UIImage = SLTextFieldStyle.getImageResource(imageName: "inputField_eyeClose@2x.png")
    /// 右边图片（图形验证码）
    public var rightImageGraphicsCodeNormal: UIImage = SLTextFieldStyle.getImageResource(imageName: "inputField_imageFailed@2x.png")
    /// 右边图片（图形转动图）
    public var rightImageTransformNormal: UIImage = SLTextFieldStyle.getImageResource(imageName: "inputField_retry@2x.png")
    public var rightImageTransformLoading: UIImage = SLTextFieldStyle.getImageResource(imageName: "inputField_loading@2x.png")
    
    /// 右边清空按钮图 close@2x.png
    public var rightCloseNormal: UIImage = SLTextFieldStyle.getImageResource(imageName: "closeBtnNormal@2x.png")
    public var rightCloseHL: UIImage = SLTextFieldStyle.getImageResource(imageName: "closeBtnHL@2x.png")
    
    /// 右边自定义rightView: 后续增加...
    public var rightCustomView: UIView = UIView()
    
    
    
    
    /// 关闭按钮和眼睛或者文字的水平居中
    public var closeVerticalRightView: CGFloat = 0
    /// 是否是图形验证码
    public var isGraphicsCode: Bool = false
    /// 字数限制, 默认为-2，不限制！
    public var limitLength: Int = -2
    
    /// 是否要检验view层执行了deinit方法的打印 
    public var isDeinitPrint: Bool = false
    
}

extension SLTextFieldStyle {
    class func getImageResource(imageName: String) -> UIImage {
        let b = (imageName as NSString).range(of: "@2x.png").length != 0
        assert(b == true, "资源包需要全名输入、包括@2x.png后缀")
        let currentBundle = Bundle(for: self)
        guard let path = currentBundle.path(forResource: imageName, ofType: nil, inDirectory: "XJUIKit.bundle") else { return UIImage() }
        return UIImage(contentsOfFile: path) ?? UIImage()
    }
}
