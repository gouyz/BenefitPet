//
//  BPFollowPlanChildVC.swift
//  BenefitPet
//  子随访计划
//  Created by gouyz on 2018/8/9.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let followPlanChildCell = "followPlanChildCell"

class BPFollowPlanChildVC: GYZBaseVC {
    //随访计划内容一级id
    var cId: String = ""
    var planTitle: String = ""
    var dataList: [BPFollowPlanModel] = [BPFollowPlanModel]()
    
    var huanZheId: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = planTitle
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        tableView.tableHeaderView = headerView
        requestFollowPlanDatas()
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
        
        table.register(GYZLabArrowCell.self, forCellReuseIdentifier: followPlanChildCell)
        
        return table
    }()
    
    lazy var headerView: BPImgHeaderView = {
        let header = BPImgHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenWidth * 0.25))
        header.tagImgView.image = UIImage.init(named: "icon_follow_plan_banner")
        
        return header
        
    }()
    
    ///获取随访计划数据
    func requestFollowPlanDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("doctorindex/plan_title",parameters: ["id": cId],  success: { (response) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(response)
            
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["data"].array else { return }
                
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = BPFollowPlanModel.init(dict: itemInfo)
                    
                    weakSelf?.dataList.append(model)
                }
                if weakSelf?.dataList.count > 0{
                    weakSelf?.tableView.reloadData()
                }
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(error)
            
            weakSelf?.showEmptyView(content: "加载失败，请点击重新加载", reload: {
                weakSelf?.requestFollowPlanDatas()
                weakSelf?.hiddenEmptyView()
            })
        })
    }
    
    func goPlanDetail(index: Int){
        
        let model = dataList[index]
        let vc = BPFollowPlanDetailVC()
        vc.planTitle = model.title!
        vc.url = model.url!
        vc.planId = model.id!
        vc.huanZheId = huanZheId
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension BPFollowPlanChildVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: followPlanChildCell) as! GYZLabArrowCell
        
        let model = dataList[indexPath.row]
        cell.nameLab.text = model.title
        cell.nameLab.textColor = kHeightGaryFontColor
        
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
        
        goPlanDetail(index: indexPath.row)
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
