//
//  BPDynamicModel.swift
//  BenefitPet
//  动态model
//  Created by gouyz on 2018/9/29.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

@objcMembers
class BPDynamicModel: LHSBaseModel {
    /// id
    var id : String? = ""
    /// 内容
    var content : String? = ""
    /// 时间
    var add_time : String? = ""
    /// 医生id
    var d_id : String? = ""
    /// 图片url
    var imgUrls: [String]?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "pic"{
            imgUrls = [String]()
            guard let datas = value as? [String] else { return }
            for item in datas {
                imgUrls?.append(item)
            }
        }else {
            super.setValue(value, forKey: key)
        }
    }
}
