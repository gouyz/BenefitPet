//
//  BPAllFriendsVC.swift
//  BenefitPet
//  所有好友
//  Created by gouyz on 2018/8/23.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

private let allFriendsCell = "allFriendsCell"
private let allFriendsFooter = "allFriendsFooter"

class BPAllFriendsVC: GYZBaseVC {

    var titles: [String] = ["同届校友","同事","通讯录","好友请求"]
    var tagImgs: [String] = ["icon_friend_school","icon_friend_tongshi","icon_friend_txl","icon_friend_apply"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "我的所有好友"
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        tableView.tableHeaderView = searchView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.backgroundColor = kWhiteColor
        
        
        table.register(GYZCommonIconArrowCell.self, forCellReuseIdentifier: allFriendsCell)
        table.register(BPBtnFooterView.self, forHeaderFooterViewReuseIdentifier: allFriendsFooter)
        
        return table
    }()
    /// 搜索
    lazy var searchView: BPSearchHeaderView = BPSearchHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 50))
    
    /// 同届校友
    func goSchoolFriends(){
        let vc = BPSchoolFriendsVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 同事
    func goMyTongShi(){
        let vc = BPTongShiVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 通讯录
    func goTongXunLu(){
        let vc = BPTongXunluVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 好友请求
    func goApplyFriend(){
        let vc = BPApplyFriendsVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 添加好友
    @objc func onClickedOperatorBtn(){
        let vc = BPAddFriendsVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension BPAllFriendsVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: allFriendsCell) as! GYZCommonIconArrowCell
        
        cell.iconView.image = UIImage.init(named: tagImgs[indexPath.row])
        cell.nameLab.text = titles[indexPath.row]
        
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: allFriendsFooter) as! BPBtnFooterView
        
        footerView.onOperatorBtn.addTarget(self, action: #selector(onClickedOperatorBtn), for: .touchUpInside)
        
        return footerView
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:// 同届校友
            goSchoolFriends()
        case 1:// 同事
            goMyTongShi()
        case 2:// 通讯录
            goTongXunLu()
        case 3:// 好友请求
            goApplyFriend()
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
        return 110
    }
}
