//
//  BPYuYueListVC.swift
//  BenefitPet
//  预约信息
//  Created by gouyz on 2018/8/1.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

private let yuYueListCell = "yuYueListCell"

class BPYuYueListVC: GYZBaseVC {
    
    /// 是否是完成预约
    var isFinished : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        if isFinished {
            self.navigationItem.title = "已完成预约"
        }else{
            self.navigationItem.title = "未完成预约"
        }
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
        
        table.register(BPOnLineOrderCell.self, forCellReuseIdentifier: yuYueListCell)
        //        weak var weakSelf = self
        //        ///添加下拉刷新
        //        GYZTool.addPullRefresh(scorllView: table, pullRefreshCallBack: {
        //            weakSelf?.refresh()
        //        })
        //        ///添加上拉加载更多
        //        GYZTool.addLoadMore(scorllView: table, loadMoreCallBack: {
        //            weakSelf?.loadMore()
        //        })
        
        return table
    }()
    
    /// 患者聊天、同步诊疗记录
    func goChatVC(){
        let vc = BPChatManagerVC()
        vc.currIndex = 1
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension BPYuYueListVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 16
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: yuYueListCell) as! BPOnLineOrderCell
        
        cell.contentLab.text = "7月3号上午10：00"
        if isFinished {
            cell.rightIconView.isHidden = false
        }else{
            cell.rightIconView.isHidden = true
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
        
        if isFinished {
            goChatVC()
        }
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
