//
//  BPWangKeDetailModel.swift
//  BenefitPet
//  网课详情 model
//  Created by gouyz on 2018/11/2.
//  Copyright © 2018 gyz. All rights reserved.
//

import UIKit

@objcMembers
class BPWangKeDetailModel: LHSBaseModel {

    /// 专家网课详情
    var detailModel: BPWangKeModel?
    /// 专家网课相关
    var wangkeList: [BPWangKeModel] = [BPWangKeModel]()
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "xiangguan"{
            guard let datas = value as? [[String : Any]] else { return }
            for dict in datas {
                let model = BPWangKeModel(dict: dict)
                wangkeList.append(model)
            }
        }else if key == "content"{
            guard let datas = value as? [String : Any] else { return }
            detailModel = BPWangKeModel(dict: datas)
            
        }else {
            super.setValue(value, forKey: key)
        }
    }
}
