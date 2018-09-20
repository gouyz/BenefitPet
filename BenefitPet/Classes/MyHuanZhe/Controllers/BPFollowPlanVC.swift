//
//  BPFollowPlanVC.swift
//  BenefitPet
//  随访计划
//  Created by gouyz on 2018/8/9.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

private let followPlanCell = "followPlanCell"
private let followPlanHeader = "followPlanHeader"

class BPFollowPlanVC: GYZBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "随访计划"
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        tableView.tableHeaderView = headerView
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
        
        table.register(GYZLabArrowCell.self, forCellReuseIdentifier: followPlanCell)
        table.register(BPWenZhenTableHeaderView.self, forHeaderFooterViewReuseIdentifier: followPlanHeader)
        
        return table
    }()
    
    lazy var headerView: BPImgHeaderView = {
        let header = BPImgHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenWidth * 0.25))
        header.tagImgView.image = UIImage.init(named: "icon_follow_plan_banner")
        
        return header
        
    }()
    
    /// 子随访计划
    func goFollowPlanChild(){
        let vc = BPFollowPlanChildVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension BPFollowPlanVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: followPlanCell) as! GYZLabArrowCell
        
        cell.nameLab.text = "就诊结束随访计划"
        cell.nameLab.textColor = kHeightGaryFontColor
        
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: followPlanHeader) as! BPWenZhenTableHeaderView
        headerView.nameLab.text = "全科随访计划"
        
        return headerView
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        goFollowPlanChild()
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return kTitleHeight
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 34
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
