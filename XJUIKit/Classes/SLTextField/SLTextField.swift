//
//  SLTextField.swift
//  测试TextField
//
//  Created by shanlin on 2017/10/26.
//  Copyright © 2017年 shanlin. All rights reserved.
//  http://blog.csdn.net/wangfeng2500/article/details/50176869
//  http://www.jianshu.com/p/e924a52d9f5a
//  [textField setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];//修改颜色
//  FIXME: 这个方法虽然可以移动光标位置、但是会让你的编辑区域无法和系统一样
//  self.setValue(NSNumber(value: 20), forKey: "paddingLeft")
//  let realSize = style.placeholderText.boundingRect(with: CGSize(width: style.lightPointerLeftMargin - style.lightPointerRightMargin, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: style.placeholderFont], context: nil).size
/*
 1: 注意点：
 1: 系统讲究placeHoder的字体和输入的文字的字体是一致的，所以默认居中显示的placeHoder
 */






import UIKit

public class SLTextField: UITextField {

    // MARK: - 更新样式
    public var updateStyle: SLTextFieldStyle? {
        get {
            return self.style
        }
        
        set {
            self.style = newValue
            self.setupUI()
        }
    }
    
    // MARK: - 返回外界输入文字内容
    public typealias TextFieldCallBack = (_ text: String, _ limitMessage: String) -> ()
    public var textFieldCallBack: TextFieldCallBack?
    public typealias TextFieldCodeCallback = (_ codeExplain: String, _ btn: UIButton) -> ()
    public var textFieldCodeCallBack: TextFieldCodeCallback?
    
    
    fileprivate var style: SLTextFieldStyle!
    /// left
    fileprivate lazy var leftImageV: UIImageView = UIImageView()
    fileprivate lazy var leftLabel: UILabel = UILabel()
    fileprivate lazy var leftCustomView: UIView = UIView()
    /// right
    fileprivate lazy var rightCustomView: SLTextFieldRightView = SLTextFieldRightView()
    /// left and right bgView
    fileprivate lazy var leftBgView: UIView = UIView()
    fileprivate lazy var rightBgView: UIView = UIView()
    /// timer
    fileprivate var timer: Timer?
    fileprivate static var timerNumber: Int = 0
    /// tempArray(获取验证码模版参考)
    fileprivate var tempArray: [String] = [String]()
    /// Graphics and code api request result
    fileprivate var isSuccess: Bool = true
    /// observe text
    fileprivate var inputText: String = ""
    
    
     override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public init(frame: CGRect, style: SLTextFieldStyle) {
        super.init(frame: frame)
        self.style = style
        setupUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 重写该方法、设置placeholderFrame
    override public func placeholderRect(forBounds bounds: CGRect) -> CGRect {
       return setupPlaceholderRect(forBounds: bounds)
    }
    
    /// 重写该方法、修改光标左边位置 和 右边的位置
    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        return setupEditingRect(forBounds: bounds)
    }
    
    /// 重写该方法、修改左边视图的内容区域 ，保证内容不偏移
    override public func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        let rect = setupEditingRect(forBounds: bounds)
        return CGRect(x: bounds.origin.x, y: bounds.origin.y, width: rect.origin.x, height: bounds.height)
    }
    
    /// 重写该方法、修改右边视图的内容区域 ，保证内容不偏移
    /*
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let rect = setupEditingRect(forBounds: bounds)
        return CGRect(x: rect.maxX, y: bounds.origin.y, width: bounds.width - rect.maxX + 10, height: bounds.height)
    }*/
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        let attrStr: NSAttributedString = NSAttributedString(string: style.placeholderText, attributes: [NSForegroundColorAttributeName: style.placeholderTextColor, NSFontAttributeName: style.textFont])
        self.attributedPlaceholder = attrStr
        
        
        /// left layout
        setupLeftViewLayout()
        
        /// right layout
       setupRightViewLayout()
    }
    
    deinit {
        removeTimer()
        NotificationCenter.default.removeObserver(self)
        if style.isDeinitPrint {
            print("\(self.classForCoder)类执行了\(#function)方法的打印了...")
        }
    }
}

extension SLTextField {
    fileprivate func setupUI() {
        
        /// 文本和光标设置
        self.tintColor = style.tintColor
        self.font = style.textFont
        self.textColor = style.textColor
        
        /// 边框设置
        self.layer.masksToBounds = true
        self.layer.borderColor = style.borderColor.cgColor
        self.layer.borderWidth = style.borderWidth
        
        /// placeholder
        self.placeholder = style.placeholderText
        
        /// left and right
        dealLeftView(style: style)
        dealRightView(style: style)
        
        /// close click
        self.clearButtonMode = .whileEditing
        
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChanage), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
        self.delegate = self
        DispatchQueue.global().async {
           self.synthesisCodeText()
        }
    }
}

extension SLTextField {
    
        /// left  setup
    fileprivate func dealLeftView(style: SLTextFieldStyle) {
        leftBgView.backgroundColor = style.leftBgViewBackgroundColor
        switch style.leftStyle {
            case .leftImage:
                leftImageV.image = style.leftIcon
                leftImageV.sizeToFit()
                leftBgView.addSubview(leftImageV)
            
            case .leftText:
                 leftLabel.text = style.leftLabelText
                 leftLabel.textColor = style.leftLabelTextColor
                 leftLabel.font = style.leftLabelFont
                 leftLabel.sizeToFit()
                 leftBgView.addSubview(leftLabel)
            
            case .customView:
                 self.leftCustomView = style.leftCustomView
                 style.leftCustomView.sizeToFit()
                 leftBgView.addSubview(leftCustomView)
        }
        self.leftView = leftBgView
        self.leftViewMode = .always
    }
    
        /// right setup
    fileprivate func dealRightView(style: SLTextFieldStyle) {
        rightBgView.backgroundColor = style.rightBgViewBackgroundColor
        rightCustomView = SLTextFieldRightView(frame: CGRect.zero, style: style)
        rightCustomView.closeCallBack = { [weak self] (btn) in
            self?.text = ""
            self?.inputText = ""
            self?.rightCustomView.closeBtn.isHidden = true
        }
        rightCustomView.rightBtnTextCallBack = { [weak self] (btn) in
            guard let weakSelf = self else { return }
            weakSelf.willChangeOrResetStatus(isReset: false)
            weakSelf.starTimer()
            if weakSelf.textFieldCodeCallBack != nil {
                weakSelf.textFieldCodeCallBack!("仅短信验证码对象需要在两处执行commitTransaction()方法, 请求验证码接口成功后commitTransaction(true)；deinit方法里commitTransaction(false)", btn)
            }
        }
        
        rightCustomView.rightBtnImageCallBack = { [weak self] (btn) in
            guard let weakSelf = self else { return }
            weakSelf.isSecureTextEntry = btn.isSelected
        }
        
        rightCustomView.rightBtnTransformCallBack = { [weak self] (btn) in
            guard let weakSelf = self else { return }
            weakSelf.text = ""
            weakSelf.rightCustomView.closeBtn.isHidden = true
            if weakSelf.textFieldCodeCallBack != nil {
                weakSelf.textFieldCodeCallBack!("请求图形验证码接口成功以后，需要push下一接口之前调用commitTransaction()方法", weakSelf.rightCustomView.rightBtn)
            }
        }
        
        rightCustomView.sizeToFit()
        self.rightBgView.addSubview(rightCustomView)
        self.rightView = self.rightBgView
        self.rightViewMode = .always
    }
}


extension SLTextField {
    fileprivate func setupPlaceholderRect(forBounds bounds: CGRect) -> CGRect {
        var x: CGFloat = 0
        switch style.leftStyle {
            case .leftImage:
                if leftImageV.bounds.width == 0 {
                    x = bounds.origin.x + style.pointerLeftMargin + style.pointerToPlaceHolderMargin
                }else {
                    x = bounds.origin.x + style.leftMargin + leftImageV.bounds.width + style.placeHolderToLeftViewMargin
                }
        case .leftText:
                if leftLabel.text?.characters.count == 0 {
                    x = bounds.origin.x + style.pointerLeftMargin + style.pointerToPlaceHolderMargin
                }else {
                    x = bounds.origin.x + style.leftMargin + style.placeHolderToLeftViewMargin + leftLabel.bounds.width
            }
        case .customView:
            x = bounds.origin.x + style.leftMargin + leftCustomView.bounds.width + style.placeHolderToLeftViewMargin
        }
        
        var rightPointerW: CGFloat = style.pointerRightMargin
        rightPointerW = style.pointerRightMargin != -1 ? style.pointerRightMargin : rightCustomView.bounds.width
        let rect = CGRect(x: x, y: 0, width: bounds.size.width - x - rightPointerW, height: bounds.size.height)
        return rect
    }
    
    fileprivate func setupEditingRect(forBounds bounds: CGRect) -> CGRect {
        var x: CGFloat = 0
        switch style.leftStyle {
        case .leftImage:
            if leftImageV.bounds.width == 0 {
                x = bounds.origin.x + style.pointerLeftMargin
            }else {
                x = bounds.origin.x + style.leftMargin + leftImageV.bounds.width + style.pointerToLeftViewMargin
            }
        case .leftText:
            if leftLabel.text?.characters.count == 0 {
                x = bounds.origin.x + style.pointerLeftMargin
            }else {
                x = bounds.origin.x + style.leftMargin + leftLabel.bounds.width + style.pointerToLeftViewMargin
            }
        case .customView:
            x = bounds.origin.x + style.leftMargin + leftCustomView.bounds.width + style.pointerToLeftViewMargin
        }
        var rightPointerW: CGFloat = style.pointerRightMargin
        rightPointerW = style.pointerRightMargin != -1 ?  style.pointerRightMargin : rightCustomView.bounds.width
        let rect = CGRect(x: x, y: 0, width: bounds.size.width - x - rightPointerW, height: bounds.size.height)
        return rect
    }
    
    fileprivate func setupLeftViewLayout() {
        var maxX: CGFloat = 0
        switch style.leftStyle {
        case .leftImage:
            leftImageV.frame = CGRect(x: style.leftMargin, y: (self.bounds.height - leftImageV.bounds.height) * 0.5, width: leftImageV.bounds.width, height: leftImageV.bounds.height)
            maxX = leftImageV.frame.maxX
        case .leftText:
            leftLabel.frame = CGRect(x: style.leftMargin, y: (self.bounds.height - leftLabel.bounds.height) * 0.5, width: leftLabel.bounds.width, height: leftLabel.bounds.height)
            maxX = leftLabel.frame.maxX
        case .customView:
            leftCustomView.frame = CGRect(x: style.leftMargin, y: (self.bounds.height - leftCustomView.bounds.height) * 0.5, width: leftCustomView.bounds.width, height: self.bounds.height)
            maxX = leftCustomView.frame.maxX
        }
        leftBgView.frame = CGRect(x: 0, y: 0, width: maxX, height: self.bounds.height)
    }
    
    fileprivate func setupRightViewLayout() {
        let w: CGFloat = style.closeToRightViewX + rightCustomView.closeBtn.bounds.width + style.closeToRightViewPadding + rightCustomView.rightBtn.bounds.width + style.rightMargin
        rightBgView.frame = CGRect(x: self.bounds.width - w , y: 0, width: w, height: self.bounds.height)
        rightCustomView.frame = CGRect(x: 0, y: 0, width: rightBgView.bounds.width, height: self.bounds.height)
    }
}

extension SLTextField: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        var newText: String = self.inputText + string
        var str: String = newText
        if newText.characters.count == style.limitLength + 1{
            newText = (newText as NSString).substring(to: style.limitLength)
            str = newText.trimmingCharacters(in: CharacterSet(charactersIn: " "))
            self.text = newText
            if textFieldCallBack != nil {
                textFieldCallBack!(str, "输入的文字不能超过\(style.limitLength)位")
            }
            return false
        }else {
            if textFieldCallBack != nil {
                textFieldCallBack!(str, "")
            }
            return true
        }
    }
    
    
   @objc func textFieldDidChanage() {
        self.rightCustomView.closeBtn.isHidden = !self.hasText
        self.inputText = self.text ?? ""
    }
    
    /// methodName: String = #function
    @objc public func commitTransaction(isSuccess: Bool, methodName: String = #function) {
        self.isSuccess = isSuccess
        if style.isGraphicsCode {
            rightCustomView.removeAnim()
            willChangeOrResetStatus(isReset: true)
        }else {
            if self.responds(to: #selector(starTimer)) {
                removeTimer()
                willChangeOrResetStatus(isReset: true)
            }
        }
    }
}

extension SLTextField {
   @objc fileprivate func starTimer() {
        removeTimer()
        timer = Timer(timeInterval: 1.0, target: self, selector: #selector(dealTimer), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .commonModes)
    }
    
    fileprivate func removeTimer() {
        timer?.invalidate()
        timer = nil
        SLTextField.timerNumber = 0
    }
    
    @objc fileprivate func dealTimer() {
        print("\(SLTextField.timerNumber)")
        SLTextField.timerNumber += 1
        let n = style.rightCodeTimerBeginValue - SLTextField.timerNumber
        
        if n < 0 {
            self.removeTimer()
            self.rightCustomView.rightBtn.isUserInteractionEnabled = true
            self.rightCustomView.rightBtn.setTitle(style.rightCodeResetText, for: .normal)
        }else{
            let text = setupCodeText(n: n)
            self.rightCustomView.rightBtn.setTitle(text, for: .normal)
        }
        self.rightCustomView.rightBtn.sizeToFit()
        self.setupRightViewLayout()
    }
    
    fileprivate func willChangeOrResetStatus(isReset: Bool) {
        if isReset {
            if style.rightStyle == .rightText {
                self.rightCustomView.rightBtn.setTitle(style.rightCodeText, for: .normal)
                self.rightCustomView.rightBtn.isUserInteractionEnabled = true
            }else if style.rightStyle == .rightImage {
                self.rightCustomView.rightBtn.setImage(style.rightImageGraphicsCodeNormal, for: .normal)
                if !isSuccess {
                    self.rightCustomView.transformBtn.setImage(style.rightImageTransformNormal, for: .normal)
                }else {
                    self.rightCustomView.transformBtn.setImage(UIImage(), for: .normal)
                }
            }
            
        }else {
            let text = setupCodeText(n: style.rightCodeTimerBeginValue)
            self.rightCustomView.rightBtn.setTitle(text, for: .normal)
            self.rightCustomView.rightBtn.isUserInteractionEnabled = false
        }
        self.text = ""
        self.inputText = ""
        self.rightCustomView.closeBtn.isHidden = true
        self.rightCustomView.rightBtn.sizeToFit()
        self.setupRightViewLayout()
        
    }
    
    fileprivate func synthesisCodeText(){
        // 1. 匹配第一个符合条件的位置
        //let range = style.rightCodeTextTemplate.rangeOfFirstMatchInString("[0-9]", with: "", options: [])
        // 2. 替换所有符合条件的数字为空，组成新的字符串
        let str = style.rightCodeTextTemplate.isMatchReplace("[0-9]", with: "|", options: [])
        // 3. 在新的字符串下进行按照第一个符合条件的数字开始插入最新的验证码code数字
        tempArray = (str as NSString).components(separatedBy: "|")
        //print("tempArray=\(tempArray)")
        //tempArray = a.filter({$0.count != 0})
    }
    
    fileprivate func setupCodeText(n: Int) -> String {
        var str: String = ""
        if tempArray.count < 2 {
           str = (tempArray.first ?? "") + "\(n)"
        }else  {
           str = (tempArray.first ?? "") + "\(n)" + (tempArray.last ?? "")
        }
        return str
    }
}

