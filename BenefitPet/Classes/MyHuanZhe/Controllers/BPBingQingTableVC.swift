//
//  BPBingQingTableVC.swift
//  BenefitPet
//  病情表
//  Created by gouyz on 2018/11/12.
//  Copyright © 2018 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let bingQingTableCell = "bingQingTableCell"

class BPBingQingTableVC: GYZBaseVC {

    var dataList: [BPYongYaoGuideModel] = [BPYongYaoGuideModel]()
    
    var huanZheId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "病情表"
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        requestDatas()
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
        
        table.register(GYZLabArrowCell.self, forCellReuseIdentifier: bingQingTableCell)
        
        return table
    }()
    ///获取病情表数据
    func requestDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("patient/condition",parameters: ["d_id": userDefaults.string(forKey: "userId") ?? "","u_id": huanZheId],  success: { (response) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(response)
            
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["data"].array else { return }
                weakSelf?.dataList.removeAll()
                
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = BPYongYaoGuideModel.init(dict: itemInfo)
                    
                    weakSelf?.dataList.append(model)
                }
                if weakSelf?.dataList.count > 0{
                    weakSelf?.hiddenEmptyView()
                    weakSelf?.tableView.reloadData()
                }else{
                    ///显示空页面
                    weakSelf?.showEmptyView(content: "暂无病情表信息")
                }
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(error)
            
            weakSelf?.showEmptyView(content: "加载失败，请点击重新加载", reload: {
                weakSelf?.hiddenEmptyView()
                weakSelf?.requestDatas()
            })
        })
    }
    /// 详情
    func goDetail(index: Int){
        
        let model = dataList[index]
        let vc = BPGuideDetailVC()
        vc.articleTitle = (model.title?.getDateTime(format: "yyyy-MM-dd HH:mm:ss"))!
        vc.url = model.url!
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension BPBingQingTableVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: bingQingTableCell) as! GYZLabArrowCell
        
        cell.nameLab.text = dataList[indexPath.row].title?.getDateTime(format: "yyyy-MM-dd HH:mm:ss")
        
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
        
        goDetail(index: indexPath.row)
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
