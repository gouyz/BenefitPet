//
//  BPBenifitUniversityVC.swift
//  BenefitPet
//  益宠大学
//  Created by gouyz on 2018/8/21.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let benifitUniversityCell = "benifitUniversityCell"

class BPBenifitUniversityVC: GYZBaseVC {
    
    var dataList: [BPSchoolModel] = [BPSchoolModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "益宠大学"
        
        let rightBtn = UIButton(type: .custom)
        rightBtn.setTitle("创建", for: .normal)
        rightBtn.titleLabel?.font = k13Font
        rightBtn.setTitleColor(kBlackFontColor, for: .normal)
        rightBtn.frame = CGRect.init(x: 0, y: 0, width: kTitleHeight, height: kTitleHeight)
        rightBtn.addTarget(self, action: #selector(onClickRightBtn), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        requestClassDatas()
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
        
        table.register(BPBenefitUniversityCell.self, forCellReuseIdentifier: benifitUniversityCell)
        
        return table
    }()
    /// 创建
    @objc func onClickRightBtn(){
        let vc = BPAddClassVC()
        vc.resultBlock = {[weak self] () in
            
            self?.requestClassDatas()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    ///获取培训班数据
    func requestClassDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("school/school_college", parameters: ["d_id": userDefaults.string(forKey: "userId") ?? ""],  success: { (response) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(response)
            
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["data"].array else { return }
                weakSelf?.dataList.removeAll()
                
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = BPSchoolModel.init(dict: itemInfo)
                    
                    weakSelf?.dataList.append(model)
                }
                if weakSelf?.dataList.count > 0{
                    weakSelf?.hiddenEmptyView()
                    weakSelf?.tableView.reloadData()
                }else{
                    ///显示空页面
                    weakSelf?.showEmptyView(content: "暂无培训班信息")
                }
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(error)
            
            weakSelf?.showEmptyView(content: "加载失败，请点击重新加载", reload: {
                weakSelf?.requestClassDatas()
                weakSelf?.hiddenEmptyView()
            })
        })
    }
    /// 加入培训班
    @objc func onClickedAdd(sender: UITapGestureRecognizer){
        let tag = sender.view?.tag
        requestAddClass(model: dataList[tag!], index:tag!)
    }
    
    /// 加入培训班
    func requestAddClass(model: BPSchoolModel, index: Int){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("school/school_college_join", parameters: ["d_id": userDefaults.string(forKey: "userId") ?? "","id":model.id!],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                weakSelf?.dataList.remove(at: index)
                weakSelf?.tableView.reloadData()
                if weakSelf?.dataList.count == 0{
                    ///显示空页面
                    weakSelf?.showEmptyView(content: "暂无培训班信息")
                }
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
}

extension BPBenifitUniversityVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: benifitUniversityCell) as! BPBenefitUniversityCell
        
        cell.dataModel = dataList[indexPath.row]
        cell.addLab.tag = indexPath.row
        cell.addLab.addOnClickListener(target: self, action: #selector(onClickedAdd(sender:)))
        
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
        
        return kTitleHeight
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
