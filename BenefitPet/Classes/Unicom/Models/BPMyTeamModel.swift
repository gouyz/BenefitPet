//
//  BPMyTeamModel.swift
//  BenefitPet
//  我的团队model
//  Created by gouyz on 2018/10/31.
//  Copyright © 2018 gyz. All rights reserved.
//

import UIKit

@objcMembers
class BPMyTeamModel: LHSBaseModel {

    /// 头衔
    var job_title : String? = ""
    var doctorList: [BPFriendModel] = [BPFriendModel]()
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "doctor_list"{
            guard let datas = value as? [[String : Any]] else { return }
            for dict in datas {
                let model = BPFriendModel(dict: dict)
                doctorList.append(model)
            }
        }else {
            super.setValue(value, forKey: key)
        }
    }
}
