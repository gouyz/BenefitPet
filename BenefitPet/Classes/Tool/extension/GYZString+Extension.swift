//
//  GYZString+Extension.swift
//  GYZBaiSi
//  字符串扩展类
//  Created by gouyz on 2016/11/25.
//  Copyright © 2016年 gouyz. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    var htmlToString: String {
        return  try! NSAttributedString.init(data: (self.data(using: .unicode, allowLossyConversion: true))!, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil).string
    }
    
    /// 判断字符串是否为合法手机号 11位 13 14 15 16 17 18 19开头
    ///
    /// - returns: 合法返回true，反之false
    func isMobileNumber() -> Bool {
        
        if self.isEmpty {
            return false
        }
        // 判断是否是手机号
        let patternString = "^1[3-9]\\d{9}$"
        return comparePredicate( patternString: patternString)
    }
    
    /// 判断密码是否合法
    func isValidPasswod() -> Bool {
        if self.isEmpty {
            return false
        }
        
        // 验证密码是 6 - 16 位字母或数字
        let patternString = "^[0-9A-Za-z]{6,16}$"
        return comparePredicate( patternString: patternString)
    }
    ///邮箱验证
    func isValidateEmail() -> Bool {
        if self.isEmpty {
            return false
        }
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        return comparePredicate(patternString: emailRegex)
    }
    
    ///身份证验证
    func IsIdentityCard() -> Bool {
        if self.isEmpty {
            return false
        }
        
        let identityRegex = "^(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)"
        return comparePredicate(patternString: identityRegex)
    }
    
    /// 正则匹配
    ///
    /// - parameter patternString: 正则表达式
    ///
    /// - returns: true or false
    func comparePredicate(patternString : String) -> Bool {
        
        let predicate = NSPredicate(format: "SELF MATCHES %@", patternString)
        return predicate.evaluate(with: self)
    }
    
    /// 将日期字符串按yyyy-MM-dd HH:mm:ss某种格式转换为时间输出
    ///
    /// - parameter format: yyyy-MM-dd HH:mm:ss某种格式
    ///
    /// - returns: 按格式返回时间
    func dateFromStringWithFormat(format : String) -> Date? {
        
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        return formatter.date(from: self)
    }
    
    /// 时间戳对应的Date
    ///
    /// - returns: 时间戳对应的Date
    func dateFromTimeInterval() -> Date? {
        
        return Date.init(timeIntervalSince1970: TimeInterval(self)!)
    }
    
    /// 根据时间戳获取日期
    ///
    /// - Parameter format: yyyy-MM-dd HH:mm:ss某种格式
    /// - Returns: 日期
    func getDateTime(format: String) ->String{
        if self.isEmpty{
            return ""
        }
        
        let date = self.dateFromTimeInterval()
        
        return date!.dateToStringWithFormat(format: format)
    }
    
    
    /// 限制的最大显示长度字符
    ///
    /// - parameter limit: 限制长度
    ///
    /// - returns: 
    func limitMaxTextShow(limit : Int) -> String {
        
        if self.count > limit {
            return self.substring(to: self.index(self.startIndex, offsetBy: limit))
        }
        return self
    }
    
    /**
     1.生成二维码
     
     - returns: 黑白普通二维码(大小为300)
     */
    
    func generateQRCode() -> UIImage
    {
        return generateQRCodeWithSize(size: nil)
    }
    
    /**
     2.生成二维码
     - parameter size: 大小
     - returns: 生成带大小参数的黑白普通二维码
     */
    func generateQRCodeWithSize(size:CGFloat?) -> UIImage
    {
        return generateQRCode(size: size, logo: nil)
    }
    
    /**
     3.生成二维码
     - parameter logo: 图标
     - returns: 生成带Logo二维码(大小:300)
     */
    func generateQRCodeWithLogo(logo:UIImage?) -> UIImage
    {
        return generateQRCode(size: nil, logo: logo)
    }
    
    /**
     4.生成二维码
     - parameter size: 大小
     - parameter logo: 图标
     - returns: 生成大小和Logo的二维码
     */
    func generateQRCode(size:CGFloat?,logo:UIImage?) -> UIImage
    {
        
        let color = UIColor.black//二维码颜色
        let bgColor = UIColor.white//二维码背景颜色
        
        return generateQRCode(size: size, color: color, bgColor: bgColor, logo: logo)
    }
    
    /**
     5.生成二维码
     - parameter size:    大小
     - parameter color:   颜色
     - parameter bgColor: 背景颜色
     - parameter logo:    图标
     
     - returns: 带Logo、颜色二维码
     */
    func generateQRCode(size:CGFloat?,color:UIColor?,bgColor:UIColor?,logo:UIImage?) -> UIImage
    {
        
        let radius : CGFloat = 5//圆角
        let borderLineWidth : CGFloat = 1.5//线宽
        let borderLineColor = UIColor.gray//线颜色
        let boderWidth : CGFloat = 8//白带宽度
        let borderColor = UIColor.white//白带颜色
        
        return generateQRCode(size: size, color: color, bgColor: bgColor, logo: logo,radius:radius,borderLineWidth: borderLineWidth,borderLineColor: borderLineColor,boderWidth: boderWidth,borderColor: borderColor)
        
    }
    
    /**
     6.生成二维码
     
     - parameter size:            大小
     - parameter color:           颜色
     - parameter bgColor:         背景颜色
     - parameter logo:            图标
     - parameter radius:          圆角
     - parameter borderLineWidth: 线宽
     - parameter borderLineColor: 线颜色
     - parameter boderWidth:      带宽
     - parameter borderColor:     带颜色
     
     - returns: 自定义二维码
     */
    func generateQRCode(size:CGFloat?,color:UIColor?,bgColor:UIColor?,logo:UIImage?,radius:CGFloat,borderLineWidth:CGFloat?,borderLineColor:UIColor?,boderWidth:CGFloat?,borderColor:UIColor?) -> UIImage
    {
        let ciImage = generateCIImage(size: size, color: color, bgColor: bgColor)
        let image = UIImage(ciImage: ciImage)
        
        guard let QRCodeLogo = logo else { return image }
        
        let logoWidth = image.size.width/4
        let logoFrame = CGRect(x: (image.size.width - logoWidth) /  2, y: (image.size.width - logoWidth) / 2, width: logoWidth, height: logoWidth)
        
        // 绘制logo
        UIGraphicsBeginImageContextWithOptions(image.size, false, UIScreen.main.scale)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        
        //线框
        let logoBorderLineImagae = QRCodeLogo.getRoundRectImage(size: logoWidth, radius: radius, borderWidth: borderLineWidth, borderColor: borderLineColor)
        //边框
        let logoBorderImagae = logoBorderLineImagae.getRoundRectImage(size: logoWidth, radius: radius, borderWidth: boderWidth, borderColor: borderColor)
        
        logoBorderImagae.draw(in: logoFrame)
        
        let QRCodeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return QRCodeImage!
        
    }
    
    
    /**
     7.生成CIImage
     
     - parameter size:    大小
     - parameter color:   颜色
     - parameter bgColor: 背景颜色
     
     - returns: CIImage
     */
    func generateCIImage(size:CGFloat?,color:UIColor?,bgColor:UIColor?) -> CIImage
    {
        
        //1.缺省值
        var QRCodeSize : CGFloat = 300//默认300
        var QRCodeColor = UIColor.black//默认黑色二维码
        var QRCodeBgColor = UIColor.white//默认白色背景
        
        if let size = size { QRCodeSize = size }
        if let color = color { QRCodeColor = color }
        if let bgColor = bgColor { QRCodeBgColor = bgColor }
        
        
        //2.二维码滤镜
        let contentData = self.data(using: String.Encoding.utf8)
        let fileter = CIFilter(name: "CIQRCodeGenerator")
        
        fileter?.setValue(contentData, forKey: "inputMessage")
        fileter?.setValue("H", forKey: "inputCorrectionLevel")
        
        let ciImage = fileter?.outputImage
        
        //3.颜色滤镜
        let colorFilter = CIFilter(name: "CIFalseColor")
        
        colorFilter?.setValue(ciImage, forKey: "inputImage")
        colorFilter?.setValue(CIColor(cgColor: QRCodeColor.cgColor), forKey: "inputColor0")// 二维码颜色
        colorFilter?.setValue(CIColor(cgColor: QRCodeBgColor.cgColor), forKey: "inputColor1")// 背景色
        
        //4.生成处理
        let outImage = colorFilter!.outputImage
        let scale = QRCodeSize / outImage!.extent.size.width;
        
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        
        let transformImage = colorFilter!.outputImage!.transformed(by: transform)
        
        return transformImage
        
    }
    
    /// Range转NSRange
    ///
    /// - Parameter range: 
    /// - Returns:
    func nsRange(from range: Range<String.Index>) -> NSRange {
        let from = range.lowerBound.samePosition(in: utf16)
        let to = range.upperBound.samePosition(in: utf16)
        return NSRange(location: utf16.distance(from: utf16.startIndex, to: from!),
                       length: utf16.distance(from: from!, to: to!))
    }
    /// NSRange 转Range
    ///
    /// - Parameter nsRange:
    /// - Returns:
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location + nsRange.length, limitedBy: utf16.endIndex),
            let from = from16.samePosition(in: self),
            let to = to16.samePosition(in: self)
            else { return nil }
        return from ..< to
    }
    
    /// json字符串转字典
    ///
    /// - Returns: 字典
    func convertStringToDictionary() -> [String : Any]? {
        
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.init(rawValue: 0)]) as? [String : Any]
                
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    /// 缩略图路径获取原图路径
    ///
    /// - Returns:
    func getOriginImgUrl()-> String{
        if self.isEmpty {
            return "/"
        }
        
        let strArr = self.components(separatedBy: "?")
        if strArr.count > 0 {
            return strArr[0]
        }
        
        return "/"
    }
    
    /// 原图路径获取缩略图路径
    ///
    /// - Parameter size: 缩略图大小  w_300,h_300
    /// - Returns:
    func getThumbImgUrl(size: String)-> String{
        if self.isEmpty {
            return "/"
        }
        
        return self + "?x-oss-process=image/resize,m_lfit," + size + "/quality,q_100"
    }
    
    //返回第一次出现的指定子字符串在此字符串中的索引
    //（如果backwards参数设置为true，则返回最后出现的位置）
    func positionOf(sub:String, backwards:Bool = false)->Int {
        var pos = -1
        if let range = range(of:sub, options: backwards ? .backwards : .literal ) {
            if !range.isEmpty {
                pos = self.distance(from:startIndex, to:range.lowerBound)
            }
        }
        return pos
    }
    //根据开始位置和长度截取字符串
    func subString(start:Int, length:Int = -1) -> String {
        if self.isEmpty {
            return ""
        }
        var len = length
        if len == -1 {
            len = self.count - start
        }
        let st = self.index(startIndex, offsetBy:start)
        let en = self.index(st, offsetBy:len)
        return String(self[st ..< en])
    }
    
    /// 处理富文本图片大小
    func dealFuTextImgSize()->String{
        if self.isEmpty {
            return ""
        }
        let head = "<head>" +
            "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, " +
            "user-scalable=no\"> " +
            "<style>img{max-width: 100%; width:auto; height:auto;}</style>" +
        "</head>"
        
        return "<html>" + head + "<body>" + self + "</body></html>"
    }
}

extension String {
    static func errorAlert(_ error: NSError) -> String {
        var errorAlert: String = ""
        
        if error.code > 860000 {
            let  errorcode = JMSGSDKErrorCode(rawValue: Int(error.code))
            switch errorcode! as JMSGSDKErrorCode{
                
            case .jmsgErrorSDKNetworkDownloadFailed:
                errorAlert = "下载失败"
                break
                
            case .jmsgErrorSDKNetworkUploadFailed:
                errorAlert = "上传资源文件失败"
                break
            case .jmsgErrorSDKNetworkUploadTokenVerifyFailed:
                errorAlert = "上传资源文件Token验证失败"
                break
            case .jmsgErrorSDKNetworkUploadTokenGetFailed:
                errorAlert = "获取服务器Token失败"
                break
            case .jmsgErrorSDKDBDeleteFailed:
                errorAlert = "数据库删除失败"
                break
            case .jmsgErrorSDKDBUpdateFailed:
                errorAlert = "数据库更新失败"
                break
            case .jmsgErrorSDKDBSelectFailed:
                errorAlert = "数据库查询失败"
                break
            case .jmsgErrorSDKDBInsertFailed:
                errorAlert = "数据库插入失败"
                break
            case .jmsgErrorSDKParamAppkeyInvalid:
                errorAlert = "appkey不合法"
                break
            case .jmsgErrorSDKParamUsernameInvalid:
                errorAlert = "用户名不合法"
                break
            case .jmsgErrorSDKParamPasswordInvalid:
                errorAlert = "用户密码不合法"
                break
            case .jmsgErrorSDKUserNotLogin:
                errorAlert = "用户没有登录"
                break
            case .jmsgErrorSDKNotMediaMessage:
                errorAlert = "这不是一条媒体消息"
                break
            case .jmsgErrorSDKMediaResourceMissing:
                errorAlert = "下载媒体资源路径或者数据意外丢失"
                break
            case .jmsgErrorSDKMediaCrcCodeIllegal:
                errorAlert = "媒体CRC码无效"
                break
            case .jmsgErrorSDKMediaCrcVerifyFailed:
                errorAlert = "媒体CRC校验失败"
                break
            case .jmsgErrorSDKMediaUploadEmptyFile:
                errorAlert = "上传媒体文件时, 发现文件不存在"
                break
            case .jmsgErrorSDKParamContentInvalid:
                errorAlert = "无效的消息内容"
                break
            case .jmsgErrorSDKParamMessageNil:
                errorAlert = "空消息"
                break
            case .jmsgErrorSDKMessageNotPrepared:
                errorAlert = "消息不符合发送的基本条件检查"
                break
            case .jmsgErrorSDKParamConversationTypeUnknown:
                errorAlert = "未知的会话类型"
                break
            case .jmsgErrorSDKParamConversationUsernameInvalid:
                errorAlert = "会话 username 无效"
                break
            case .jmsgErrorSDKParamConversationGroupIdInvalid:
                errorAlert = "会话 groupId 无效"
                break
            case .jmsgErrorSDKParamGroupGroupIdInvalid:
                errorAlert = "groupId 无效"
                break
            case .jmsgErrorSDKParamGroupGroupInfoInvalid:
                errorAlert = "group 相关字段无效"
                break
            case .jmsgErrorSDKMessageNotInGroup:
                errorAlert = "你已不在该群，无法发送消息"
                break
                //            case 810009:
                //                errorAlert = "超出群上限"
            //                break
            default:
                break
            }
        }
        
        if error.code > 800000 && error.code < 820000  {
            let errorcode = JMSGTcpErrorCode(rawValue: UInt(error.code))
            switch errorcode! {
            case .errorTcpUserNotRegistered:
                errorAlert = "用户名不存在"
                break
            case .errorTcpUserPasswordError:
                errorAlert = "用户名或密码错误"
                break
            default:
                break
            }
            if error.code == 809002 || error.code == 812002 {
                errorAlert = "你已不在该群"
            }
        }
        
        if error.code < 600 {
            let errorcode = JMSGHttpErrorCode(rawValue: UInt(error.code))
            switch errorcode! {
            case .errorHttpServerInternal:
                errorAlert = "服务器端内部错误"
                break
            case .errorHttpUserExist:
                errorAlert = "用户已经存在"
                break
            case .errorHttpUserNotExist:
                errorAlert = "用户不存在"
                break
            case .errorHttpPrameterInvalid:
                errorAlert = "参数无效"
                break
            case .errorHttpPasswordError:
                errorAlert = "密码错误"
                break
            case .errorHttpUidInvalid:
                errorAlert = "内部UID 无效"
                break
            case .errorHttpMissingAuthenInfo:
                errorAlert = "Http 请求没有验证信息"
                break
            case .errorHttpAuthenticationFailed:
                errorAlert = "Http 请求验证失败"
                break
            case .errorHttpAppkeyNotExist:
                errorAlert = "Appkey 不存在"
                break
            case .errorHttpTokenExpired:
                errorAlert = "Http 请求 token 过期"
                break
            case .errorHttpServerResponseTimeout:
                errorAlert = "服务器端响应超时"
                break
            default:
                break
            }
        }
        if error.code == 869999 {
            errorAlert = "网络连接错误"
        }
        if error.code == 898001 {
            errorAlert = "用户名已存在"
        }
        if error.code == 801006 {
            errorAlert = "账号已被禁用"
        }
        if errorAlert == "" {
            errorAlert = "未知错误"
        }
        return errorAlert
    }
}
