//
//  BPWenZhenTableDetailVC.swift
//  BenefitPet
//  问诊表详情
//  Created by gouyz on 2018/8/9.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let wenZhenTableDetailCell = "wenZhenTableDetailCell"

class BPWenZhenTableDetailVC: GYZBaseVC {
    
    var wenZhenModel: BPWenZhenModel?
    var dataList: [BPWenZhenModel] = [BPWenZhenModel]()
    var huanZheId: String = ""
    /// 是否有答案
    var isAnswer: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = wenZhenModel?.question
        if huanZheId != "" {
            let rightBtn = UIButton(frame: CGRect.init(x: 0, y: 0, width: 60, height: kTitleHeight))
            rightBtn.setTitle("发送", for: .normal)
            rightBtn.setTitleColor(kBlackFontColor, for: .normal)
            rightBtn.titleLabel?.font = k14Font
            rightBtn.addTarget(self, action: #selector(onClickedSendBtn), for: .touchUpInside)
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        requestWenZhenDetailDatas()
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
        
        table.register(BPWenZhenTableDetailCell.self, forCellReuseIdentifier: wenZhenTableDetailCell)
        
        return table
    }()
    
    ///获取问诊详情数据
    func requestWenZhenDetailDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        var params: [String: String] = ["id": (wenZhenModel?.id)!]
        
        var method: String = "doctorindex/question"
        if isAnswer {
            method = "patient/inq_content"
            params["title_id"] = (wenZhenModel?.title_id)!
        }
        
        GYZNetWork.requestNetwork(method,parameters: params,  success: { (response) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(response)
            
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["data"].array else { return }
                
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = BPWenZhenModel.init(dict: itemInfo)
                    
                    weakSelf?.dataList.append(model)
                }
                if weakSelf?.dataList.count > 0{
                    weakSelf?.hiddenEmptyView()
                    weakSelf?.tableView.reloadData()
                }else{
                    ///显示空页面
                    weakSelf?.showEmptyView(content: "暂无问诊信息")
                }
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(error)
            
            weakSelf?.showEmptyView(content: "加载失败，请点击重新加载", reload: {
                weakSelf?.requestWenZhenDetailDatas()
                weakSelf?.hiddenEmptyView()
            })
        })
    }
    
    /// 发送
    @objc func onClickedSendBtn(){
        weak var weakSelf = self
        GYZAlertViewTools.alertViewTools.showAlert(title: "提示", message: "确定要发送给患者吗？", cancleTitle: "取消", viewController: self, buttonTitles: "发送") { (index) in
            
            if index != cancelIndex{
                weakSelf?.requestSendData()
            }
        }
    }
    
    /// 发送
    func requestSendData(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("patient/send_user_inq", parameters: ["u_id": huanZheId,"inq_id": (wenZhenModel?.id)!,"d_id": userDefaults.string(forKey: "userId") ?? ""],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
}

extension BPWenZhenTableDetailVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: wenZhenTableDetailCell) as! BPWenZhenTableDetailCell
        
        let model = dataList[indexPath.row]
        cell.sortLab.text = "\(indexPath.row + 1)"
        cell.nameLab.text = model.question
        cell.contentLab.text = model.answer
        
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
        
        return 80
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
