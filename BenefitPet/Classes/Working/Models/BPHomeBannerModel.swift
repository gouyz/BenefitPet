//
//  BPHomeBannerModel.swift
//  BenefitPet
//  首页banner model
//  Created by gouyz on 2018/9/26.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

@objcMembers
class BPHomeBannerModel: LHSBaseModel {
    /// id
    var id : String?
    /// 标题
    var title : String? = ""
    /// 图片
    var img : String? = ""
    /// 是否显示
    var is_show : String? = ""
    ///
    var add_time : String? = ""
}
