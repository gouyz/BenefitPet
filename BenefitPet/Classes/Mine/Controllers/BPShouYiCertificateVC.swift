//
//  BPShouYiCertificateVC.swift
//  BenefitPet
//  职业兽医资格认证
//  Created by gouyz on 2018/8/10.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class BPShouYiCertificateVC: GYZBaseVC {
    
    /// 选择结果回调
    var resultBlock:(() -> Void)?

    /// 选择图片
    var selectImg: UIImage?
    /// 
    var imgUrl: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "职业兽医资格认证"
        self.view.backgroundColor = kWhiteColor
        
        let rightBtn = UIButton(type: .custom)
        rightBtn.setTitle("保存", for: .normal)
        rightBtn.titleLabel?.font = k13Font
        rightBtn.setTitleColor(kBlackFontColor, for: .normal)
        rightBtn.frame = CGRect.init(x: 0, y: 0, width: kTitleHeight, height: kTitleHeight)
        rightBtn.addTarget(self, action: #selector(onClickRightBtn), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        
        setUpUI()
        
        iconView.addOnClickListener(target: self, action: #selector(onClickedAddImg))
        
        iconView.kf.setImage(with: URL.init(string: imgUrl), placeholder: UIImage.init(named: "icon_add_backgroud_gray"), options: nil, progressBlock: nil, completionHandler: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpUI(){
        
        view.addSubview(desLab)
        view.addSubview(iconView)
        
        desLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(kTitleAndStateHeight + kMargin)
            make.height.equalTo(kTitleHeight)
        }
        
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.top.equalTo(desLab.snp.bottom).offset(20)
            make.height.equalTo((kScreenWidth - 60) * 0.62)
        }
    }
    
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.font = k18Font
        lab.textColor = kHeightGaryFontColor
        lab.textAlignment = .center
        lab.text = "请上传您的凭证"
        
        return lab
    }()
    /// 图片
    lazy var iconView: UIImageView = UIImageView()
    /// 保存
    @objc func onClickRightBtn(){
        if selectImg == nil {
            MBProgressHUD.showAutoDismissHUD(message: "请选择图片")
            return
        }
        requestUpdateImg()
    }
    
    /// 添加图片
    @objc func onClickedAddImg(){
        
        GYZOpenCameraPhotosTool.shareTool.choosePicture(self, editor: false, finished: { [weak self] (image) in
            
            self?.selectImg = image
            self?.iconView.image = image
        })
    }
    
    /// 上传职业兽医资格认证
    func requestUpdateImg(){
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        let imgParam: ImageFileUploadParam = ImageFileUploadParam()
        imgParam.name = "zige"
        imgParam.fileName = "zige.jpg"
        imgParam.mimeType = "image/jpg"
        imgParam.data = UIImageJPEGRepresentation(selectImg!, 0.5)
        
        GYZNetWork.uploadImageRequest("doctor/file_zige", parameters: ["id":userDefaults.string(forKey: "userId") ?? ""], uploadParam: [imgParam], success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                if weakSelf?.resultBlock != nil{
                    weakSelf?.resultBlock!()
                }
                weakSelf?.clickedBackBtn()
                
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
}
