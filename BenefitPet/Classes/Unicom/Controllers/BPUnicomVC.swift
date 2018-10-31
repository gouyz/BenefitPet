//
//  BPUnicomVC.swift
//  BenefitPet
//  益联通
//  Created by gouyz on 2018/7/27.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

private let unicomCell = "unicomCell"
private let unicomFooter = "unicomFooter"

class BPUnicomVC: GYZBaseVC {
    
    var titles: [String] = ["患者黑名单","所有好友","我的团队"]
    var tagImgs: [String] = ["icon_blacklist","icon_all_friends","icon_team"]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "益联通"
        
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
        
        
        table.register(GYZCommonIconArrowCell.self, forCellReuseIdentifier: unicomCell)
        table.register(BPBtnFooterView.self, forHeaderFooterViewReuseIdentifier: unicomFooter)
        
        return table
    }()
    /// 搜索
    lazy var searchView: BPSearchHeaderView = BPSearchHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 50))
    
    /// 患者黑名单
    func goBlackList(){
        let vc = BPBlackListVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 我的所有好友
    func goAllFriends(){
        let vc = BPAllFriendsVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 我的团队
    func goMyTeam(){
        let vc = BPMyTeamVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 可能认识的人
    func goMayKnowPerson(){
        let vc = BPMayKnowPersonVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 添加好友
    @objc func onClickedOperatorBtn(){
        let vc = BPAddFriendsVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension BPUnicomVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: unicomCell) as! GYZCommonIconArrowCell
        
        cell.iconView.image = UIImage.init(named: tagImgs[indexPath.row])
        cell.nameLab.text = titles[indexPath.row]
        
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: unicomFooter) as! BPBtnFooterView
        
        footerView.onOperatorBtn.addTarget(self, action: #selector(onClickedOperatorBtn), for: .touchUpInside)
        
        return footerView
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:// 患者黑名单
            goBlackList()
        case 1:// 所有好友
            goAllFriends()
        case 2:// 我的团队
            goMyTeam()
        case 3:// 可能认识的人
            goMayKnowPerson()
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
