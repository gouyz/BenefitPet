//
//  BPYuYueModel.swift
//  BenefitPet
//  预约信息model
//  Created by gouyz on 2018/9/28.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

@objcMembers
class BPYuYueModel: LHSBaseModel {
    /// id
    var id : String?
    /// 未完成患者姓名
    var user_name : String? = ""
    /// 预约标题
    var xinxi : String? = ""
    /// 医生id
    var d_id : String? = ""
    /// 预约时间
    var time : String? = "0"
    /// 预约状态 0未完成1已完成
    var status : String? = ""
    /// 未完成患者头像
    var head : String? = ""
    /// 患者id
    var u_id : String? = ""
    /// 极光id
    var jg_id : String? = ""
}
