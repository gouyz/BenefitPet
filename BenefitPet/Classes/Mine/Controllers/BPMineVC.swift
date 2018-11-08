//
//  BPMineVC.swift
//  BenefitPet
//  个人中心
//  Created by gouyz on 2018/7/27.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let mineCell = "mineCell"

class BPMineVC: GYZBaseVC {
    
    var titles: [String] = ["个人主页",/*"我的提现",*/"我的设置"]
    var tagImgs: [String] = ["icon_mine_home",/*"icon_mine_cash",*/"icon_mine_setting"]
    
    var userInfoModel: LHSUserInfoModel?

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
            make.left.right.equalTo(view)
            make.bottom.equalTo(-kBottomTabbarHeight)
        }
        
        tableView.tableHeaderView = userHeaderView
        
        userHeaderView.bgView.addOnClickListener(target: self, action: #selector(onClickedLogin))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if userDefaults.bool(forKey: kIsLoginTagKey) {
            requestMineData()
        }else{
            setEmptyHeaderData()
        }
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
                weakSelf?.setHeaderData()
                
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    /// 设置header
    func setHeaderData(){
        userHeaderView.desLab.text = userInfoModel?.name
        userHeaderView.userHeaderView.kf.setImage(with: URL.init(string: (userInfoModel?.head)!), placeholder: UIImage.init(named: "icon_header_default"), options: nil, progressBlock: nil, completionHandler: nil)
        userHeaderView.moneyLab.text = String.init(format: "我的余额：￥%.2f", Double((userInfoModel?.balance)!)!)
        
    }
    
    ///
    func setEmptyHeaderData(){
        userHeaderView.desLab.text = "登录/注册"
        userHeaderView.userHeaderView.image = UIImage.init(named: "icon_header_default")
        userHeaderView.moneyLab.text = "我的余额：￥0"
        
    }
    
    /// 个人信息
    @objc func onClickedMsg(){
        
        if userDefaults.bool(forKey: kIsLoginTagKey) {
            let vc = BPMyProfileVC()
            vc.userInfoModel = userInfoModel
            navigationController?.pushViewController(vc, animated: true)
        }else{
            goLogin()
        }
    }
    /// 未登录时，点击登录
    @objc func onClickedLogin(){
        
        if userDefaults.bool(forKey: kIsLoginTagKey) {
            return
        }
        goLogin()
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
        if userDefaults.bool(forKey: kIsLoginTagKey) {
            let vc = BPMyHomeVC()
            vc.userInfoModel = userInfoModel
            navigationController?.pushViewController(vc, animated: true)
        }else{
            goLogin()
        }
        
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
//        case 1:// 我的提现
//            goMyCash()
        case 1:// 我的设置
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
