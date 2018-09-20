//
//  BPZhenLiaoRecordVC.swift
//  BenefitPet
//  同步诊疗记录
//  Created by gouyz on 2018/8/16.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

private let zhenLiaoRecordInfoCell = "zhenLiaoRecordInfoCell"
private let zhenLiaoRecordCell = "zhenLiaoRecordCell"
private let zhenLiaoRecordHeader = "zhenLiaoRecordHeader"
private let zhenLiaoRecordFooter = "zhenLiaoRecordFooter"

class BPZhenLiaoRecordVC: GYZBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = kWhiteColor

        view.addSubview(addRecordBtn)
        view.addSubview(tableView)
        addRecordBtn.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(kBottomTabbarHeight)
        }
        tableView.snp.makeConstraints { (make) in
            
            make.left.top.right.equalTo(view)
            make.bottom.equalTo(addRecordBtn.snp.top)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /// 懒加载UITableView
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.backgroundColor = kWhiteColor
        
        table.register(GYZCommonArrowCell.self, forCellReuseIdentifier: zhenLiaoRecordCell)
        table.register(BPZhenLiaoRecordInfoCell.self, forCellReuseIdentifier: zhenLiaoRecordInfoCell)
        table.register(BPWenZhenTableHeaderView.self, forHeaderFooterViewReuseIdentifier: zhenLiaoRecordHeader)
        
        table.register(BPZhenLiaoRecordEmptyFooterView.self, forHeaderFooterViewReuseIdentifier: zhenLiaoRecordFooter)
        
        return table
    }()
    /// 添加诊疗记录
    lazy var addRecordBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBtnClickBGColor
        btn.titleLabel?.font = k15Font
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.setTitle("添加诊疗记录", for: .normal)
        btn.addTarget(self, action: #selector(clickedAddRecordBtn), for: .touchUpInside)
        
        return btn
    }()
    /// 添加诊疗记录
    @objc func clickedAddRecordBtn(){
        let vc = BPAddZhenLiaoRecordVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 问诊表
    func goWenZhenList(){
        let vc = BPWenZhenListVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 日程和随访计划
    func goWenRiCheng(){
        let vc = BPRiChengPlanManagerVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 编辑患者信息
    func goEditInfo(){
        let vc = BPEditHuanZheInfoVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 编辑分组
    func goEditGroup(){
        let vc = BPGroupManagerVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension BPZhenLiaoRecordVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        }
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 && indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: zhenLiaoRecordInfoCell) as! BPZhenLiaoRecordInfoCell
            
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: zhenLiaoRecordCell) as! GYZCommonArrowCell
            if indexPath.section == 0 {
                if indexPath.row == 1{
                    cell.nameLab.text = "分组"
                    cell.contentLab.text = "门诊"
                }else if indexPath.row == 2{
                    cell.nameLab.text = "日程和随访计划"
                    cell.contentLab.text = ""
                }else if indexPath.row == 3{
                    cell.nameLab.text = "问诊表"
                    cell.contentLab.text = ""
                }
            }else{
                cell.nameLab.text = "2018-08-16"
                cell.contentLab.text = "患者伤口感染发炎"
            }
            
            cell.selectionStyle = .none
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 1 {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: zhenLiaoRecordHeader) as! BPWenZhenTableHeaderView
            
            headerView.nameLab.text = "诊疗记录"
            headerView.nameLab.textColor = kBlueFontColor
            
            return headerView
        }
        return UIView()
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if section == 1 {
            let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: zhenLiaoRecordFooter) as! BPZhenLiaoRecordEmptyFooterView
            
            return footerView
        }
        
        
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0://患者信息
                goEditInfo()
            case 1://分组
                goEditGroup()
            case 2://日程和随访计划
                goWenRiCheng()
            case 3://问诊表
                goWenZhenList()
            default:
                break
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
        
        if section == 1 {
            return 34
        }
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            return 200
        }
        return 0.00001
    }
}
