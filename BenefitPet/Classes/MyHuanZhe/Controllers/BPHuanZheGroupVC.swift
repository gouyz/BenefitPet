//
//  BPHuanZheGroupVC.swift
//  BenefitPet
//  患者分组
//  Created by gouyz on 2018/8/6.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let huanZheGroupCell = "huanZheGroupCell"

class BPHuanZheGroupVC: GYZBaseVC {
    
    var dataList: [BPHuanZheGroupModel] = [BPHuanZheGroupModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "患者分组"
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        requestGroupDatas()
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
        
        table.register(BPHuanZheGroupCell.self, forCellReuseIdentifier: huanZheGroupCell)
        
        return table
    }()
    /// 编辑分组
    func goEditVC(isEdit : Bool){
        let vc = BPEditGroupVC()
        vc.isEdit = isEdit
        navigationController?.pushViewController(vc, animated: true)
    }
    
    ///获取分组数据
    func requestGroupDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("patient/show_group",parameters: ["id": userDefaults.string(forKey: "userId") ?? ""],  success: { (response) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(response)
            
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["data"].array else { return }
                
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = BPHuanZheGroupModel.init(dict: itemInfo)
                    
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
            
        })
    }
}
extension BPHuanZheGroupVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: huanZheGroupCell) as! BPHuanZheGroupCell
        
        if indexPath.section == 0 {
            cell.nameLab.text = "添加新分组"
        }else{
            
            let model = dataList[indexPath.row]
            cell.nameLab.text = "\(model.name!)（\(model.num!)）"
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
        if indexPath.section == 0 {//添加分组
            goEditVC(isEdit: false)
        }else{// 编辑分组
            goEditVC(isEdit: true)
        }
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kTitleHeight
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kMargin
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
