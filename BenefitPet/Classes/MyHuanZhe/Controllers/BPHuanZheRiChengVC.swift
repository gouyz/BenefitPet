//
//  BPHuanZheRiChengVC.swift
//  BenefitPet
//  日程
//  Created by gouyz on 2018/8/17.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let huanZheRiChengCell = "huanZheRiChengCell"
private let huanZheRiChengHeader = "huanZheRiChengHeader"

class BPHuanZheRiChengVC: GYZBaseVC {
    
    var huanZheId: String = ""
    var dataList: [[BPRiChengModel]] = [[BPRiChengModel]]()
    var titleList: [String] = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        requestRiChengDatas()
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
        
        table.register(BPRiChengCell.self, forCellReuseIdentifier: huanZheRiChengCell)
        table.register(BPRiChengHeaderView.self, forHeaderFooterViewReuseIdentifier: huanZheRiChengHeader)
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
    
    ///获取日程数据
    func requestRiChengDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("patient/richeng",parameters: ["u_id": huanZheId],  success: { (response) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(response)
            
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["data"].array else { return }
                weakSelf?.titleList.removeAll()
                weakSelf?.dataList.removeAll()
                
                var date: String = ""
                var dataArr: [BPRiChengModel] = [BPRiChengModel]()
                for (index,item) in data.enumerated(){
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = BPRiChengModel.init(dict: itemInfo)
                    if model.date?.count != 10{//日期格式不正确，跳过
                        continue
                    }
                    let time: String = (model.date?.subString(start: 0, length: 7))!
                    if index == 0{
                        date = time
                    }
                    if date != time{
                        
                        if dataArr.count > 0{
                            weakSelf?.titleList.append(date)
                            weakSelf?.dataList.append(dataArr)
                        }
                        date = time
                        dataArr.removeAll()
                    }
                    dataArr.append(model)
                    ///最后一项时
                    if index == data.count - 1{
                        if dataArr.count > 0{
                            weakSelf?.titleList.append(date)
                            weakSelf?.dataList.append(dataArr)
                        }
                        dataArr.removeAll()
                    }
                }
                if weakSelf?.dataList.count > 0{
                    weakSelf?.hiddenEmptyView()
                    weakSelf?.tableView.reloadData()
                }else{
                    ///显示空页面
                    weakSelf?.showEmptyView(content: "暂无日程信息")
                }
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(error)
            
            weakSelf?.showEmptyView(content: "加载失败，请点击重新加载", reload: {
                weakSelf?.requestRiChengDatas()
                weakSelf?.hiddenEmptyView()
            })
        })
    }
    
}
extension BPHuanZheRiChengVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataList.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: huanZheRiChengCell) as! BPRiChengCell
        cell.dataModel = dataList[indexPath.section][indexPath.row]
        
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: huanZheRiChengHeader) as! BPRiChengHeaderView
        headerView.nameLab.text = titleList[section]
        
        return headerView
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView()
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 34
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
