//
//  BPMayKnowPersonVC.swift
//  BenefitPet
//  可能认识的人
//  Created by gouyz on 2018/8/27.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

private let mayKnowPersonCell = "mayKnowPersonCell"

class BPMayKnowPersonVC: GYZBaseVC {

    var titles: [String] = ["同届校友","同事","通讯录"]
    var tagImgs: [String] = ["icon_friend_school","icon_friend_tongshi","icon_friend_txl"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "可能认识的人"
        
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
        table.separatorStyle = .none
        table.backgroundColor = kWhiteColor
        
        
        table.register(GYZCommonIconArrowCell.self, forCellReuseIdentifier: mayKnowPersonCell)
        
        return table
    }()
    
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
}

extension BPMayKnowPersonVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: mayKnowPersonCell) as! GYZCommonIconArrowCell
        
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
        case 0:// 同届校友
            goSchoolFriends()
        case 1:// 同事
            goMyTongShi()
        case 2:// 通讯录
            goTongXunLu()
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
