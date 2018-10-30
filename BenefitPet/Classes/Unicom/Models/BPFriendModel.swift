//
//  BPFriendModel.swift
//  BenefitPet
//  好友model
//  Created by gouyz on 2018/10/30.
//  Copyright © 2018 gyz. All rights reserved.
//

import UIKit

@objcMembers
class BPFriendModel: LHSBaseModel {
    /// 患者id
    var id : String? = ""
    /// 姓名（用于黑名单显示）
    var nickname : String? = ""
    /// 头像
    var head : String? = ""
    /// 备注
    var remark : String? = ""
    /// 姓名
    var name : String? = ""
    /// 学校
    var school : String? = ""
    /// 好友添加状态：0未添加 1待通过 2通过
    var ishad : String? = ""
}
