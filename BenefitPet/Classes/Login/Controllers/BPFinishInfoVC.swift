//
//  BPFinishInfoVC.swift
//  BenefitPet
//  完善信息
//  Created by gouyz on 2018/11/8.
//  Copyright © 2018 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let finishInfoCell = "finishInfoCell"
private let finishInfoFooter = "finishInfoFooter"

class BPFinishInfoVC: GYZBaseVC {

    /// 选择用户头像
    var selectUserImg: UIImage?
    var userInfoModel: LHSUserInfoModel?
    var isRegister: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "完善信息"
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        if userInfoModel == nil {
            requestMineData()
        }
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
        
        table.register(BPProfileInfoCell.self, forCellReuseIdentifier: finishInfoCell)
        table.register(BPFinishInfoFooterView.self, forHeaderFooterViewReuseIdentifier: finishInfoFooter)
        
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
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
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
    
    func goHome(index: Int){
        if index == 102 {
            if (userInfoModel?.head?.isEmpty)!{
                MBProgressHUD.showAutoDismissHUD(message: "请完善头像")
                return
            }
            if (userInfoModel?.name?.isEmpty)!{
                MBProgressHUD.showAutoDismissHUD(message: "请完善姓名")
                return
            }
            if (userInfoModel?.hospital?.isEmpty)!{
                MBProgressHUD.showAutoDismissHUD(message: "请完善医院信息")
                return
            }
            if (userInfoModel?.zige?.isEmpty)!{
                MBProgressHUD.showAutoDismissHUD(message: "请完善职业兽医资格证")
                return
            }
            if (userInfoModel?.renzheng?.isEmpty)!{
                MBProgressHUD.showAutoDismissHUD(message: "请完善益宠认证")
                return
            }
            if (userInfoModel?.school?.isEmpty)!{
                MBProgressHUD.showAutoDismissHUD(message: "请完善毕业院校信息")
                return
            }
        
        }
        if isRegister{
            KeyWindow.rootViewController = GYZMainTabBarVC()
        }else{
            clickedBackBtn()
        }
    }
}

extension BPFinishInfoVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: finishInfoCell) as! BPProfileInfoCell
        
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
                cell.desLab.text = (userInfoModel?.school?.isEmpty)! ? "未填写":"已填写"
                cell.rightIconView.isHidden = false
            }
        }
        
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 {
            let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: finishInfoFooter) as! BPFinishInfoFooterView
            
            if !isRegister{
                footerView.tipsBtn.isHidden = true
                footerView.tipsBtn.snp.updateConstraints { (make) in
                    make.width.equalTo(0)
                }
                footerView.finishBtn.snp.updateConstraints { (make) in
                    make.width.equalTo((kScreenWidth - 120) * 0.5)
                }
                footerView.finishBtn.setTitle("确 定", for: .normal)
            }
            
            footerView.operatorBlock = {[weak self] (index) in
                
                self?.goHome(index: index)
            }
            
            return footerView
        }
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
        if section == 1 {
            return 64
        }
        return 0.00001
    }
}
