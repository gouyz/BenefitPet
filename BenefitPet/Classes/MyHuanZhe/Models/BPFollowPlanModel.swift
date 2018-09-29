//
//  BPFollowPlanModel.swift
//  BenefitPet
//  随访计划 model
//  Created by gouyz on 2018/9/29.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

@objcMembers
class BPFollowPlanModel: LHSBaseModel {
    /// id
    var id : String? = ""
    /// 标题
    var title : String? = ""
    /// 内容
    var content : String? = ""
    /// 时间
    var add_time : String? = ""
    /// 随访计划内容一级id
    var c_id : String? = ""
}
