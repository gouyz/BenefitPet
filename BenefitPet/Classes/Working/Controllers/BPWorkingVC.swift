//
//  BPWorkingVC.swift
//  BenefitPet
//  工作站
//  Created by gouyz on 2018/7/27.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let workingCell = "workingCell"
private let workingHeader = "workingHeader"

class BPWorkingVC: GYZBaseVC {
    
    var dataModel: BPHomeModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "工作站"
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        tableView.tableHeaderView = headerView
        
        headerView.callBack = {[weak self] (tag) in
            self?.dealOperator(index: tag)
        }
        
        requestHomeDatas()
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
        
        // 设置大概高度
        table.estimatedRowHeight = 180
        // 设置行高为自动适配
        table.rowHeight = UITableViewAutomaticDimension
        
        table.register(BPWorkingCell.self, forCellReuseIdentifier: workingCell)
        table.register(BPWorkingHeaderView.self, forHeaderFooterViewReuseIdentifier: workingHeader)
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
    
    lazy var headerView: BPWorkingAdsHeaderView = BPWorkingAdsHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: (kScreenWidth - kMargin * 2) * 0.4 + 160))
    
    ///获取首页数据
    func requestHomeDatas(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("doctorindex/index",parameters: ["id": userDefaults.string(forKey: "userId") ?? ""],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["data"].dictionaryObject else { return }
                weakSelf?.dataModel = BPHomeModel.init(dict: data)
                weakSelf?.setData()
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    func setData(){
        
        if dataModel != nil {
            
            if dataModel?.bannerModels != nil{
                var imgUrlArr: [String] = [String]()
                for imgUrl in (dataModel?.bannerModels)! {
                    imgUrlArr.append(imgUrl.img!)
                }
                headerView.adsImgView.setUrlsGroup(imgUrlArr)
            }
            
            headerView.nameLab.text = dataModel?.userInfo?.hospital
            headerView.headerImgView.kf.setImage(with: URL.init(string: (dataModel?.userInfo?.head)!), placeholder: UIImage.init(named: "icon_header_default"), options: nil, progressBlock: nil, completionHandler: nil)
            headerView.userNameLab.text = dataModel?.userInfo?.name
            
            var rating: Double = 0.0
            if !(dataModel?.userInfo?.role?.isEmpty)!{
                rating = Double.init((dataModel?.userInfo?.role)!)!
            }
            headerView.ratingView.rating = rating
            headerView.numberLab.text = "今日回答：\((dataModel?.num)!)人"
            
            tableView.reloadData()
        }
    }
    
    /// 在线接单、预约信息、小护士
    func dealOperator(index : Int){
        switch index {
        case 1://在线接单
            goOnLineOrder()
        case 2://预约信息
            showYuyueView()
        case 3://小护士
            showHuShiView()
        default:
            break
        }
    }
    
    //在线接单
    func goOnLineOrder(){
        let vc = BPOnLineOrderVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 显示预约信息
    func showYuyueView(){
        
        let actionSheet = GYZActionSheet.init(title: "", style: .Default, itemTitles: ["已完成预约","未完成预约"])
        actionSheet.cancleTextColor = kBlackFontColor
        actionSheet.itemTextFont = k15Font
        actionSheet.itemTextColor = kBlackFontColor
        actionSheet.didSelectIndex = { [weak self](index: Int,title: String) in
            
            if index == 0{//已完成预约
                self?.goYuyueVC(isFinished: true)
            }else if index == 1 {//未完成预约
                self?.goYuyueVC(isFinished: false)
            }
        }
    }
    
    func goYuyueVC(isFinished: Bool){
        let vc = BPYuYueListVC()
        vc.isFinished = isFinished
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 显示智能小护士
    func showHuShiView(){
        let actionSheet = GYZActionSheet.init(title: "", style: .Default, itemTitles: ["问诊表","日程","随访计划"])
        actionSheet.cancleTextColor = kBlackFontColor
        actionSheet.itemTextFont = k15Font
        actionSheet.itemTextColor = kBlackFontColor
        actionSheet.didSelectIndex = { [weak self](index: Int,title: String) in
            
            if index == 0{//问诊表
                self?.goWenZhenTable()
            }else if index == 1 {//日程
                self?.goRiCheng()
            }else if index == 2 {//随访计划
                self?.goFollowPlan()
            }
        }
    }
    /// 日程
    func goRiCheng(){
        let vc = BPRiChengVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    //问诊表
    func goWenZhenTable(){
        let vc = BPWenZhenTableView()
        navigationController?.pushViewController(vc, animated: true)
    }
    //随访计划
    func goFollowPlan(){
        let vc = BPFollowPlanVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension BPWorkingVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataModel != nil && dataModel?.newModels != nil {
            return (dataModel?.newModels?.count)!
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: workingCell) as! BPWorkingCell
        
        cell.dataModel = dataModel?.newModels![indexPath.row]
        
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: workingHeader) as! BPWorkingHeaderView
        
        
        return headerView
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView()
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 34
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}

