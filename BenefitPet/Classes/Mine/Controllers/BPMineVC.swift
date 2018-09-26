//
//  BPMineVC.swift
//  BenefitPet
//  个人中心
//  Created by gouyz on 2018/7/27.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

private let mineCell = "mineCell"

class BPMineVC: GYZBaseVC {
    
    var titles: [String] = ["个人主页","我的提现","我的设置"]
    var tagImgs: [String] = ["icon_mine_home","icon_mine_cash","icon_mine_setting"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBarBgAlpha = 0
        automaticallyAdjustsScrollViewInsets = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named:"icon_mine_msg"), style: .done, target: self, action: #selector(onClickedMsg))
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            
            if #available(iOS 11.0, *) {
                make.top.equalTo(-kTitleAndStateHeight)
            }else{
                make.top.equalTo(0)
            }
            make.left.bottom.right.equalTo(view)
        }
        
        tableView.tableHeaderView = userHeaderView
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
        
        table.register(GYZCommonIconArrowCell.self, forCellReuseIdentifier: mineCell)
        
        return table
    }()
    
    lazy var userHeaderView: BPMineHeaderView = BPMineHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 130 + kTitleAndStateHeight))
    
    /// 个人信息
    @objc func onClickedMsg(){
        
        if userDefaults.bool(forKey: kIsLoginTagKey) {
            let vc = BPMyProfileVC()
            navigationController?.pushViewController(vc, animated: true)
        }else{
            goLogin()
        }
    }
    ///我的设置
    func goSetting(){
        
        let vc = BPSettingVC()
        navigationController?.pushViewController(vc, animated: true)
        
    }
    /// 登录
    func goLogin(){
        let vc = BPLoginVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    ///个人主页
    func goMyHome(){
        let vc = BPMyHomeVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    ///提现
    func goMyCash(){
        let vc = BPCashVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension BPMineVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: mineCell) as! GYZCommonIconArrowCell
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
        case 0:// 个人主页
            goMyHome()
        case 1:// 我的提现
            goMyCash()
        case 2:// 我的设置
            goSetting()
        default:
            break
        }
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
