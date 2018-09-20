//
//  BPMyHomeVC.swift
//  BenefitPet
//  个人主页
//  Created by gouyz on 2018/8/10.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

private let myHomeArticleCell = "myHomeArticleCell"
private let myHomeDongTaiCell = "myHomeDongTaiCell"

class BPMyHomeVC: GYZBaseVC {
    
    /// 是否显示文章
    var isArticle: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "玛丽线上工作室"
        
        setUpUI()
        
        articleBtn.set(image: UIImage.init(named: "icon_article"), title: "我的文章", titlePosition: .bottom, additionalSpacing: 5, state: .normal)
        articleBtn.set(image: UIImage.init(named: "icon_article_selected"), title: "我的文章", titlePosition: .bottom, additionalSpacing: 5, state: .selected)
        dongTaiBtn.set(image: UIImage.init(named: "icon_dongtai"), title: "我的动态", titlePosition: .bottom, additionalSpacing: 5, state: .normal)
        dongTaiBtn.set(image: UIImage.init(named: "icon_dongtai_selected"), title: "我的动态", titlePosition: .bottom, additionalSpacing: 5, state: .selected)
        
        articleBtn.isSelected = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpUI(){
        view.addSubview(bgView)
        bgView.addSubview(sendBtn)
        bgView.addSubview(userHeaderView)
        bgView.addSubview(nameLab)
        bgView.addSubview(desLab)
        bgView.addSubview(ratingLab)
        bgView.addSubview(levelLab)
        
        view.addSubview(bgBtnView)
        bgBtnView.addSubview(articleBtn)
        bgBtnView.addSubview(dongTaiBtn)
        
        view.addSubview(tableView)
        
        bgView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(kTitleAndStateHeight)
            make.height.equalTo(130)
        }
        sendBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.top.equalTo(kMargin)
            make.size.equalTo(CGSize.init(width: kTitleHeight, height: 30))
        }
        userHeaderView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(bgView)
            make.size.equalTo(CGSize.init(width: 60, height: 60))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(userHeaderView.snp.right).offset(kMargin)
            make.top.equalTo(userHeaderView)
            make.right.equalTo(-kMargin)
            make.height.equalTo(20)
        }
        desLab.snp.makeConstraints { (make) in
            make.left.height.right.equalTo(nameLab)
            make.top.equalTo(nameLab.snp.bottom)
        }
        ratingLab.snp.makeConstraints { (make) in
            make.left.height.equalTo(desLab)
            make.top.equalTo(desLab.snp.bottom)
            make.width.equalTo(70)
        }
        levelLab.snp.makeConstraints { (make) in
            make.left.equalTo(ratingLab.snp.right)
            make.centerY.equalTo(ratingLab)
            make.height.equalTo(16)
            make.width.equalTo(kTitleHeight)
        }
        bgBtnView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(bgView.snp.bottom)
            make.height.equalTo(80)
        }
        articleBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(kScreenWidth * 0.25)
            make.top.equalTo(kMargin)
            make.bottom.equalTo(-kMargin)
            make.width.equalTo(80)
        }
        
        dongTaiBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(kScreenWidth * 0.75)
            make.top.bottom.width.equalTo(articleBtn)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(bgBtnView.snp.bottom).offset(kMargin)
        }
    }
    
    /// 背景
    fileprivate lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = kBlueFontColor
        
        return view
    }()
    /// 发布按钮
    fileprivate lazy var sendBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "icon_mine_msg"), for: .normal)
        
        btn.addTarget(self, action: #selector(clickedSendBtn), for: .touchUpInside)
        
        return btn
    }()
    
    /// 用户头像 图片
    lazy var userHeaderView: UIImageView = {
        let imgView = UIImageView.init(image: UIImage.init(named: "icon_header_default"))
        imgView.cornerRadius = 30
        
        return imgView
    }()
    lazy var nameLab: UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kWhiteColor
        lab.text = "玛丽 主任医师|全科"
        
        return lab
    }()
    lazy var desLab: UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kWhiteColor
        lab.text = "益宠宠物医院"
        
        return lab
    }()
    lazy var ratingLab: UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kWhiteColor
        lab.text = "星级评定："
        
        return lab
    }()
    lazy var levelLab: UILabel = {
        let lab = UILabel()
        lab.backgroundColor = kYellowFontColor
        lab.font = k12Font
        lab.textColor = kRedFontColor
        lab.cornerRadius = 8
        lab.textAlignment = .center
        lab.text = "LV8"
        
        return lab
    }()
    
    /// 背景
    fileprivate lazy var bgBtnView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        
        return view
    }()
    /// 我的文章
    fileprivate lazy var articleBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = k13Font
        btn.setTitleColor(kBlackFontColor, for: .normal)
        btn.setTitleColor(kBlueFontColor, for: .selected)
        btn.addTarget(self, action: #selector(clickedArticleBtn), for: .touchUpInside)
        
        return btn
    }()
    /// 我的动态
    fileprivate lazy var dongTaiBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = k13Font
        btn.setTitleColor(kBlackFontColor, for: .normal)
        btn.setTitleColor(kBlueFontColor, for: .selected)
        btn.addTarget(self, action: #selector(clickedDongTaiBtn), for: .touchUpInside)
        
        return btn
    }()
    
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
        
        table.register(GYZLabArrowCell.self, forCellReuseIdentifier: myHomeArticleCell)
        table.register(BPMyHomeDongTaiCell.self, forCellReuseIdentifier: myHomeDongTaiCell)
        
        return table
    }()
    
    /// 发布
    @objc func clickedSendBtn(){
        let vc = BPPublishDynamicVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 我的文章
    @objc func clickedArticleBtn(){
        articleBtn.isSelected = true
        dongTaiBtn.isSelected = false
        isArticle = true
        tableView.reloadData()
    }
    /// 我的动态
    @objc func clickedDongTaiBtn(){
        articleBtn.isSelected = false
        dongTaiBtn.isSelected = true
        isArticle = false
        tableView.reloadData()
    }
}

extension BPMyHomeVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isArticle {
            let cell = tableView.dequeueReusableCell(withIdentifier: myHomeArticleCell) as! GYZLabArrowCell
            cell.nameLab.text = "宠物的日常正确喂养"
            
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: myHomeDongTaiCell) as! BPMyHomeDongTaiCell
            
            cell.imgViews.imgWidth = kPhotosImgHeight4Processing
            cell.imgViews.imgHight = kPhotosImgHeight4Processing
            cell.imgViews.perRowItemCount = 3
            
            cell.imgViews.selectImgs = [UIImage.init(named: "icon_dongtai_default"),UIImage.init(named: "icon_dongtai_default"),UIImage.init(named: "icon_dongtai_default")] as? [UIImage]
            
            ///查看大图
            cell.imgViews.onClickedImgDetailsBlock = {[weak self] (index,urls) in
                
                //            let browser = SKPhotoBrowser(photos: GYZTool.createWebPhotos(urls: urls))
                //            browser.initializePageIndex(index)
                //            //        browser.delegate = self
                //
                //            self?.present(browser, animated: true, completion: nil)
            }
            
            /// 如果图片张数超出最大限制数，只取最大限制数的图片
            //        var imgCount : Int = imgUrls.count
            //        if imgCount > kMaxSelectCount {
            //            imgCount = kMaxSelectCount
            //        }
            //        let rowIndex = ceil(CGFloat.init(imgCount) / 3.0)//向上取整
            
            //        cell.imgViews.isHidden = false
            cell.imgViews.snp.updateConstraints({ (make) in
                make.height.equalTo(cell.imgViews.imgHight)
            })
            
            cell.selectionStyle = .none
            return cell
        }
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
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
