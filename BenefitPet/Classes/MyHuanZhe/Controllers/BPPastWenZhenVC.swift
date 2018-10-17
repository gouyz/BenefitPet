//
//  BPPastWenZhenVC.swift
//  BenefitPet
//  既往问诊
//  Created by gouyz on 2018/8/8.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import JMessage

private let pastWenZhenCell = "pastWenZhenCell"

class BPPastWenZhenVC: GYZBaseVC {
    
    var datasList: [JMSGConversation] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "既往问诊"
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        getConversations()
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
        
        table.register(BPHuanZheCell.self, forCellReuseIdentifier: pastWenZhenCell)
        
        return table
    }()
    
    func getConversations() {
        if !GYZTool.checkNetWork() {
            return
        }
        
        showLoadingView()
        
        JMSGConversation.allConversations {[weak self] (result, error) in
            
            self?.hiddenLoadingView()
            guard let conversatios = result else {
                ///显示空页面
                self?.showEmptyView(content: "暂无问诊信息")
                return
            }
            self?.datasList = conversatios as! [JMSGConversation]
            self?.datasList = (self?.sortConverstaions((self?.datasList)!))!
            self?.tableView.reloadData()
            self?.hiddenEmptyView()
            
        }
    }
    fileprivate func sortConverstaions(_ convs: [JMSGConversation]) -> [JMSGConversation] {
        var stickyConvs: [JMSGConversation] = []
        var allConvs: [JMSGConversation] = []
        for index in 0..<convs.count {
            let conv = convs[index]
            if conv.ex.isSticky {
                stickyConvs.append(conv)
            } else {
                allConvs.append(conv)
            }
        }
        
        stickyConvs = stickyConvs.sorted(by: { (c1, c2) -> Bool in
            c1.ex.stickyTime > c2.ex.stickyTime
        })
        
        allConvs.insert(contentsOf: stickyConvs, at: 0)
        return allConvs
    }
}

extension BPPastWenZhenVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return datasList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: pastWenZhenCell) as! BPHuanZheCell
        
        cell.dataModel = datasList[indexPath.row]
        
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
        
        //        if indexPath.row == 0 {// 患者黑名单
        //            goBlackList()
        //        }
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
