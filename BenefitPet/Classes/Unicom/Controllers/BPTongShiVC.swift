//
//  BPTongShiVC.swift
//  BenefitPet
//  同事
//  Created by gouyz on 2018/8/23.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

private let tongShiCell = "tongShiCell"

class BPTongShiVC: GYZBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "同事"
        
        view.addSubview(friendEmptyView)
        view.addSubview(applyBtn)
        view.addSubview(tableView)
        
        friendEmptyView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        applyBtn.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(view)
            make.height.equalTo(kBottomTabbarHeight)
        }
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.bottom.equalTo(applyBtn.snp.top)
            if #available(iOS 11.0, *) {
                make.top.equalTo(view)
            }else{
                make.top.equalTo(kTitleAndStateHeight)
            }
        }
//        tableView.isHidden = true
//        applyBtn.isHidden = true
          friendEmptyView.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /// 空页面
    lazy var friendEmptyView: BPFriendsEmptyView = {
        let emptyView = BPFriendsEmptyView()
        emptyView.desLab.text = "您还没有同院同科室的医生"
        emptyView.operatorBtn.setTitle("邀请同事", for: .normal)
        emptyView.operatorBtn.addTarget(self, action: #selector(onClickedOperatorBtn), for: .touchUpInside)
        
        return emptyView
    }()
    
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorColor = kGrayLineColor
        
        
        table.register(BPSchoolFriendsCell.self, forCellReuseIdentifier: tongShiCell)
        
        return table
    }()
    
    /// 邀请同事
    lazy var applyBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBtnClickBGColor
        btn.setTitle("邀请同事", for: .normal)
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.titleLabel?.font = k15Font
        btn.cornerRadius = kCornerRadius
        btn.addTarget(self, action: #selector(onClickedOperatorBtn), for: .touchUpInside)
        
        return btn
    }()
    /// 立即完善
    @objc func onClickedOperatorBtn(){
        showShareView()
    }
    
    /// 分享界面
    func showShareView(){
        
        let cancelBtn = [
            "title": "取消",
            "type": "danger"
        ]
        let mmShareSheet = MMShareSheet.init(title: "分享至", cards: kSharedCards, duration: nil, cancelBtn: cancelBtn)
        mmShareSheet.callBack = { [weak self](handler) ->() in
            
            if handler != "cancel" {// 取消
                
            }
        }
        mmShareSheet.present()
    }
}

extension BPTongShiVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 16
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: tongShiCell) as! BPSchoolFriendsCell
        
        cell.addBtn.isEnabled = false
        cell.addBtn.backgroundColor = kWhiteColor
        cell.addBtn.setTitle("已邀请", for: .normal)
        cell.addBtn.setTitleColor(kBlackFontColor, for: .normal)
        
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
