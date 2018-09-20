//
//  BPApplyFriendsVC.swift
//  BenefitPet
//  好友请求
//  Created by gouyz on 2018/8/24.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

private let applyFriendsCell = "applyFriendsCell"

class BPApplyFriendsVC: GYZBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "好友请求"
        view.addSubview(friendEmptyView)
        view.addSubview(tableView)
        
        friendEmptyView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        tableView.isHidden = true
        //        friendEmptyView.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /// 空页面
    lazy var friendEmptyView: BPFriendsEmptyView = {
        let emptyView = BPFriendsEmptyView()
        emptyView.desLab.text = "您还没有好友请求"
        emptyView.operatorBtn.setTitle("添加好友", for: .normal)
        emptyView.operatorBtn.addTarget(self, action: #selector(onClickedOperatorBtn), for: .touchUpInside)
        
        return emptyView
    }()
    
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorColor = kGrayLineColor
        
        
        table.register(BPSchoolFriendsCell.self, forCellReuseIdentifier: applyFriendsCell)
        
        return table
    }()
    /// 添加好友
    @objc func onClickedOperatorBtn(){
        let vc = BPAddFriendsVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension BPApplyFriendsVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 16
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: applyFriendsCell) as! BPSchoolFriendsCell
        
        if indexPath.row % 2 == 0 {
            cell.addBtn.isEnabled = false
            cell.addBtn.backgroundColor = kWhiteColor
            cell.addBtn.setTitle("已添加", for: .normal)
            cell.addBtn.setTitleColor(kBlackFontColor, for: .normal)
        }else{
            cell.addBtn.isEnabled = true
            cell.addBtn.backgroundColor = kBtnClickBGColor
            cell.addBtn.setTitle("接受", for: .normal)
            cell.addBtn.setTitleColor(kWhiteColor, for: .normal)
        }
        
        cell.addBtn.tag = indexPath.row
        cell.addBlock = { (index) in
            
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
        
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kTitleHeight
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}

