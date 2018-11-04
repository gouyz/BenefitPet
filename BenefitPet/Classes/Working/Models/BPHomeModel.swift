//
//  BPHomeModel.swift
//  BenefitPet
//  首页工作站model
//  Created by gouyz on 2018/9/27.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

@objcMembers
class BPHomeModel: LHSBaseModel {

    /// banner
    var bannerModels: [BPHomeBannerModel]?
    var userInfo: LHSUserInfoModel?
    var newModels: [BPHomeNewModel]?
    /// 今日回答数量
    var num : String? = "0"
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "banner"{
            bannerModels = [BPHomeBannerModel]()
            guard let datas = value as? [[String : Any]] else { return }
            for dict in datas {
                let model = BPHomeBannerModel(dict: dict)
                bannerModels?.append(model)
            }
        }else if key == "doctor"{
            guard let datas = value as? [String : Any] else { return }
            userInfo = LHSUserInfoModel(dict: datas)
        }else if key == "new"{
            newModels = [BPHomeNewModel]()
            guard let datas = value as? [[String : Any]] else { return }
            for dict in datas {
                let model = BPHomeNewModel(dict: dict)
                newModels?.append(model)
            }
        }
        else {
            super.setValue(value, forKey: key)
        }
    }
}

/// 首页新闻model
@objcMembers
class BPHomeNewModel: LHSBaseModel {
    /// id
    var id : String?
    /// 标题
    var title : String? = ""
    /// 摘要
    var abstract : String? = ""
    /// 图片
    var img : String? = ""
    ///
    var url : String? = ""
    ///
    var add_time : String? = ""
}
