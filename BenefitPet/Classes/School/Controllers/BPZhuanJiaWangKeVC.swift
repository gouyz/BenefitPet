//
//  BPZhuanJiaWangKeVC.swift
//  BenefitPet
//  专家网课
//  Created by gouyz on 2018/8/22.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let zhuanJiaWangKeCell = "zhuanJiaWangKeCell"

class BPZhuanJiaWangKeVC: GYZBaseVC {
    
    var dataList: [BPWangKeModel] = [BPWangKeModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "专家网课"
        self.view.backgroundColor = kWhiteColor
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(kMargin)
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.bottom.equalTo(view)
        }
        requestDatas()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        /// 头像宽度
        let imgWidth = (kScreenWidth - 4 * kMargin)/3.0
        //设置cell的大小
        layout.itemSize = CGSize(width: imgWidth, height: imgWidth * 0.8)
        
        //每个Item之间最小的间距
        layout.minimumInteritemSpacing = kMargin
        //每行之间最小的间距
        layout.minimumLineSpacing = kMargin
        
        let collView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collView.dataSource = self
        collView.delegate = self
        collView.backgroundColor = kWhiteColor
        collView.showsHorizontalScrollIndicator = false
        collView.showsVerticalScrollIndicator = false
        
        collView.register(BPStudyVideoChildCell.self, forCellWithReuseIdentifier: zhuanJiaWangKeCell)
        
        return collView
    }()

    
    ///获取网课数据
    func requestDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("school/school_study_wangke",  success: { (response) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(response)
            
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["data"]["wangke"].array else { return }
                weakSelf?.dataList.removeAll()
                
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = BPWangKeModel.init(dict: itemInfo)
                    
                    weakSelf?.dataList.append(model)
                }
                if weakSelf?.dataList.count > 0{
                    weakSelf?.hiddenEmptyView()
                    weakSelf?.collectionView.reloadData()
                }else{
                    ///显示空页面
                    weakSelf?.showEmptyView(content: "暂无网课信息")
                }
                
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
}

extension BPZhuanJiaWangKeVC : UICollectionViewDataSource,UICollectionViewDelegate{
    // MARK: UICollectionViewDataSource 代理方法
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: zhuanJiaWangKeCell, for: indexPath) as! BPStudyVideoChildCell
        
        cell.dataModel = dataList[indexPath.row]
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate的代理方法
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
}
