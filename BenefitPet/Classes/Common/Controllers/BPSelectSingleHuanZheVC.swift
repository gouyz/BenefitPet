//
//  BPSelectSingleHuanZheVC.swift
//  BenefitPet
//  单选患者
//  Created by gouyz on 2018/10/31.
//  Copyright © 2018 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let selectSingleHuanZheCell = "selectSingleHuanZheCell"
private let selectSingleHuanZheHeader = "selectSingleHuanZheHeader"

class BPSelectSingleHuanZheVC: GYZBaseVC {

    /// 选择结果回调
    var selectBlock:((_ model: BPHuanZheModel) -> Void)?
    
    /// 分组是否展开
    var headerIsExpanded: [Bool] = [Bool]()
    
    var dataList: [BPHuanZheGroupModel] = [BPHuanZheGroupModel]()
    /// 选择患者
    var selectHuanZheModel: BPHuanZheModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "选择患者"
        self.view.backgroundColor = kWhiteColor
        
        view.addSubview(submitBtn)
        view.addSubview(tableView)
        submitBtn.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(kBottomTabbarHeight)
        }
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.bottom.equalTo(submitBtn.snp.top)
            if #available(iOS 11.0, *) {
                make.top.equalTo(view)
            }else{
                make.top.equalTo(kTitleAndStateHeight)
            }
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
        table.backgroundColor = kWhiteColor
        
        table.register(BPSelectHuanZheCell.self, forCellReuseIdentifier: selectSingleHuanZheCell)
        table.register(BPSelectHuanZheHeaderView.self, forHeaderFooterViewReuseIdentifier: selectSingleHuanZheHeader)
        
        return table
    }()
    /// 确认
    lazy var submitBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBtnClickBGColor
        btn.titleLabel?.font = k15Font
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.setTitle("确认", for: .normal)
        btn.addTarget(self, action: #selector(clickedSubmitBtn), for: .touchUpInside)
        btn.cornerRadius = kCornerRadius
        
        return btn
    }()
    
    ///获取分组数据
    func requestGroupDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("patient/mypatient",parameters: ["id": userDefaults.string(forKey: "userId") ?? ""],  success: { (response) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(response)
            
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["data"].array else { return }
                
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = BPHuanZheGroupModel.init(dict: itemInfo)
                    
                    weakSelf?.dataList.append(model)
                    weakSelf?.headerIsExpanded.append(false)
                }
                if weakSelf?.dataList.count > 0{
                    weakSelf?.hiddenEmptyView()
                    weakSelf?.tableView.reloadData()
                }else{
                    ///显示空页面
                    weakSelf?.showEmptyView(content: "暂无患者信息")
                }
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(error)
            weakSelf?.showEmptyView(content: "加载失败，请点击重新加载", reload: {
                weakSelf?.requestGroupDatas()
                weakSelf?.hiddenEmptyView()
            })
        })
    }
    
    /// 确认
    @objc func clickedSubmitBtn(){
        
        if selectHuanZheModel != nil {
            if selectBlock != nil{
                selectBlock!(selectHuanZheModel!)
            }
            clickedBackBtn()
        }else{
            MBProgressHUD.showAutoDismissHUD(message: "请选择患者")
        }
    }
    
    /// header 点击事件，展开与收起
    ///
    /// - Parameter sender:
    @objc func clickHeaderView(sender: UITapGestureRecognizer){
        let tag: Int = (sender.view?.tag)!
        headerIsExpanded[tag] = !headerIsExpanded[tag]
        
        tableView.reloadSections(IndexSet(integer: tag), with: .none)
    }
    /// 单选
    @objc func onClickedSelectSingle(sender:UITapGestureRecognizer){
        let tag: String = (sender.view?.accessibilityIdentifier)!
        let indexs = tag.components(separatedBy: ",")
        
        let section: Int = Int.init(indexs[0])!
        let row: Int = Int.init(indexs[1])!
        let model = dataList[section]
        let personId: String = model.patientList[row].id!
        
        if selectHuanZheModel == nil {
            selectHuanZheModel = model.patientList[row]
        }else{
            if selectHuanZheModel?.id == personId{
                selectHuanZheModel = nil
            }else{
                selectHuanZheModel = model.patientList[row]
            }
        }
        tableView.reloadSections(IndexSet(integer: section), with: .none)
        
    }
}
extension BPSelectSingleHuanZheVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataList.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if headerIsExpanded[section] {
            return dataList[section].patientList.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: selectSingleHuanZheCell) as! BPSelectHuanZheCell
        
        let model = dataList[indexPath.section].patientList[indexPath.row]
        cell.dataModel = model
        
        if selectHuanZheModel != nil && selectHuanZheModel?.id == model.id {
            cell.checkImgView.image = UIImage.init(named: "icon_check_circle_selected")
        }else{
            cell.checkImgView.image = UIImage.init(named: "icon_check_circle")
        }
        
        cell.checkImgView.accessibilityIdentifier = "\(indexPath.section),\(indexPath.row)"
        cell.checkImgView.addOnClickListener(target: self, action: #selector(onClickedSelectSingle(sender:)))
        
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: selectSingleHuanZheHeader) as! BPSelectHuanZheHeaderView
        
        headerView.allCheckView.tagImgView.isHidden = true
        headerView.allCheckView.nameLab.text = dataList[section].name! + "|" + dataList[section].num!
        
        headerView.tag = section
        headerView.addOnClickListener(target: self, action: #selector(clickHeaderView(sender:)))
        
        headerView.rightBtn.isSelected = headerIsExpanded[section]
        
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
        return kTitleHeight
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
}
