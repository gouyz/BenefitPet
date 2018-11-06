//
//  BArticlesModel.swift
//  BenefitPet
//  文章model
//  Created by gouyz on 2018/9/29.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

@objcMembers
class BArticlesModel: LHSBaseModel {
    /// id
    var id : String? = ""
    /// 标题
    var title : String? = ""
    /// 内容
    var content : String? = ""
    /// 时间
    var add_time : String? = ""
    /// 文章所属栏目id
    var c_id : String? = ""
    /// 医生id
    var d_id : String? = ""
    ///
    var url : String? = ""
}
