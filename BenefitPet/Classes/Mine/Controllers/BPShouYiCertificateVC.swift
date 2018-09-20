//
//  BPShouYiCertificateVC.swift
//  BenefitPet
//  职业兽医资格认证
//  Created by gouyz on 2018/8/10.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class BPShouYiCertificateVC: GYZBaseVC {
    
    /// 选择图片
    var selectImg: UIImage?

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
    lazy var iconView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_add_backgroud_gray"))
    /// 保存
    @objc func onClickRightBtn(){
        
    }
    
    /// 添加图片
    @objc func onClickedAddImg(){
        
        if selectImg != nil {
            return
        }
        GYZOpenCameraPhotosTool.shareTool.choosePicture(self, editor: false, finished: { [weak self] (image) in
            
            self?.selectImg = image
            self?.iconView.image = image
//            self?.requestUpdateHeaderImg()
        })
    }
}
