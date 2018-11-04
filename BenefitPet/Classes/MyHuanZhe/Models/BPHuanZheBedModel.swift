//
//  BPHuanZheBedModel.swift
//  BenefitPet
//  患者住院信息model
//  Created by gouyz on 2018/11/4.
//  Copyright © 2018 gyz. All rights reserved.
//

import UIKit

@objcMembers
class BPHuanZheBedModel: LHSBaseModel {

    /// id
    var id : String? = ""
    /// 住院号
    var hospitalization : String? = ""
    /// 床位号
    var bed : String? = ""
    /// 性别
    var sex : String? = ""
    /// 出生日期 2018-10-10
    var date : String? = ""
    /// 患者昵称
    var nickname : String? = ""
    /// 联系方式
    var mobile : String? = ""
}
