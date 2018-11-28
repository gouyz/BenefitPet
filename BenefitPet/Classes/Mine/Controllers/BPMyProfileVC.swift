//
//  BPMyProfileVC.swift
//  BenefitPet
//  个人信息
//  Created by gouyz on 2018/8/9.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let profileCell = "profileCell"

class BPMyProfileVC: GYZBaseVC {
    
    /// 选择用户头像
    var selectUserImg: UIImage?
    var userInfoModel: LHSUserInfoModel?
    var areaList: [BPAreaModel] = [BPAreaModel]()
    var jobList: [BPJobModel] = [BPJobModel]()
    var areaNameList: [String] = [String]()
    var jobNameList: [String] = [String]()
    var jobIndex: Int = 0
    var areaIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "个人信息"
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        requestMineData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorColor = kGrayLineColor
        
        table.register(BPProfileInfoCell.self, forCellReuseIdentifier: profileCell)
        
        return table
    }()
    
    /// 获取我的 数据
    func requestMineData(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("doctor/doctor", parameters: ["id": userDefaults.string(forKey: "userId") ?? ""],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                guard let data = response["data"].dictionaryObject else { return }
                weakSelf?.userInfoModel = LHSUserInfoModel.init(dict: data)
                weakSelf?.tableView.reloadData()
                
                if weakSelf?.areaList.count == 0{
                    weakSelf?.requestJobDatas()
                    weakSelf?.requestAreaDatas()
                }
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    ///获取地区数据
    func requestAreaDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        
        GYZNetWork.requestNetwork("doctor/area_list",parameters: nil,  success: { (response) in
            
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["data"].array else { return }
                
                for (index,item) in data.enumerated(){
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = BPAreaModel.init(dict: itemInfo)
                    if model.area_name == weakSelf?.userInfoModel?.area_name{
                        weakSelf?.areaIndex = index
                    }
                    weakSelf?.areaNameList.append(model.area_name!)
                    weakSelf?.areaList.append(model)
                }
                
            }
            
        }, failture: { (error) in
            
            GYZLog(error)
        })
    }
    
    ///获取职位数据
    func requestJobDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        
        GYZNetWork.requestNetwork("doctor/job_list",parameters: nil,  success: { (response) in
            
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["data"].array else { return }
                
                for (index,item) in data.enumerated(){
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = BPJobModel.init(dict: itemInfo)
                    
                    if model.job_name == weakSelf?.userInfoModel?.job_title{
                        weakSelf?.jobIndex = index
                    }
                    
                    weakSelf?.jobNameList.append(model.job_name!)
                    weakSelf?.jobList.append(model)
                }
                
            }
            
        }, failture: { (error) in
            
            GYZLog(error)
        })
    }
    /// 职业兽医资格认证
    func goShouYiCertificate(){
        let vc = BPShouYiCertificateVC()
        if userInfoModel != nil {
            vc.imgUrl = (userInfoModel?.zige)!
        }
        vc.resultBlock = {[weak self] in
            self?.requestMineData()
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 益宠认证
    func goBenefitPetCertificate(){
        let vc = BPBenefitPetCertificateVC()
        if userInfoModel != nil {
            vc.imgUrl = (userInfoModel?.renzheng)!
        }
        vc.resultBlock = {[weak self] in
            self?.requestMineData()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 毕业院校
    func goUniversity(){
        let vc = BPUniversityVC()
        vc.userInfoModel = userInfoModel
        vc.resultBlock = {[weak self] in
            self?.requestMineData()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 修改姓名
    func goModifyName(){
        let vc = BPModifyNameVC()
        vc.name = (userInfoModel?.name)!
        vc.resultBlock = {[weak self] (name) in
            self?.userInfoModel?.name = name
            self?.tableView.reloadData()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 修改医院
    func goModifyHospital(){
        let vc = BPModifyHospitalVC()
        vc.name = (userInfoModel?.hospital)!
        vc.resultBlock = {[weak self] (name) in
            self?.userInfoModel?.hospital = name
            self?.tableView.reloadData()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 选择头像
    func selectHeaderImg(){
        
        GYZOpenCameraPhotosTool.shareTool.choosePicture(self, editor: true, finished: { [weak self] (image) in
            
            self?.selectUserImg = image
            self?.requestUpdateHeaderImg()
        })
    }
    
    /// 上传头像
    func requestUpdateHeaderImg(){
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        let imgParam: ImageFileUploadParam = ImageFileUploadParam()
        imgParam.name = "head"
        imgParam.fileName = "header.jpg"
        imgParam.mimeType = "image/jpg"
        imgParam.data = UIImageJPEGRepresentation(selectUserImg!, 0.5)
        
        GYZNetWork.uploadImageRequest("doctor/file_head", parameters: ["id":userDefaults.string(forKey: "userId") ?? ""], uploadParam: [imgParam], success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                weakSelf?.uploadImage()
                weakSelf?.tableView.reloadData()
                
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    /// 极光IM 修改头像
    private func uploadImage() {
        if let image = selectUserImg {
            let imageData = UIImageJPEGRepresentation(image, 0.5)
            JMSGUser.updateMyInfo(withParameter: imageData!, userFieldType: .fieldsAvatar, completionHandler: { (result, error) in
                if error == nil {
                    let avatorData = NSKeyedArchiver.archivedData(withRootObject: imageData!)
                    userDefaults.set(avatorData, forKey: kLastUserAvator)
                }
            })
        } else {
            userDefaults.removeObject(forKey: kLastUserAvator)
        }
    }
    /// 选择职位
    func selectJob(){
        if jobList.count > 0 {
            UsefulPickerView.showSingleColPicker("请选择职位", data: jobNameList, defaultSelectedIndex: jobIndex) {[weak self] (index, value) in
                self?.jobIndex = index
                self?.userInfoModel?.job_title = value
                self?.tableView.reloadData()
                
                self?.requestModifyUserInfo(key: "job_id", value: (self?.jobList[index].id)!)
            }
        }
        
    }
    /// 选择区域
    func selectArea(){
        if areaList.count > 0 {
            UsefulPickerView.showSingleColPicker("请选择地区", data: areaNameList, defaultSelectedIndex: areaIndex) { [weak self] (index, value) in
                
                self?.areaIndex = index
                self?.userInfoModel?.area_name = value
                self?.tableView.reloadData()
                
                self?.requestModifyUserInfo(key: "area_id", value: (self?.areaList[index].id)!)
            }
        }
        
    }
    
    /// 修改个人资料
    func requestModifyUserInfo(key: String, value: String){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("doctor/doctor_edit", parameters: ["id": userDefaults.string(forKey: "userId") ?? "",key:value],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
}

extension BPMyProfileVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: profileCell) as! BPProfileInfoCell
        
        cell.desLab.textColor = kGaryFontColor
        cell.userImgView.isHidden = true
        cell.desLab.isHidden = true
        cell.rightIconView.isHidden = false
        
        if indexPath.section == 0 && indexPath.row == 0 {
            cell.nameLab.text = "头像"
            cell.userImgView.isHidden = false
            if selectUserImg != nil{
                cell.userImgView.image = selectUserImg
            }else{
                cell.userImgView.kf.setImage(with: URL.init(string: (userInfoModel?.head)!), placeholder: UIImage.init(named: "icon_header_default"), options: nil, progressBlock: nil, completionHandler: nil)
            }
            
        } else if indexPath.section == 1{
            if indexPath.row == 0{
                cell.nameLab.text = "姓名"
                cell.desLab.isHidden = false
                cell.desLab.text = userInfoModel?.name
            }else if indexPath.row == 1{
                cell.nameLab.text = "医院"
                cell.desLab.isHidden = false
                cell.desLab.text = userInfoModel?.hospital
            }else if indexPath.row == 2{
                cell.nameLab.text = "职业兽医资格证"
                cell.desLab.isHidden = false
                
                cell.desLab.text = (userInfoModel?.zige?.isEmpty)! ? "未认证":"已认证"
                cell.rightIconView.isHidden = false
            }else if indexPath.row == 3{
                cell.nameLab.text = "益宠认证"
                cell.desLab.isHidden = false
                cell.desLab.text = (userInfoModel?.renzheng?.isEmpty)! ? "未认证":"已认证"
                cell.rightIconView.isHidden = false
            }else if indexPath.row == 4{
                cell.nameLab.text = "毕业院校"
                cell.desLab.isHidden = false
                cell.desLab.text = (userInfoModel?.school?.isEmpty)! ? "未填写": userInfoModel?.school
                cell.rightIconView.isHidden = false
            }else if indexPath.row == 5{
                cell.nameLab.text = "职位"
                cell.desLab.isHidden = false
                cell.desLab.text = userInfoModel?.job_title
                cell.rightIconView.isHidden = false
            }else if indexPath.row == 6{
                cell.nameLab.text = "地区"
                cell.desLab.isHidden = false
                cell.desLab.text = userInfoModel?.area_name
                cell.rightIconView.isHidden = false
            }else if indexPath.row == 7{
                cell.nameLab.text = "星级评定"
                cell.desLab.isHidden = false
                cell.desLab.text = "LV" + (userInfoModel?.role)!
                cell.desLab.textColor = kRedFontColor
                cell.rightIconView.isHidden = true
            }
        }
        
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 && indexPath.row == 0 {//选择头像
            selectHeaderImg()
        }else if indexPath.section == 1 {
            if indexPath.row == 2{//职业兽医资格认证
                goShouYiCertificate()
            }else if indexPath.row == 3{//益宠认证
                goBenefitPetCertificate()
            }else if indexPath.row == 4{/// 毕业院校
                goUniversity()
            }else if indexPath.row == 0{/// 修改姓名
                goModifyName()
            }else if indexPath.row == 1{/// 修改医院
                goModifyHospital()
            }else if indexPath.row == 5{/// 修改职位
                selectJob()
            }else if indexPath.row == 6{/// 修改地区
                selectArea()
            }
        }
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 && indexPath.row == 0 {
            return 64
        }
        return kTitleHeight
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kMargin
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
