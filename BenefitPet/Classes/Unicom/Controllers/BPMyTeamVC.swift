//
//  BPMyTeamVC.swift
//  BenefitPet
//  我的团队
//  Created by gouyz on 2018/8/22.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

private let myTeamCell = "myTeamCell"
private let myTeamHeader = "myTeamHeader"

class BPMyTeamVC: GYZBaseVC {

    let titleArr : [String] = ["院长","副院长","主任医师","护士"]
    /// 头像宽度
    let imgWidth = (kScreenWidth - 6 * klineWidth) * 0.2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "我的团队"
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
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
    
}

extension BPMyTeamVC : UICollectionViewDataSource,UICollectionViewDelegate{
    // MARK: UICollectionViewDataSource 代理方法
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return titleArr.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section < 2{
            return 1
        }
        return 16
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: myTeamCell, for: indexPath) as! BPMyTeamCell
        
        
        return cell
    }
    
    // 返回自定义HeadView或者FootView
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var reusableview: UICollectionReusableView!
        
        if kind == UICollectionElementKindSectionHeader {
            
            reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: myTeamHeader, for: indexPath) as! BPMyTeamHeaderView
            
            (reusableview as! BPMyTeamHeaderView).nameLab.text = titleArr[indexPath.section]
        }
        
        return reusableview
    }
    // MARK: UICollectionViewDelegate的代理方法
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
