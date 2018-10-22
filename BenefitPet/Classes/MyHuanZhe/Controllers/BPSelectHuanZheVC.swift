//
//  BPSelectHuanZheVC.swift
//  BenefitPet
//  选择患者
//  Created by gouyz on 2018/8/7.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let selectHuanZheCell = "selectHuanZheCell"
private let selectHuanZheHeader = "selectHuanZheHeader"

class BPSelectHuanZheVC: GYZBaseVC {
    
    /// 选择结果回调
    var selectBlock:((_ models: [String : BPHuanZheModel]) -> Void)?
    
    /// 是否是全选
    var isAllSelected: Bool = false
    /// 分组是否展开
    var headerIsExpanded: [Bool] = [Bool]()
    /// 分组是否是全选
    var isSelectGroups: [Bool] = [Bool]()
    
    var dataList: [BPHuanZheGroupModel] = [BPHuanZheGroupModel]()
    /// 选择患者
    var selectHuanZhes: [String : BPHuanZheModel] = [String : BPHuanZheModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "选择患者"
        self.view.backgroundColor = kWhiteColor
        
        view.addSubview(bottomView)
        bottomView.addSubview(allSelectedView)
        bottomView.addSubview(submitBtn)
        view.addSubview(tableView)
        
        bottomView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(kBottomTabbarHeight)
        }
        allSelectedView.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.centerY.equalTo(bottomView)
            make.size.equalTo(CGSize.init(width: 60, height: 34))
        }
        submitBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-20)
            make.centerY.equalTo(bottomView)
            make.size.equalTo(CGSize.init(width: 80, height: 30))
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
        
        table.register(BPSelectHuanZheCell.self, forCellReuseIdentifier: selectHuanZheCell)
        table.register(BPSelectHuanZheHeaderView.self, forHeaderFooterViewReuseIdentifier: selectHuanZheHeader)
        
        return table
    }()
    
    lazy var bottomView: UIView = UIView()
    ///全选按钮
    lazy var allSelectedView: LHSCheckView = {
        let view = LHSCheckView()
        view.nameLab.text = "全选"
        view.nameLab.textColor = kBlueFontColor
        view.tagImgView.image = UIImage.init(named: "icon_check_circle")
        view.addOnClickListener(target: self, action: #selector(onClickedAllSelected))
        
        return view
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
                    weakSelf?.isSelectGroups.append(false)
                    weakSelf?.dealGroup()
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
    /// 处理多次选择
    func dealGroup(){
        if selectHuanZhes.count > 0 {
            for (index,model) in dataList.enumerated(){
                
                var isAll = true
                for item in model.patientList{
                    if !selectHuanZhes.keys.contains(item.id!){
                        isAll = false
                        break
                    }
                }
                isSelectGroups[index] = isAll
            }
            
            isAllSelected = true
            for isCheck in isSelectGroups{
                if !isCheck{
                    isAllSelected = false
                    break
                }
            }
        }
        
    }
    
    /// 确认
    @objc func clickedSubmitBtn(){
        
        if selectHuanZhes.count > 0 {
            if selectBlock != nil{
                selectBlock!(selectHuanZhes)
            }
            clickedBackBtn()
        }else{
            MBProgressHUD.showAutoDismissHUD(message: "请选择患者")
        }
    }
    
    /// 全选
    @objc func onClickedAllSelected(){
        isAllSelected = !isAllSelected
        selectHuanZhes.removeAll()
        if isAllSelected {//全选
            
            for (index,model) in dataList.enumerated(){
                isSelectGroups[index] = true
                for item in model.patientList{
                    selectHuanZhes[item.id!] = item
                }
            }
            
            allSelectedView.tagImgView.image = UIImage.init(named: "icon_check_circle_selected")
        }else{
            allSelectedView.tagImgView.image = UIImage.init(named: "icon_check_circle")
            
            for (index,_) in dataList.enumerated(){
                isSelectGroups[index] = false
                
            }
        }
        tableView.reloadData()
    }
    
    /// 全选某个分组
    @objc func onClickedGroupHuanZhe(sender: UITapGestureRecognizer){
        
        let tag: Int = (sender.view?.tag)!
        isSelectGroups[tag] = !isSelectGroups[tag]
        
        let model = dataList[tag]
        for item in model.patientList {
            
            if isSelectGroups[tag]{
                if !selectHuanZhes.keys.contains(item.id!){
                    selectHuanZhes[item.id!] = item
                }
            }else{
                if selectHuanZhes.keys.contains(item.id!){
                    selectHuanZhes.removeValue(forKey: item.id!)
                }
            }
            
        }
        
        tableView.reloadSections(IndexSet(integer: tag), with: .none)
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
        
        if selectHuanZhes.keys.contains(personId) {
            selectHuanZhes.removeValue(forKey: personId)
            isSelectGroups[section] = false
            isAllSelected = false
            
        }else{
            selectHuanZhes[personId] = model.patientList[row]
            
            var isAll = true
            for item in model.patientList{
                if !selectHuanZhes.keys.contains(item.id!){
                    isAll = false
                    break
                }
            }
            
            isSelectGroups[section] = isAll
            isAllSelected = true
            for isCheck in isSelectGroups{
                if !isCheck{
                    isAllSelected = false
                    break
                }
            }
        }
        
        if isAllSelected {
            allSelectedView.tagImgView.image = UIImage.init(named: "icon_check_circle_selected")
        }else{
            allSelectedView.tagImgView.image = UIImage.init(named: "icon_check_circle")
            
        }
        tableView.reloadSections(IndexSet(integer: section), with: .none)
        
    }
}
extension BPSelectHuanZheVC: UITableViewDelegate,UITableViewDataSource{
    
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: selectHuanZheCell) as! BPSelectHuanZheCell
        
        let model = dataList[indexPath.section].patientList[indexPath.row]
        cell.dataModel = model
        
        if selectHuanZhes.keys.contains(model.id!) {
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
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: selectHuanZheHeader) as! BPSelectHuanZheHeaderView
        
        headerView.allCheckView.tag = section
        headerView.allCheckView.addOnClickListener(target: self, action: #selector(onClickedGroupHuanZhe(sender:)))
        headerView.allCheckView.nameLab.text = dataList[section].name! + "|" + dataList[section].num!
        
        headerView.tag = section
        headerView.addOnClickListener(target: self, action: #selector(clickHeaderView(sender:)))
        
        headerView.rightBtn.isSelected = headerIsExpanded[section]
        
        if isSelectGroups[section] {
            headerView.allCheckView.tagImgView.image = UIImage.init(named: "icon_check_circle_selected")
        }else{
            headerView.allCheckView.tagImgView.image = UIImage.init(named: "icon_check_circle")
        }
        
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
