//
//  LHSUserInfoModel.swift
//  LazyHuiService
//  用户信息model
//  Created by gouyz on 2017/6/21.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

@objcMembers
class LHSUserInfoModel: LHSBaseModel {
    /// 用户id
    var id : String? = ""
    /// 极光id
    var jg_id : String? = ""
    /// 用户姓名
    var name : String? = ""
    /// 所属医院
    var hospital : String? = ""
    /// 毕业学院
    var school : String? = ""
    /// 星级
    var role : String? = "0"
    /// 头像
    var head : String? = ""
    /// 医生资格证
    var zige : String? = ""
    /// 医生余额
    var balance : String? = "0"
    /// 专业
    var major : String?
    /// 学位
    var degree : String?
    /// 入学时间
    var in_school_time : String?
    /// 毕业时间
    var le_school_time : String?
    ///
    var status : String?
    /// 职位
    var job_title : String? = ""
    ///
    var be_good : String?
    ///
    var tearm : String?
    /// 班级
    var class_id : String?
    /// 电话
    var plone : String?
    /// 医生认证
    var renzheng : String? = ""
    
}
