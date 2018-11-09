//
//  BPSearchBlackListVC.swift
//  BenefitPet
//  搜索黑名单
//  Created by gouyz on 2018/11/5.
//  Copyright © 2018 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let searchBlackListCell = "searchBlackListCell"

class BPSearchBlackListVC: GYZBaseVC {
    
    var searchContent: String = ""
    var dataList: [BPFriendModel] = [BPFriendModel]()
    var searchType: String = "0"

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "患者搜索"
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        requestBackListDatas()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorColor = kGrayLineColor
        
        table.register(BPOnLineOrderCell.self, forCellReuseIdentifier: searchBlackListCell)
        
        return table
    }()
    
    /// 患者聊天、同步诊疗记录
    func goChatVC(jgId: String){
        
        let conversation = JMSGConversation.singleConversation(withUsername: jgId)
        if conversation == nil {
            
            JMSGConversation.createSingleConversation(withUsername: jgId) {[weak self] (resultObject, error) in
                
                if error == nil{
                    self?.goChatManagerVC(conversation: resultObject as! JMSGConversation)
                }
            }
        }else{
            goChatManagerVC(conversation: conversation!)
        }
        
    }
    
    func goChatManagerVC(conversation: JMSGConversation){
        let vc = BPChatManagerVC()
        
        vc.conversation = conversation
        vc.currIndex = 1
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    ///获取黑名单数据
    func requestBackListDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("contact/search",parameters: ["input": searchContent,"type": searchType],  success: { (response) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(response)
            
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["data"].array else { return }
                weakSelf?.dataList.removeAll()
                
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = BPFriendModel.init(dict: itemInfo)
                    
                    weakSelf?.dataList.append(model)
                }
                if weakSelf?.dataList.count > 0{
                    weakSelf?.hiddenEmptyView()
                    weakSelf?.tableView.reloadData()
                }else{
                    ///显示空页面
                    weakSelf?.showEmptyView(content: "暂无患者黑名单信息")
                }
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(error)
            
            weakSelf?.showEmptyView(content: "加载失败，请点击重新加载", reload: {
                weakSelf?.requestBackListDatas()
                weakSelf?.hiddenEmptyView()
            })
        })
    }
}

extension BPSearchBlackListVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: searchBlackListCell) as! BPOnLineOrderCell
        let model = dataList[indexPath.row]
        cell.contentLab.text = model.remark
        cell.nameLab.text = model.nickname
        cell.iconView.kf.setImage(with: URL.init(string: model.head!), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
        
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
        
        goChatVC(jgId: dataList[indexPath.row].jg_id!)
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
