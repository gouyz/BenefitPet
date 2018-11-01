//
//  BPStudyVideoCell.swift
//  BenefitPet
//  学习园地 专家课网 cell
//  Created by gouyz on 2018/8/22.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

private let studyVideoChildCell = "studyVideoChildCell"

class BPStudyVideoCell: UITableViewCell {
    
    /// 填充数据
    var dataModels : [BPWangKeModel]?{
        didSet{
            if dataModels != nil {
                
                collectionView.reloadData()
            }
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.backgroundColor = kWhiteColor
        
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(kMargin)
            make.bottom.equalTo(-kMargin)
            make.height.equalTo((kScreenWidth - 4 * kMargin)/3.0 * 1.6 + kMargin)
        }
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
        collView.isScrollEnabled = false
        
        collView.register(BPStudyVideoChildCell.self, forCellWithReuseIdentifier: studyVideoChildCell)
        
        return collView
    }()
}

extension BPStudyVideoCell : UICollectionViewDataSource,UICollectionViewDelegate{
    // MARK: UICollectionViewDataSource 代理方法
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if dataModels == nil {
            return 0
        }
        return (dataModels?.count)!
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: studyVideoChildCell, for: indexPath) as! BPStudyVideoChildCell
        
        cell.dataModel = dataModels?[indexPath.row]
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate的代理方法
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
}
