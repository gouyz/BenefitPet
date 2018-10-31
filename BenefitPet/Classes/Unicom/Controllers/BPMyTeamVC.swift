//
//  BPMyTeamVC.swift
//  BenefitPet
//  我的团队
//  Created by gouyz on 2018/8/22.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let myTeamCell = "myTeamCell"
private let myTeamHeader = "myTeamHeader"

class BPMyTeamVC: GYZBaseVC {

    var dataList: [BPMyTeamModel] = [BPMyTeamModel]()
    /// 头像宽度
    let imgWidth = (kScreenWidth - 6 * klineWidth) * 0.2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "我的团队"
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        requestFriendListDatas()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize.init(width: imgWidth, height: imgWidth + 20)
        //每个Item之间最小的间距
        layout.minimumInteritemSpacing = klineWidth
        //每行之间最小的间距
        layout.minimumLineSpacing = 5
        
        layout.headerReferenceSize = CGSize.init(width: kScreenWidth, height: kTitleHeight)
        
        let collView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collView.dataSource = self
        collView.delegate = self
        collView.backgroundColor = kWhiteColor
        
        collView.register(BPMyTeamCell.self, forCellWithReuseIdentifier: myTeamCell)
        
        collView.register(BPMyTeamHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: myTeamHeader)
        
        return collView
    }()
    
    ///获取好友数据
    func requestFriendListDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("contact/team_list", parameters: ["d_id": userDefaults.string(forKey: "userId") ?? ""],  success: { (response) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(response)
            
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["data"].array else { return }
                weakSelf?.dataList.removeAll()
                
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = BPMyTeamModel.init(dict: itemInfo)
                    
                    weakSelf?.dataList.append(model)
                }
                if weakSelf?.dataList.count > 0{
                    weakSelf?.hiddenEmptyView()
                    weakSelf?.collectionView.reloadData()
                }else{
                    ///显示空页面
                    weakSelf?.showEmptyView(content: "暂无团队信息")
                }
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(error)
            
            weakSelf?.showEmptyView(content: "加载失败，请点击重新加载", reload: {
                weakSelf?.requestFriendListDatas()
                weakSelf?.hiddenEmptyView()
            })
        })
    }
}

extension BPMyTeamVC : UICollectionViewDataSource,UICollectionViewDelegate{
    // MARK: UICollectionViewDataSource 代理方法
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataList.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dataList[section].doctorList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: myTeamCell, for: indexPath) as! BPMyTeamCell
        
        cell.dataModel = dataList[indexPath.section].doctorList[indexPath.row]
        
        return cell
    }
    
    // 返回自定义HeadView或者FootView
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var reusableview: UICollectionReusableView!
        
        if kind == UICollectionElementKindSectionHeader {
            
            reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: myTeamHeader, for: indexPath) as! BPMyTeamHeaderView
            
            (reusableview as! BPMyTeamHeaderView).nameLab.text = dataList[indexPath.section].job_title
        }
        
        return reusableview
    }
    // MARK: UICollectionViewDelegate的代理方法
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
