//
//  BPEditGroupVC.swift
//  BenefitPet
//  添加新分组/编辑
//  Created by gouyz on 2018/8/7.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

private let editGroupNameCell = "editGroupNameCell"
private let editGroupImgCell = "editGroupImgCell"
private let editGroupHeader = "editGroupHeader"

class BPEditGroupVC: GYZBaseVC {
    
    ///是否是编辑
    var isEdit: Bool = false
    ///是否是删除
    var isDelete: Bool = false
    /// 头像宽度
    let imgWidth = (kScreenWidth - 5 * kMargin) * 0.25

    override func viewDidLoad() {
        super.viewDidLoad()

        let rightBtn = UIButton(frame: CGRect.init(x: 0, y: 0, width: 60, height: kTitleHeight))
        rightBtn.setTitle("保存", for: .normal)
        rightBtn.setTitleColor(kBlackFontColor, for: .normal)
        rightBtn.titleLabel?.font = k14Font
        rightBtn.addTarget(self, action: #selector(onClickedSaveBtn), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
        
        view.addSubview(deleteBtn)
        view.addSubview(collectionView)
        deleteBtn.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            if isEdit{
                make.height.equalTo(kBottomTabbarHeight)
            }else{
                make.height.equalTo(0)
            }
        }
        collectionView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.bottom.equalTo(deleteBtn.snp.top)
            if #available(iOS 11.0, *) {
                make.top.equalTo(view)
            }else{
                make.top.equalTo(kTitleAndStateHeight)
            }
        }
        
        if isEdit {
            self.navigationItem.title = "编辑分组"
            deleteBtn.isHidden = false
        }else{
            self.navigationItem.title = "添加新分组"
            deleteBtn.isHidden = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        //每个Item之间最小的间距
        layout.minimumInteritemSpacing = kMargin
        //每行之间最小的间距
        layout.minimumLineSpacing = kMargin
        
        layout.headerReferenceSize = CGSize.init(width: kScreenWidth, height: kTitleHeight)
        
        let collView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collView.dataSource = self
        collView.delegate = self
        collView.backgroundColor = kWhiteColor
        
        collView.register(BPGroupNameCell.self, forCellWithReuseIdentifier: editGroupNameCell)
        collView.register(BPGroupImgCell.self, forCellWithReuseIdentifier: editGroupImgCell)
        
        collView.register(BPEditGroupHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: editGroupHeader)
        
        return collView
    }()
    
    /// 删除分组
    lazy var deleteBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBtnClickBGColor
        btn.titleLabel?.font = k15Font
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.setTitle("删除分组", for: .normal)
        btn.addTarget(self, action: #selector(clickedUpLoadBtn), for: .touchUpInside)
        
        return btn
    }()
    
    /// 上传照片
    @objc func clickedUpLoadBtn(){
    }
    
    /// 保存
    @objc func onClickedSaveBtn(){
        
    }
    
    /// 删除成员
    @objc func onClickedDeleteUser(sender: UITapGestureRecognizer){
        
    }
    /// 选择患者
    func goSelectHuanZhe(){
        let vc = BPSelectHuanZheVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension BPEditGroupVC : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    // MARK: UICollectionViewDataSource 代理方法
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 1{
            if isEdit {
                return 5
            }
            return 1
        }
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: editGroupNameCell, for: indexPath) as! BPGroupNameCell
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: editGroupImgCell, for: indexPath) as! BPGroupImgCell
            
            if isEdit{
                if indexPath.row == 4{
                    cell.userImgView.image = UIImage.init(named: "icon_group_minus")
                    cell.deleteImgView.isHidden = true
                }else if indexPath.row == 3{
                    cell.userImgView.image = UIImage.init(named: "icon_group_add")
                    cell.deleteImgView.isHidden = true
                }else{
                    cell.userImgView.image = UIImage.init(named: "icon_header_default")
                    cell.deleteImgView.isHidden = !isDelete
                }
            }else{
                cell.userImgView.image = UIImage.init(named: "icon_group_add")
                cell.deleteImgView.isHidden = true
            }
            
            cell.deleteImgView.addOnClickListener(target: self, action: #selector(onClickedDeleteUser(sender:)))
            cell.deleteImgView.tag = indexPath.row
            
            return cell
        }
        
        
    }
    
    // 返回自定义HeadView或者FootView
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var reusableview: UICollectionReusableView!
        
        if kind == UICollectionElementKindSectionHeader {
            
            reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: editGroupHeader, for: indexPath) as! BPEditGroupHeaderView
            
            if indexPath.section == 0{
                (reusableview as! BPEditGroupHeaderView).nameLab.text = "分组名称"
            }else{
                (reusableview as! BPEditGroupHeaderView).nameLab.text = "分组成员"
            }
        }
        
        return reusableview
    }
    // MARK: UICollectionViewDelegate的代理方法
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            if isEdit{
                if indexPath.row == 4{//减号
                    isDelete = true
                    collectionView.reloadData()
                }else if indexPath.row == 3{//加号
                    goSelectHuanZhe()
                }
            }else{
                if indexPath.row == 0{//加号
                    goSelectHuanZhe()
                }
            }
        }
        
    }
    // MARK: UICollectionViewDelegateFlowLayout的代理方法
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize.init(width: kScreenWidth, height: 50)
        }
        
        return CGSize.init(width: imgWidth, height: imgWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        return UIEdgeInsets.init(top: kMargin, left: kMargin, bottom: kMargin, right: kMargin)
    }
}
