//
//  BPSettingVC.swift
//  BenefitPet
//  我的设置
//  Created by gouyz on 2018/8/10.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

private let settingCell = "settingCell"

class BPSettingVC: GYZBaseVC {
    
    var titles: [String] = ["服务条款","隐私政策","修改密码","退出登录"]
    var tagImgs: [String] = ["icon_setting_service","icon_setting_about","icon_setting_pwd","icon_setting_loginout"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "我的设置"

        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            
            make.edges.equalTo(0)
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
        
        table.register(GYZCommonIconArrowCell.self, forCellReuseIdentifier: settingCell)
        
        return table
    }()
    
    /// 修改密码
    func goModifyPwd() {
        let forgetPwdVC = BPRegisterVC()
        forgetPwdVC.registerType = .modifypwd
        navigationController?.pushViewController(forgetPwdVC, animated: true)
    }
    
    ///退出当前账号
    func loginOut(){
        weak var weakSelf = self
        GYZAlertViewTools.alertViewTools.showAlert(title: "提示", message: "确定要退出登录？", cancleTitle: "取消", viewController: self, buttonTitles: "退出") { (index) in
            
            if index != cancelIndex{
                weakSelf?.dealLoginOut()
            }
        }
    }
    
    func dealLoginOut(){
        GYZTool.removeUserInfo()
        
        KeyWindow.rootViewController = GYZBaseNavigationVC(rootViewController: BPLoginVC())
    }
    
    /// 服务条款/隐私政策
    func goArticleDetail(title: String,url: String){
        let vc = BPArticleDetailVC()
        vc.url = url
        vc.articleTitle = title
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension BPSettingVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: settingCell) as! GYZCommonIconArrowCell
        cell.iconView.image = UIImage.init(named: tagImgs[indexPath.row])
        cell.nameLab.text = titles[indexPath.row]
        
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
        
        switch indexPath.row {
        case 0:// 服务条款
            goArticleDetail(title: "服务条款", url: "http://yichong.0519app.com/page/agreement.html")
        case 1:// 隐私政策
            goArticleDetail(title: "隐私政策", url: "http://yichong.0519app.com/page/privacy.html")
        case 2:// 修改密码
            goModifyPwd()
        case 3:// 退出登录
            loginOut()
        default:
            break
        }
        
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kMargin
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
