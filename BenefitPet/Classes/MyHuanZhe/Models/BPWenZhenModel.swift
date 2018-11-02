//
//  BPWenZhenModel.swift
//  BenefitPet
//  问诊表 model
//  Created by gouyz on 2018/9/29.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

@objcMembers
class BPWenZhenModel: LHSBaseModel {
    /// id
    var id : String?
    /// 问题
    var question : String? = ""
    /// 问诊表模板id
    var title_id : String? = ""
    /// 问诊表答案
    var answer : String? = ""
}
