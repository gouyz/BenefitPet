//
//  BPEditGroupVC.swift
//  BenefitPet
//  添加新分组/编辑
//  Created by gouyz on 2018/8/7.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let editGroupNameCell = "editGroupNameCell"
private let editGroupImgCell = "editGroupImgCell"
private let editGroupHeader = "editGroupHeader"

class BPEditGroupVC: GYZBaseVC {
    
    /// 选择结果回调
    var resultBlock:(() -> Void)?
    
    ///是否是编辑
    var isEdit: Bool = false
    ///是否是删除
    var isDelete: Bool = false
    /// 头像宽度
    let imgWidth = (kScreenWidth - 5 * kMargin) * 0.25
    /// 选择患者
    var selectHuanZhes: [String : BPHuanZheModel] = [String : BPHuanZheModel]()
    /// 编辑时成员数据
    var dataList: [BPHuanZheModel] = [BPHuanZheModel]()
    /// 分组id
    var groupId: String = ""
    /// 分组名称
    var groupName: String = ""

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
            requestGroupMembersDatas()
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
    
    ///获取分组成员数据
    func requestGroupMembersDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("patient/show_user",parameters: ["id": groupId],  success: { (response) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(response)
            
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["data"].array else { return }
                
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = BPHuanZheModel.init(dict: itemInfo)
                    
                    weakSelf?.dataList.append(model)
                    weakSelf?.selectHuanZhes[model.id!] = model
                }
                weakSelf?.collectionView.reloadData()
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(error)
            
        })
    }
    
    /// 删除分组
    @objc func clickedUpLoadBtn(){
        
        weak var weakSelf = self
        GYZAlertViewTools.alertViewTools.showAlert(title: "提示", message: "确定要删除分组：\(groupName) 吗？", cancleTitle: "取消", viewController: self, buttonTitles: "确定") { (index) in
            
            if index != cancelIndex{
                weakSelf?.requestDeleteGroup()
            }
        }
    }
    
    /// 保存
    @objc func onClickedSaveBtn(){
        
        if groupName.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入分组名称")
            return
        }
//        if selectHuanZhes.count == 0 {
//            MBProgressHUD.showAutoDismissHUD(message: "请选择患者")
//            return
//        }
        
        var ids: String = ""
        if selectHuanZhes.count > 0 {
            for key in selectHuanZhes.keys {
                ids +=  key + ","
            }
            ids = ids.subString(start: 0, length: ids.count - 1)
        }
        
        if isEdit {
            requestModifyGroup(ids: ids)
        }else{
            requestAddGroup(ids: ids)
        }
        
    }
    
    /// 保存分组
    func requestModifyGroup(ids: String){
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("patient/save_group", parameters: ["d_id":userDefaults.string(forKey: "userId") ?? "","group_id":groupId,"name": groupName,"patient": ids],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                weakSelf?.dealBack()
                
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    /// 新增分组
    func requestAddGroup(ids: String){
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("patient/add_group", parameters: ["d_id":userDefaults.string(forKey: "userId") ?? "","name": groupName,"patient": ids],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                weakSelf?.dealBack()
                
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    /// 删除分组
    func requestDeleteGroup(){
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("patient/del_group", parameters: ["group_id":groupId],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                weakSelf?.dealBack()
                
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    /// 修改成功后处理回调
    func dealBack(){
        if resultBlock != nil{
            resultBlock!()
        }
        clickedBackBtn()
    }
    
    /// 删除成员
    @objc func onClickedDeleteUser(sender: UITapGestureRecognizer){
        let tag : Int = (sender.view?.tag)!
        let personId: String = dataList[tag].id!
        selectHuanZhes.removeValue(forKey: personId)
        dataList.remove(at: tag)
        collectionView.reloadData()
    }
    /// 选择患者
    func goSelectHuanZhe(){
        let vc = BPSelectHuanZheVC()
        if selectHuanZhes.count > 0 {// 多次选择
            vc.selectHuanZhes = selectHuanZhes
        }
        vc.selectBlock = { [weak self] (models) in
            self?.dataList.removeAll()
            self?.selectHuanZhes = models
            for item in models.values {
                self?.dataList.append(item)
            }
            
            self?.collectionView.reloadData()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 输入框内容改变
    @objc func textFieldTextChange(textField: UITextField){
        groupName = textField.text!
    }
}

extension BPEditGroupVC : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    // MARK: UICollectionViewDataSource 代理方法
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 1{
//            if isEdit {
//                return dataList.count + 2
//            }
//            return 1
            return selectHuanZhes.count > 0 ? selectHuanZhes.count + 2 : 1
        }
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: editGroupNameCell, for: indexPath) as! BPGroupNameCell
            
            cell.nameTxtFiled.text = groupName
            cell.nameTxtFiled.addTarget(self, action: #selector(textFieldTextChange(textField:)), for: .editingChanged)
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: editGroupImgCell, for: indexPath) as! BPGroupImgCell
            
            if selectHuanZhes.count > 0{
                
                if indexPath.row == selectHuanZhes.count + 1{// 减
                    cell.userImgView.image = UIImage.init(named: "icon_group_minus")
                    cell.deleteImgView.isHidden = true
                }else if indexPath.row == selectHuanZhes.count{// 加
                    cell.userImgView.image = UIImage.init(named: "icon_group_add")
                    cell.deleteImgView.isHidden = true
                }else{
                    let model = dataList[indexPath.row]
                    cell.userImgView.kf.setImage(with: URL.init(string: (model.head)!), placeholder: UIImage.init(named: "icon_header_default"), options: nil, progressBlock: nil, completionHandler: nil)
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
            
            if selectHuanZhes.count > 0{
                if indexPath.row == selectHuanZhes.count + 1{// 减
                    isDelete = true
                    collectionView.reloadData()
                }else if indexPath.row == selectHuanZhes.count{// 加
                    goSelectHuanZhe()
                }
            }else{
                goSelectHuanZhe()
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
