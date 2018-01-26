//
//  String_Extension.swift
//
//  Created by lishengbing on 2017/10/10.
//  Copyright © 2017年 shanlin. All rights reserved.
// 链接：http://blog.csdn.net/h643342713/article/details/54292935

//*********************** 科普1 ***********************\\

/** * 手机号码  * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
 * 联通：130,131,132,152,155,156,185,186
 * 电信：133,1349,153,180,189,181(增加) */
let MOBIL = "^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
/** * 中国移动：China Mobile * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188 */ let CM = "^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
/** * 中国联通：China Unicom * 130,131,132,152,155,156,185,186 */
let CU = "^1(3[0-2]|5[256]|8[56])\\d{8}$";
/** * 中国电信：China Telecom * 133,1349,153,180,189,181(增加) */
let CT = "^1((33|53|8[019])[0-9]|349)\\d{7}$";


//*********************** 科普2 ***********************\\

/*
 typedef NS_OPTIONS(NSUInteger, NSRegularExpressionOptions) {
 
 // 不区分大小写的
 NSRegularExpressionCaseInsensitive             = 1 << 0,     /* Match letters in the pattern independent of case. */
 
 // 忽略空格和# -
 NSRegularExpressionAllowCommentsAndWhitespace  = 1 << 1,     /* Ignore whitespace and #-prefixed comments in the pattern. */
 
 // 整体化
 NSRegularExpressionIgnoreMetacharacters        = 1 << 2,     /* Treat the entire pattern as a literal string. */
 
 // 匹配任何字符，包括行分隔符
 NSRegularExpressionDotMatchesLineSeparators    = 1 << 3,     /* Allow . to match any character, including line separators. */
 
 // 允许^和$在匹配的开始和结束行
 NSRegularExpressionAnchorsMatchLines           = 1 << 4,     /* Allow ^ and $ to match the start and end of lines. */
 
 (查找范围为整个的话无效)
 NSRegularExpressionUseUnixLineSeparators       = 1 << 5,     /* Treat only \n as a line separator (otherwise, all standard line separators are used). */
 
 (查找范围为整个的话无效)
 NSRegularExpressionUseUnicodeWordBoundaries    = 1 << 6      /* Use Unicode TR#29 to specify word boundaries (otherwise, traditional regular expression word boundaries are used). */
 };
 */


//*********************** 科普3 ***********************\\

/*  替换类的其他用法：
 // 1-匹配字符串中所有的符合规则的字符串, 返回匹配到的NSTextCheckingResult数组
 public func matchesInString(string: String, options: NSMatchingOptions, range: NSRange) -> [NSTextCheckingResult]
 
 // 2-按照规则匹配字符串, 返回匹配到的个数
 public func numberOfMatchesInString(string: String, options: NSMatchingOptions, range: NSRange) -> Int
 
 // 3-按照规则匹配字符串, 返回第一个匹配到的字符串的NSTextCheckingResult
 public func firstMatchInString(string: String, options: NSMatchingOptions, range: NSRange) -> NSTextCheckingResult?
 
 // 4-按照规则匹配字符串, 返回第一个匹配到的字符串的范围
 public func rangeOfFirstMatchInString(string: String, options: NSMatchingOptions, range: NSRange) -> NSRange
 
 */


//*********************** 科普4 ***********************\\

/* 例如: 匹配结果集
 "@coderwhy:【动物尖叫合辑】#肥猪流#猫头鹰这么尖叫[偷笑]、@撒拉嘿: 老鼠这么尖叫、兔子这么尖叫[吃惊]、@花满楼: 莫名奇#小笼包#妙的笑到最后[好爱哦]！~ http://t.cn/zYBuKZ8/"
 // 1.创建匹配规则
 // let pattern = "@.*?:" // 匹配出来@coderwhy:
 // let pattern = "#.*?#" // 匹配话题
 // let pattern = "\\[.*?\\]" // 匹配表情
 let pattern = "http(s)?://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)?" // URL网址
 
 备注 1: 匹配出来@coderwhy:let pattern = "@.*?:" ,其中 .* 用来表示表示任意字符，加上 ？来表示，只要遇到:就立即停止匹配，没有？的话，它会一直匹配到最后一个:
 */



import Foundation

public enum SLRegex: String {
    
    /// 邮箱:  验证是否是合法的邮箱
    case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    
    /// 手机号: 验证是否是合法手机号：
    case phone = "^1[0-9]{10}$"
    
    /// 姓名:  验证匹配用户姓名，20位的（中文或英文） (20)
    case username = "^[a-zA-Z\\u4E00-\\u9FA5]{1,20}"
    
    /// URL:  验证匹配合法URL
    case url = "http(s)?://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)?"
    
    /// 密码:  验证匹配用户密码（6-18）位（数字 + 字母）组合
    case password = "^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}"
    
    /// 身份证: 验证匹配用户身份证号是15 或 18位---> 合法
    case idCard = "(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)"
    
    /// 表情：  验证匹配是否是表情
    case emoji = "[\\U00010000-\\U0010FFFF]"
    
    /// IP地址：验证ip地址
    //case ip_regex = "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
    
    /// 车牌号：验证车牌号
    case carNumber = "^[A-Za-z]{1}[A-Za-z_0-9]{5}$"
}

public extension String {
    
    // MARK: - 正则匹配_验证类
    /*
     * regex:  正则表达式
     * bool:   返回一个布尔值
     */
    public func isValidString(_ regex: String) -> Bool {
        if regex.characters.count == 0{
            print("************\n警告:{\n    需要从默认枚举中选择一个正则表达式或者自定义一个正则表达式以字符串传入\n}\n************")
            return false
        }
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    
    
    
    // MARK: -  正则匹配_替换类
    /*
     * regex:   正则表达式
     * with:    要替换的字符串
     * options: 选择检测的风格：默认为不区分大小写的、直接写"[]"
     * String:  返回一个新的字符串
     */
    public mutating func isMatchReplace(_ regex: String, with: String, options: NSRegularExpression.Options) -> String {
        let result = self.isMatchOK(regex, with: with, options: options)
        return result.newRegex.stringByReplacingMatches(in: self, options: [], range: result.range, withTemplate: with)
    }
    
    
    // MARK: -  正则匹配的第一个符合条件的位置 
    /*
     * regex:   正则表达式
     * with:    要替换的字符串
     * options: 选择检测的风格：默认为不区分大小写的、直接写"[]"
     * NSRange:  返回匹配的第一个字符串的位置
     */
    public mutating func rangeOfFirstMatchInString(_ regex: String, with: String, options: NSRegularExpression.Options) -> NSRange {
        let result = self.isMatchOK(regex, with: with, options: options)
        return result.newRegex.rangeOfFirstMatch(in: self, options: [], range: result.range)
    }
    
    
    
    // MARK: -   正则匹配_结果类
    /*           匹配字符串中所有的符合规则的字符串, 返回匹配到的NSTextCheckingResult数组
     * regex:    正则表达式
     * with:     要替换的字符串
     * options:  选择检测的风格：默认为不区分大小写的、直接写"[]"
     * [String]: 返回一个查找出来的字符串数组
     */
    public mutating func isMatchResult(_ regex: String, with: String, options: NSRegularExpression.Options) -> [String] {
        let result = self.isMatchOK(regex, with: with, options: options)
        let textCheckingResults = result.newRegex.matches(in: self, options: [], range: result.range)
        var arr: [String] = [String]()
        for textResult in textCheckingResults {
            let str = (self as NSString).substring(with: textResult.range)
            arr.append(str)
        }
        return arr
    }
    
    
    
    /// 私有方法：正则匹配
    fileprivate mutating func isMatchOK(_ regex: String, with: String, options: NSRegularExpression.Options) -> (newRegex: NSRegularExpression, range: NSRange) {
        if regex.characters.count == 0{
            print("************\n警告:{\n    需要从默认枚举中选择一个正则表达式或者自定义一个正则表达式以字符串传入\n}\n************")
            return (NSRegularExpression(), NSRange())
        }
        if (self.range(of: "❤️") != nil) { self = replacingOccurrences(of: "❤️", with: "") }
        guard let newRegex = try? NSRegularExpression(pattern: regex, options: options) else { return (NSRegularExpression(), NSRange()) }
        let range = NSMakeRange(0, self.utf16.count)
        return (newRegex, range)
    }
}


// -----------------------------------------------------------------------------//
// -----------------------------------------------------------------------------//


public extension String {
    
    // MARK: -      时长转化为 09:08 或者 01:36:10 格式
    /*
     *  duration:   时长
     *  String:     返回结果有两种格式:
     *  1: 01:36:10 格式
     *  2: 09:08    格式
     */
    public static func gettimeStrWithduration(duration: Int) -> String {
        if duration >= 3600 {
            var hourTime: Int = 0
            var secondTime: Int = 0
            var minTime: Int = duration
            
            hourTime = duration / 3600
            secondTime = duration / 60 % 60
            minTime = duration % 60
            return String(format: "%02d:%02d:%02d", arguments: [hourTime, secondTime, minTime])
        }else {
            var secondTime: Int = 0
            var minTime: Int = duration
            if duration >= 60 {
                secondTime = duration / 60
                minTime =  duration % 60
            }
            return String(format: "%02d:%02d", arguments: [secondTime, minTime])
        }
    }
}

