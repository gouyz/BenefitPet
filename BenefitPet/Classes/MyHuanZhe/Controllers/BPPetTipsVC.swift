//
//  BPPetTipsVC.swift
//  BenefitPet
//  益宠小贴士
//  Created by gouyz on 2018/8/9.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let petTipsCell = "petTipsCell"
private let petTipsHeader = "petTipsHeader"

class BPPetTipsVC: GYZBaseVC {
    
    var dataList: [BArticlesModel] = [BArticlesModel]()
    var huanZheId: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "益宠小贴士"
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        tableView.tableHeaderView = headerView
        requestTipsDatas()
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
        
        table.register(GYZLabArrowCell.self, forCellReuseIdentifier: petTipsCell)
        table.register(BPWenZhenTableHeaderView.self, forHeaderFooterViewReuseIdentifier: petTipsHeader)
        
        return table
    }()
    
    lazy var headerView: BPImgHeaderView = {
        let header = BPImgHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenWidth * 0.25))
        header.tagImgView.image = UIImage.init(named: "icon_pet_tips_banner")
        
        return header
        
    }()
    
    ///获取小贴士数据
    func requestTipsDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("patient/tips_list",  success: { (response) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(response)
            
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["data"].array else { return }
                
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = BArticlesModel.init(dict: itemInfo)
                    
                    weakSelf?.dataList.append(model)
                }
                if weakSelf?.dataList.count > 0{
                    weakSelf?.hiddenEmptyView()
                    weakSelf?.tableView.reloadData()
                }else{
                    ///显示空页面
                    weakSelf?.showEmptyView(content: "暂无小贴士信息")
                }
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(error)
            
            weakSelf?.showEmptyView(content: "加载失败，请点击重新加载", reload: {
                
                weakSelf?.requestTipsDatas()
                weakSelf?.hiddenEmptyView()
            })
        })
    }
    
    /// 新闻详情
    func goArticleDetail(index:Int){
        let model = dataList[index]
        let vc = BPArticleDetailVC()
        vc.url = model.url!
        vc.articleTitle = model.title!
        vc.huanZheId = huanZheId
        vc.articleId = model.id!
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension BPPetTipsVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: petTipsCell) as! GYZLabArrowCell
        
        cell.nameLab.text = dataList[indexPath.row].title
        cell.nameLab.textColor = kHeightGaryFontColor
        
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: petTipsHeader) as! BPWenZhenTableHeaderView
        headerView.nameLab.text = "全科小贴士"
        
        return headerView
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        goArticleDetail(index: indexPath.row)
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

