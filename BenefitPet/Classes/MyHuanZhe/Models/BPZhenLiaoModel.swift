//
//  BPZhenLiaoModel.swift
//  BenefitPet
//  同步诊疗界面 model
//  Created by gouyz on 2018/11/2.
//  Copyright © 2018 gyz. All rights reserved.
//

import UIKit

@objcMembers
class BPZhenLiaoModel: LHSBaseModel {

    /// 患者信息
    var userModel: BPZhenLiaoUserModel?
    /// 患者群组
    var groupModel: BPHuanZheGroupModel?
    /// 同步诊疗记录
    var recordList: [BPZhenLiaoRecordModel] = [BPZhenLiaoRecordModel]()
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "record"{
            guard let datas = value as? [[String : Any]] else { return }
            for dict in datas {
                let model = BPZhenLiaoRecordModel(dict: dict)
                recordList.append(model)
            }
        }else if key == "user"{
            guard let datas = value as? [String : Any] else { return }
            userModel = BPZhenLiaoUserModel(dict: datas)
            
        }else if key == "group"{
            guard let datas = value as? [String : Any] else { return }
            groupModel = BPHuanZheGroupModel(dict: datas)
            
        }else {
            super.setValue(value, forKey: key)
        }
    }
}

/// 同步诊疗患者信息 model
@objcMembers
class BPZhenLiaoUserModel: LHSBaseModel {
    
    /// id
    var id : String? = ""
    ///
    var date : String? = ""
    /// 头像
    var head : String? = ""
    /// 患者性别
    var sex : String? = ""
    /// 患者手机
    var mobile : String? = ""
    /// 患者昵称
    var nickname : String? = ""
}
/// 同步诊疗记录 model
@objcMembers
class BPZhenLiaoRecordModel: LHSBaseModel {
    
    /// id
    var id : String? = ""
    ///
    var see_time : String? = ""
    /// 备注
    var remark : String? = ""
    /// 医生id
    var d_id : String? = ""
    /// 患者id
    var u_id : String? = ""
}
