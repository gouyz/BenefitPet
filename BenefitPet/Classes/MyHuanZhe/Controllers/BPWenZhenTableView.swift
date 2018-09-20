//
//  BPWenZhenTableView.swift
//  BenefitPet
//  问诊表库
//  Created by gouyz on 2018/8/9.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

private let wenZhenTableCell = "wenZhenTableCell"
private let wenZhenTableHeader = "wenZhenTableHeader"

class BPWenZhenTableView: GYZBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "问诊表库"
        
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
        
        table.register(GYZLabArrowCell.self, forCellReuseIdentifier: wenZhenTableCell)
        table.register(BPWenZhenTableHeaderView.self, forHeaderFooterViewReuseIdentifier: wenZhenTableHeader)
        
        return table
    }()
    
    lazy var headerView: BPImgHeaderView = {
        let header = BPImgHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenWidth * 0.25))
        header.tagImgView.image = UIImage.init(named: "icon_past_wenzhen_banner")
        
        return header
        
    }()
    
    
    /// 问诊表详情
    func goDetailVC(){
        let vc = BPWenZhenTableDetailVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension BPWenZhenTableView: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 18
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: wenZhenTableCell) as! GYZLabArrowCell
        
        cell.nameLab.text = "宠物营养不良问诊表"
        cell.nameLab.textColor = kHeightGaryFontColor
        
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: wenZhenTableHeader) as! BPWenZhenTableHeaderView
        
        return headerView
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        goDetailVC()
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
