//
//  BPSelectHuanZheVC.swift
//  BenefitPet
//  选择患者
//  Created by gouyz on 2018/8/7.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

private let selectHuanZheCell = "selectHuanZheCell"
private let selectHuanZheHeader = "selectHuanZheHeader"

class BPSelectHuanZheVC: GYZBaseVC {
    
    /// 是否是全选
    var isAllSelected: Bool = false
    /// 分组是否展开
    var headerIsExpanded: [Bool] = [Bool]()
    /// 分组是否是全选
    var isSelectGroups: [Bool] = [Bool]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "选择患者"
        self.view.backgroundColor = kWhiteColor
        
        headerIsExpanded.append(false)
        headerIsExpanded.append(false)
        headerIsExpanded.append(false)
        headerIsExpanded.append(false)
        headerIsExpanded.append(false)
        
        isSelectGroups.append(false)
        isSelectGroups.append(false)
        isSelectGroups.append(false)
        isSelectGroups.append(false)
        isSelectGroups.append(false)
        
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
    /// 确认
    @objc func clickedSubmitBtn(){
        
    }
    
    /// 全选
    @objc func onClickedAllSelected(){
        isAllSelected = !isAllSelected
        
        if isAllSelected {
            allSelectedView.tagImgView.image = UIImage.init(named: "icon_check_circle_selected")
        }else{
            allSelectedView.tagImgView.image = UIImage.init(named: "icon_check_circle")
        }
    }
    
    /// 全选某个分组
    @objc func onClickedGroupHuanZhe(sender: UITapGestureRecognizer){
        
        let tag: Int = (sender.view?.tag)!
        isSelectGroups[tag] = !isSelectGroups[tag]
        
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
}
extension BPSelectHuanZheVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if headerIsExpanded[section] {
            return 4
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: selectHuanZheCell) as! BPSelectHuanZheCell
        
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: selectHuanZheHeader) as! BPSelectHuanZheHeaderView
        
        headerView.allCheckView.tag = section
        headerView.allCheckView.addOnClickListener(target: self, action: #selector(onClickedGroupHuanZhe(sender:)))
        
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
