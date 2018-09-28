//
//  BPWorkingAdsHeaderView.swift
//  BenefitPet
//  工作站 头部
//  Created by gouyz on 2018/7/30.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import Cosmos

class BPWorkingAdsHeaderView: UIView {
    
    /// 闭包回调
    public var callBack: ((_ tag: Int) ->())?
    
    // MARK: 生命周期方法
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        self.addSubview(adsImgView)
        self.addSubview(nameLab)
        self.addSubview(ratingView)
        self.addSubview(numberLab)
        self.addSubview(headerImgView)
        self.addSubview(userNameLab)
        
        self.addSubview(onLineBtn)
        self.addSubview(yuyueBtn)
        self.addSubview(huShiBtn)
        
        adsImgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(self)
            make.height.equalTo((kScreenWidth - kMargin * 2) * 0.4)
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(adsImgView)
            make.right.equalTo(headerImgView.snp.left).offset(-kMargin)
            make.top.equalTo(adsImgView.snp.bottom).offset(kMargin)
            make.height.equalTo(30)
        }
        ratingView.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab)
            make.top.equalTo(nameLab.snp.bottom)
            make.height.equalTo(20)
            make.width.equalTo(100)
        }
        numberLab.snp.makeConstraints { (make) in
            make.left.height.equalTo(nameLab)
            make.top.equalTo(ratingView.snp.bottom)
            make.width.equalTo(kScreenWidth * 0.5)
        }
        
        headerImgView.snp.makeConstraints { (make) in
            make.centerX.equalTo(userNameLab)
            make.top.equalTo(nameLab)
            make.size.equalTo(CGSize.init(width: kTitleHeight, height: kTitleHeight))
        }
        userNameLab.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.top.equalTo(headerImgView.snp.bottom)
            make.height.equalTo(nameLab)
            make.width.equalTo(80)
        }
        
        onLineBtn.snp.makeConstraints { (make) in
            make.left.equalTo(adsImgView)
            make.top.equalTo(numberLab.snp.bottom).offset(20)
            make.size.equalTo(CGSize.init(width: 80, height: 30))
        }
        yuyueBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.size.equalTo(onLineBtn)
        }
        
        huShiBtn.snp.makeConstraints { (make) in
            make.right.equalTo(adsImgView)
            make.top.size.equalTo(onLineBtn)
        }
    }
    
    /// 广告轮播图
    lazy var adsImgView: ZCycleView = {
        let adsView = ZCycleView()

        adsView.placeholderImage = UIImage.init(named: "icon_working_ads")
        adsView.setImagesGroup([#imageLiteral(resourceName: "icon_working_ads"),#imageLiteral(resourceName: "icon_working_ads"),#imageLiteral(resourceName: "icon_working_ads")])
        adsView.pageControlAlignment = .center
        adsView.pageControlIndictirColor = kWhiteColor
        adsView.pageControlCurrentIndictirColor = kBlueFontColor
        adsView.scrollDirection = .horizontal
        
        adsView.cornerRadius = kCornerRadius
        
        return adsView
    }()
    
    /// 医院名称
    lazy var nameLab : UILabel = {
        
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        
        return lab
    }()
    ///星星评分
    lazy var ratingView: CosmosView = {
        
        let ratingStart = CosmosView()
        ratingStart.settings.updateOnTouch = false
        ratingStart.settings.fillMode = .precise
        ratingStart.settings.filledColor = kYellowFontColor
        ratingStart.settings.emptyBorderColor = kYellowFontColor
        ratingStart.settings.filledBorderColor = kYellowFontColor
        ratingStart.settings.starMargin = 3
        ratingStart.rating = 5
        
        return ratingStart
        
    }()
    
    /// 人数
    lazy var numberLab : UILabel = {
        
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        
        return lab
    }()
    
    /// 图片
    lazy var headerImgView : UIImageView = {
        let imgView = UIImageView()
        imgView.cornerRadius = 22
        
        return imgView
    }()
    /// 姓名
    lazy var userNameLab : UILabel = {
        
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.textAlignment = .center
        lab.text = "玛丽"
        
        return lab
    }()
    
    /// 在线接单
    lazy var onLineBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBtnClickBGColor
        btn.titleLabel?.font = k13Font
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.cornerRadius = kCornerRadius
        btn.setTitle("在线接单", for: .normal)
        btn.tag = 101
        btn.addTarget(self, action: #selector(clickedOperateBtn(btn:)), for: .touchUpInside)
        return btn
    }()
    /// 预约信息
    lazy var yuyueBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBtnClickBGColor
        btn.titleLabel?.font = k13Font
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.cornerRadius = kCornerRadius
        btn.setTitle("预约信息", for: .normal)
        btn.tag = 102
        btn.addTarget(self, action: #selector(clickedOperateBtn(btn:)), for: .touchUpInside)
        return btn
    }()
    /// 智能小护士
    lazy var huShiBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBtnClickBGColor
        btn.titleLabel?.font = k13Font
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.cornerRadius = kCornerRadius
        btn.setTitle("智能小护士", for: .normal)
        btn.tag = 103
        btn.addTarget(self, action: #selector(clickedOperateBtn(btn:)), for: .touchUpInside)
        return btn
    }()
    
    ///操作
    @objc func clickedOperateBtn(btn : UIButton){
        let tag = btn.tag - 100
        
        if callBack != nil {
            callBack!(tag)
        }
    }
}
