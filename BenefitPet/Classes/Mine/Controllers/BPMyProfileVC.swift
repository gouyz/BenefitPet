//
//  BPMyProfileVC.swift
//  BenefitPet
//  个人信息
//  Created by gouyz on 2018/8/9.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

private let profileCell = "profileCell"

class BPMyProfileVC: GYZBaseVC {
    
    /// 选择用户头像
    var selectUserImg: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "个人信息"
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
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
        
        table.register(BPProfileInfoCell.self, forCellReuseIdentifier: profileCell)
        
        return table
    }()
    /// 职业兽医资格认证
    func goShouYiCertificate(){
        let vc = BPShouYiCertificateVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 益宠认证
    func goBenefitPetCertificate(){
        let vc = BPBenefitPetCertificateVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 毕业院校
    func goUniversity(){
        let vc = BPUniversityVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 选择头像
    func selectHeaderImg(){
        
        GYZOpenCameraPhotosTool.shareTool.choosePicture(self, editor: true, finished: { [weak self] (image) in
            
            self?.selectUserImg = image
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
        return 6
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
            cell.userImgView.kf.setImage(with: userDefaults.url(forKey: "headImg"), placeholder: UIImage.init(named: "icon_header_default"), options: nil, progressBlock: nil, completionHandler: nil)
        } else if indexPath.section == 1{
            if indexPath.row == 0{
                cell.nameLab.text = "姓名"
                cell.desLab.isHidden = false
                cell.desLab.text = "玛丽"
                cell.rightIconView.isHidden = true
            }else if indexPath.row == 1{
                cell.nameLab.text = "医院"
                cell.desLab.isHidden = false
                cell.desLab.text = "益宠宠物医院"
                cell.rightIconView.isHidden = true
            }else if indexPath.row == 2{
                cell.nameLab.text = "职业兽医资格证"
                cell.desLab.isHidden = false
                cell.desLab.text = "已认证"
                cell.rightIconView.isHidden = false
            }else if indexPath.row == 3{
                cell.nameLab.text = "益宠认证"
                cell.desLab.isHidden = false
                cell.desLab.text = "已认证"
                cell.rightIconView.isHidden = false
            }else if indexPath.row == 4{
                cell.nameLab.text = "毕业院校"
                cell.desLab.isHidden = false
                cell.desLab.text = "未填写"
                cell.rightIconView.isHidden = false
            }else if indexPath.row == 5{
                cell.nameLab.text = "星级评定"
                cell.desLab.isHidden = false
                cell.desLab.text = "LV8"
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
