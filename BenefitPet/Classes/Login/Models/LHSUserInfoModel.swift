//
//  LHSUserInfoModel.swift
//  LazyHuiService
//  用户信息model
//  Created by gouyz on 2017/6/21.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

@objcMembers
class LHSUserInfoModel: LHSBaseModel {
    /// 用户id
    var id : String?
    /// 用户姓名
    var name : String? = ""
    ///
    var hospital : String?
    /// 姓名
    var dealerName : String? = ""
    /// 是否服务中心0否1是（审核通过时修改该字段）
    var isServerCenter : String?
    /// 电话
    var dealerMobile : String?
    /// 状态 1正常0注销
    var dealerStatus : String?
    /// 推荐码 生成规则：6位16进制数，
    var dealerPromoCode : String?
    /// 身份证
    var dealerIdcards : String?
    /// 省
    var dealerProvince : String?
    /// 市
    var dealerCity : String?
    /// 区
    var dealerArea : String?
    /// 邮政编码
    var dealerPostcode : String?
    /// 地址
    var dealerAddress : String?
    /// 级别 0游客1小纯纯2纯纯3纯大大
    var dealerLevel : String?
    /// 销售额
    var dealerSaleTotals : String?
    /// 充值总额
    var dealerRechargeTotals : String?
    /// 盈利
    var dealerProfitTotals : String?
    /// 积分余额
    var dealerCoinBalance : String?
    /// 开户行
    var dealerBank: String?
    /// 银行卡号
    var dealerBankaccount : String?
    /// 所属服务中心
    var dealerScid : String?
    /// 推荐经销商
    var dealerPromoDealer : String?
    /// 佣金总额
    var dealerCommissionTotals : String? = "0"
    /// 佣金余额
    var dealerCommissionBalance : String? = "0"
    /// 加入时间 2018-06-12 17:24:57
    var dealerJoinTime : String?
    /// 充值次数
    var dealerRechargeTimes : String?
    
}
