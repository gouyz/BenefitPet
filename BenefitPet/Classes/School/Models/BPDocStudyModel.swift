//
//  BPDocStudyModel.swift
//  BenefitPet
//  学习园地 model
//  Created by gouyz on 2018/11/1.
//  Copyright © 2018 gyz. All rights reserved.
//

import UIKit

@objcMembers
class BPDocStudyModel: LHSBaseModel {
    /// 专家网课
    var wangkeList: [BPWangKeModel] = [BPWangKeModel]()
    /// 专业文章
    var articleList: [BPYongYaoGuideModel] = [BPYongYaoGuideModel]()
    /// 医生快课
    var kuaikeList: [BPYongYaoGuideModel] = [BPYongYaoGuideModel]()

    override func setValue(_ value: Any?, forKey key: String) {
        if key == "wangke"{
            guard let datas = value as? [[String : Any]] else { return }
            for dict in datas {
                let model = BPWangKeModel(dict: dict)
                wangkeList.append(model)
            }
        }else if key == "wenzhang"{
            guard let datas = value as? [[String : Any]] else { return }
            for dict in datas {
                let model = BPYongYaoGuideModel(dict: dict)
                articleList.append(model)
            }
        }else if key == "kuaike"{
            guard let datas = value as? [[String : Any]] else { return }
            for dict in datas {
                let model = BPYongYaoGuideModel(dict: dict)
                kuaikeList.append(model)
            }
        }else {
            super.setValue(value, forKey: key)
        }
    }
}

/// 专家网课model
@objcMembers
class BPWangKeModel: LHSBaseModel {
    
    /// id
    var id : String? = ""
    /// 图片
    var pic : String? = ""
    /// 视频路径
    var video : String? = ""
    /// 标题
    var title : String? = ""
}
