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
    var id : String?
    /// 用户姓名
    var name : String? = ""
    /// 医院名称
    var hospital : String? = ""
    /// 学校名称
    var school : String? = ""
    ///
    var role : String? = ""
    /// 头像
    var head : String? = ""
    ///
    var zige : String? = ""
    ///
    var balance : String? = "0"
    ///
    var major : String?
    ///
    var degree : String?
    ///
    var in_school_time : String?
    ///
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
    ///
    var renzheng : String?
    
}
