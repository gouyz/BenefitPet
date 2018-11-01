//
//  BPYongYaoGuideModel.swift
//  BenefitPet
//  用药指南model
//  Created by gouyz on 2018/11/1.
//  Copyright © 2018 gyz. All rights reserved.
//

import UIKit

@objcMembers
class BPYongYaoGuideModel: LHSBaseModel {
    /// id
    var id : String? = ""
    /// 图片
    var pic : String? = ""
    /// 文章所属栏目id
    var c_id : String? = ""
    /// 内容
    var content : String? = ""
    /// 标题
    var title : String? = ""
}
