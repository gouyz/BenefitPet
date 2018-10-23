//
//  BPPastWenZhenModel.swift
//  BenefitPet
//  既往问诊 model
//  Created by gouyz on 2018/10/23.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

@objcMembers
class BPPastWenZhenModel: LHSBaseModel {
    /// 医生id
    var d_id : String? = ""
    /// 医生极光id
    var d_jg_id : String? = ""
    /// 头像
    var head : String? = ""
    /// 患者id
    var u_id : String? = ""
    /// 患者极光id
    var u_jg_id : String? = ""
    /// 患者昵称
    var nickname : String? = ""
}
