//
//  BPMyHuanZheVC.swift
//  BenefitPet
//  我的患者
//  Created by gouyz on 2018/7/27.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import JMessage

private let huanZheMenuCell = "huanZheMenuCell"
private let huanZheCell = "huanZheCell"
private let huanZheHeader = "huanZheHeader"

class BPMyHuanZheVC: GYZBaseVC {
    
    /// 功能menu
    var mFuncModels: [BPHuanZheMenuModel] = [BPHuanZheMenuModel]()
    var datasList: [JMSGConversation] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "我的患者"
        
        let plistPath : String = Bundle.main.path(forResource: "menuData", ofType: "plist")!
        let menuArr : [[String:String]] = NSArray(contentsOfFile: plistPath) as! [[String : String]]
        
        for item in menuArr{
            
            let model = BPHuanZheMenuModel.init(dict: item)
            mFuncModels.append(model)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        tableView.tableHeaderView = searchView
        
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
        
        
        table.register(BPHuanZheMenuCell.self, forCellReuseIdentifier: huanZheMenuCell)
        table.register(BPHuanZheCell.self, forCellReuseIdentifier: huanZheCell)
        table.register(BPRiChengHeaderView.self, forHeaderFooterViewReuseIdentifier: huanZheHeader)
        
        return table
    }()
    /// 搜索
    lazy var searchView: BPSearchHeaderView = BPSearchHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 50))
    
    /// 功能模块
    func dealOperator(index: Int){
        
        goController(menu: mFuncModels[index - 100])
    }
    
    ///控制跳转
    func goController(menu: BPHuanZheMenuModel){
        //1:动态获取命名空间
        guard let name = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
            GYZLog("获取命名空间失败")
            return
        }
        
        let cls: AnyClass? = NSClassFromString(name + "." + menu.controller!) //VCName:表示试图控制器的类名
        
        // Swift中如果想通过一个Class来创建一个对象, 必须告诉系统这个Class的确切类型
        guard let typeClass = cls as? GYZBaseVC.Type else {
            GYZLog("cls不能当做UIViewController")
            return
        }
        
        let controller = typeClass.init()
        
        navigationController?.pushViewController(controller, animated: true)
    }
    /// 患者聊天、同步诊疗记录
    func goChatVC(){
        let vc = BPChatManagerVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func getConversations() {
        JMSGConversation.allConversations {[weak self] (result, error) in
            guard let conversatios = result else {
                return
            }
            self?.datasList = conversatios as! [JMSGConversation]
            self?.datasList = (self?.sortConverstaions((self?.datasList)!))!
            self?.tableView.reloadData()
            
            self?.updateBadge()
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
    
    func updateBadge() {
        let count = datasList.unreadCount
        if count > 99 {
            navigationController?.tabBarItem.badgeValue = "99+"
        } else {
            navigationController?.tabBarItem.badgeValue = count == 0 ? nil : "\(count)"
        }
    }
}

extension BPMyHuanZheVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return datasList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: huanZheMenuCell) as! BPHuanZheMenuCell
            
            cell.menuDataArr = mFuncModels
            cell.didSelectIndex = { [weak self](index) in
                self?.dealOperator(index: index)
            }
            
            cell.selectionStyle = .none
            return cell
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: huanZheCell) as! BPHuanZheCell
            
            cell.dataModel = datasList[indexPath.row]
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 1 {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: huanZheHeader) as! BPRiChengHeaderView
            
            headerView.nameLab.textAlignment = .left
            headerView.nameLab.text = "最新消息"
            
            return headerView
        }
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {// 患者消息
            let conversation = datasList[indexPath.row]
            conversation.clearUnreadCount()
            guard let cell = tableView.cellForRow(at: indexPath) as? BPHuanZheCell else {
                return
            }
            cell.dataModel = conversation
            updateBadge()
            goChatVC()
        }
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 180
        }
        return 60
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 34
        }
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
