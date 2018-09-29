//
//  BPRiChengModel.swift
//  BenefitPet
//  日程model
//  Created by gouyz on 2018/9/29.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

@objcMembers
class BPRiChengModel: LHSBaseModel {
    /// id
    var id : String?
    /// 医生日程信息
    var richeng : String? = ""
    /// 患者姓名
    var user : String? = ""
    /// 医生id
    var d_id : String? = ""
    /// 日程日期 2018-11-11
    var date : String? = "0"
    /// 日程时间 17:00
    var time : String? = ""
}
