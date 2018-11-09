//
//  BPBlackListVC.swift
//  BenefitPet
//  患者黑名单
//  Created by gouyz on 2018/8/1.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD
import PYSearch

private let blackListCell = "blackListCell"

class BPBlackListVC: GYZBaseVC {
    
    var dataList: [BPFriendModel] = [BPFriendModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "患者黑名单"
        
        view.addSubview(bottomView)
        bottomView.addSubview(noteLab)
        bottomView.addSubview(lineView)
        bottomView.addSubview(addImgView)
        view.addSubview(tableView)
        
        bottomView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(kBottomTabbarHeight)
        }
        noteLab.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(bottomView)
            make.right.equalTo(lineView.snp.left)
        }
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.bottom.equalTo(-5)
            make.right.equalTo(addImgView.snp.left).offset(-20)
            make.width.equalTo(klineDoubleWidth)
        }
        addImgView.snp.makeConstraints { (make) in
            make.right.equalTo(-20)
            make.centerY.equalTo(bottomView)
            make.size.equalTo(CGSize.init(width: 34, height: 35))
        }
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.bottom.equalTo(bottomView.snp.top)
            if #available(iOS 11.0, *) {
                make.top.equalTo(view)
            }else{
                make.top.equalTo(kTitleAndStateHeight)
            }
        }
        
        tableView.tableHeaderView = searchView
        searchView.searchBtn.set(image: UIImage.init(named: "icon_search"), title: "请输入患者姓名", titlePosition: .right, additionalSpacing: 5, state: .normal)
        
        searchView.searchBtn.addTarget(self, action: #selector(onClickSearch), for: .touchUpInside)
        
        addImgView.addOnClickListener(target: self, action: #selector(onClickedAdd))
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
        table.separatorStyle = .none
        
        
        table.register(BPOnLineOrderCell.self, forCellReuseIdentifier: blackListCell)
        
        return table
    }()
    /// 搜索
    lazy var searchView: BPSearchHeaderView = BPSearchHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 50))
    
    lazy var bottomView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = kBlueFontColor
        
        return bgView
    }()
    /// 内容
    var noteLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kWhiteColor
        lab.textAlignment = .center
        lab.numberOfLines = 2
        lab.text = "记录这些不良患者，\n帮助我的同仁多加留心这些患者"
        
        return lab
    }()
    lazy var lineView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = kWhiteColor
        
        return bgView
    }()
    lazy var addImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_edit_pen"))
    /// add
    @objc func onClickedAdd(){
        let vc = BPAddBlackListVC()
        vc.resultBlock = {[weak self] () in
            
            self?.requestBackListDatas()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 搜索
    @objc func onClickSearch(){
        let searchVC: PYSearchViewController = PYSearchViewController.init(hotSearches: [], searchBarPlaceholder: "请输入患者姓名") { (searchViewController, searchBar, searchText) in
            
            let searchVC = BPSearchBlackListVC()
            searchVC.searchContent = searchText!
            searchVC.searchType = "0"
            searchViewController?.navigationController?.pushViewController(searchVC, animated: true)
        }
        searchVC.hotSearchStyle = .borderTag
        searchVC.searchHistoryStyle = .borderTag
        
        let searchNav = GYZBaseNavigationVC(rootViewController:searchVC)
        
        searchVC.cancelButton.setTitleColor(kBlackFontColor, for: .normal)
        self.present(searchNav, animated: true, completion: nil)
    }
    
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
        
        GYZNetWork.requestNetwork("contact/black_patient",  success: { (response) in
            
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
                    weakSelf?.view.bringSubview(toFront: (weakSelf?.bottomView)!)
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
            weakSelf?.view.bringSubview(toFront: (weakSelf?.bottomView)!)
        })
    }
}

extension BPBlackListVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: blackListCell) as! BPOnLineOrderCell
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
