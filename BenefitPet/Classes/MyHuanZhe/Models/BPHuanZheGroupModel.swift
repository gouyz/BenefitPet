//
//  BPHuanZheGroupModel.swift
//  BenefitPet
//  患者分组 model
//  Created by gouyz on 2018/10/17.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit


@objcMembers
class BPHuanZheGroupModel: LHSBaseModel {
    /// id
    var id : String? = ""
    /// 分组名称
    var name : String? = ""
    /// 医生id
    var d_id : String? = ""
    /// 人数
    var num : String? = ""
    /// 分组患者list
    var patientList: [BPHuanZheModel] = [BPHuanZheModel]()
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "patient_list"{
            guard let datas = value as? [[String : Any]] else { return }
            for dict in datas {
                let model = BPHuanZheModel(dict: dict)
                patientList.append(model)
            }
        }else {
            super.setValue(value, forKey: key)
        }
    }
}

@objcMembers
class BPHuanZheModel: LHSBaseModel {
    /// id
    var id : String? = ""
    /// 分组名称
    var nickname : String? = ""
    /// 头像
    var head : String? = ""
    /// 极光id
    var jg_id : String? = ""
}
