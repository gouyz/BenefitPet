//
//  BPSchoolVC.swift
//  BenefitPet
//  兽医学院
//  Created by gouyz on 2018/7/27.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit


private let schoolCell = "schoolCell"
private let schoolHeader = "schoolHeader"

class BPSchoolVC: GYZBaseVC {
    
    var titles: [String] = ["学习园地","益宠大学","用药指南","我的培训班"]
    var contents: [String] = ["随时随地方便学习","一键发送，轻松宣教","您的随身药品秘籍","您的随身宠物医生"]
    var tagImgs: [String] = ["icon_school_xuexi","icon_school_ycdx","icon_school_tougao","icon_school_myclass"]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "兽医学院"
        
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
        
        /// cell 的width要小于屏幕宽度的一半，才能一行显示2个以上的Item
        let itemH = (kScreenWidth - klineWidth * 2)/2.0
        //设置cell的大小
        layout.itemSize = CGSize(width: itemH, height: itemH)
        
        //每个Item之间最小的间距
        layout.minimumInteritemSpacing = klineWidth
        //每行之间最小的间距
        layout.minimumLineSpacing = klineWidth
        
        let collView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collView.dataSource = self
        collView.delegate = self
        collView.backgroundColor = kBackgroundColor
        
        collView.register(BPSchoolCell.self, forCellWithReuseIdentifier: schoolCell)
        
        collView.register(BPSchoolHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: schoolHeader)
        
        
        return collView
    }()
    /// 益宠大学
    func goUniversity(){
        let vc = BPBenifitUniversityVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 用药指南
    func goGuide(){
        let vc = BPYongYaoGuideVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 我的培训班
    func goMyClass(){
        let vc = BPMyClassManagerVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 学习园地
    func goStudy(){
        let vc = BPStudyVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension BPSchoolVC: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    // MARK: UICollectionViewDataSource 代理方法
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return titles.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: schoolCell, for: indexPath) as! BPSchoolCell
        
        cell.bgImgView.image = UIImage.init(named: tagImgs[indexPath.row])
        cell.titleLab.text = titles[indexPath.row]
        cell.desLab.text = contents[indexPath.row]
        
        
        return cell
    }
    
    // 返回自定义HeadView或者FootView
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var reusableview: UICollectionReusableView!
        
        if kind == UICollectionElementKindSectionHeader {
            
            reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: schoolHeader, for: indexPath) as! BPSchoolHeaderView
            
            
            //            (reusableview as! ORSearchContentHeaderView).contentLab.text = ""
        }
        
        return reusableview
    }
    
    // MARK: UICollectionViewDelegate的代理方法
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0://学习园地
            goStudy()
        case 1://益宠大学
            goUniversity()
        case 2://用药指南
            goGuide()
        case 3://我的培训班
            goMyClass()
        default:
            break
        }
    }
    
    //MARK: UICollectionViewDelegateFlowLayout
    // 返回HeadView的宽高
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: kScreenWidth, height: kScreenWidth * 0.5)
    }
}
