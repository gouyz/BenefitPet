//
//  BPStudyVC.swift
//  BenefitPet
//  学习园地
//  Created by gouyz on 2018/8/22.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let studyVideoCell = "studyVideoCell"
private let studyCell = "studyCell"
private let studyHeader = "studyHeader"

class BPStudyVC: GYZBaseVC {
    
    let titleArr : [String] = ["专家网课","专业文章","医生快课"]
    var dataModel: BPDocStudyModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "学习园地"
        
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
    
    /// 懒加载UITableView
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        
        // 设置大概高度
        table.estimatedRowHeight = kTitleHeight
        // 设置行高为自动适配
        table.rowHeight = UITableViewAutomaticDimension
        
        table.register(BPStudyVideoCell.self, forCellReuseIdentifier: studyVideoCell)
        table.register(GYZLabArrowCell.self, forCellReuseIdentifier: studyCell)
        
        table.register(BPStudyHeaderView.self, forHeaderFooterViewReuseIdentifier: studyHeader)
        
        return table
    }()
    
    /// 查看全部
    @objc func onClickedHeaderView(sender: UITapGestureRecognizer){
        let tag: Int = (sender.view?.tag)!
        
        switch tag {
        case 0://专家网课
            let vc = BPZhuanJiaWangKeVC()
            navigationController?.pushViewController(vc, animated: true)
        case 1://专业文章
            let vc = BPArticlesVC()
            navigationController?.pushViewController(vc, animated: true)
        case 2://医生快课
            let vc = BPDocStudyVC()
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
    ///获取数据
    func requestDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("school/school_study",  success: { (response) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(response)
            
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["data"].dictionaryObject else { return }
                weakSelf?.dataModel = BPDocStudyModel.init(dict: data)
                
                weakSelf?.tableView.reloadData()
                
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
    func goDetailVC(model: BPYongYaoGuideModel){
        
        let vc = BPGuideDetailVC()
        vc.articleTitle = model.title!
        vc.url = model.url!
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 网课详情
    func goWangKeDetailVC(index: Int){
        let vc = BPWangKeDetailVC()
        vc.articleId = (dataModel?.wangkeList[index].id!)!
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension BPStudyVC : UITableViewDelegate,UITableViewDataSource{
    /// MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return titleArr.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if dataModel == nil {
            return 0
        }
        
        if section == 0 {
            return 1
        }else if section == 1{
            return (dataModel?.articleList.count)!
        }else{
            return (dataModel?.kuaikeList.count)!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: studyVideoCell) as! BPStudyVideoCell
            cell.dataModels = dataModel?.wangkeList
            
            cell.didSelectItemBlock = {[weak self] (index) in
                self?.goWangKeDetailVC(index: index)
            }
            
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: studyCell) as! GYZLabArrowCell
            
            if indexPath.section == 1 {//专业文章
                
                cell.nameLab.text = dataModel?.articleList[indexPath.row].title
            }else {// 医生快课
                cell.nameLab.text = dataModel?.kuaikeList[indexPath.row].title
            }
            
            cell.selectionStyle = .none
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: studyHeader) as! BPStudyHeaderView
        
        headerView.nameLab.text = titleArr[section]
        
        headerView.tag = section
        headerView.addOnClickListener(target: self, action: #selector(onClickedHeaderView(sender:)))
        
        return headerView
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            goDetailVC(model: (dataModel?.articleList[indexPath.row])!)
        }else if indexPath.section == 2 {
            goDetailVC(model: (dataModel?.kuaikeList[indexPath.row])!)
        }
    }
    
    ///MARK : UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kTitleHeight
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
        
    }
}
