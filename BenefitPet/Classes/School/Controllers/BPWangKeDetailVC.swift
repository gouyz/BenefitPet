//
//  BPWangKeDetailVC.swift
//  BenefitPet
//  网课详情
//  Created by gouyz on 2018/11/2.
//  Copyright © 2018 gyz. All rights reserved.
//

import UIKit
import BMPlayer
import NVActivityIndicatorView
import AVFoundation
import MBProgressHUD


private let zhuanJiaWangKeDetailCell = "zhuanJiaWangKeDetailCell"

class BPWangKeDetailVC: GYZBaseVC {
    
    var detailModel: BPWangKeDetailModel?
    var articleId: String = ""
    /// 当前播放的时间
    var currentTime: TimeInterval = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = kWhiteColor

        view.addSubview(player)
        player.snp.makeConstraints { (make) in
            make.top.equalTo(kMargin)
            make.left.right.equalTo(view)
            // 注意此处，宽高比 16:9 优先级比 1000 低就行，在因为 iPhone 4S 宽高比不是 16：9
            make.height.equalTo(view.snp.width).multipliedBy(9.0/16.0).priority(500)
        }
        view.addSubview(bgView)
        bgView.addSubview(aboutLab)
        bgView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(player.snp.bottom)
            make.height.equalTo(kTitleHeight)
        }
        aboutLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.bottom.equalTo(bgView)
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(bgView.snp.bottom)
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.bottom.equalTo(view)
        }
        requestDatas()
        
        resetPlayerManager()
        player.delegate = self
        player.backBlock = { [unowned self] (isFullScreen) in
            if isFullScreen {
                return
            } else {
                let _ = self.navigationController?.popViewController(animated: true)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        // 使用手势返回的时候，调用下面方法手动销毁
        player.prepareToDealloc()
    }
    
    /// 播放器
    lazy var player: BMPlayer = BMPlayer(customControlView: BMPlayerControlView())
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        
        return view
    }()
    lazy var aboutLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlueFontColor
        lab.text = "相关视频"
        
        return lab
    }()
    
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
        
        collView.register(BPStudyVideoChildCell.self, forCellWithReuseIdentifier: zhuanJiaWangKeDetailCell)
        
        return collView
    }()
    
    
    ///获取网课数据
    func requestDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("school/school_study_wangke_content", parameters: ["id": articleId],  success: { (response) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(response)
            
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["data"].dictionaryObject else { return }
                weakSelf?.detailModel = BPWangKeDetailModel.init(dict: data)
                
                weakSelf?.setVideo()
                weakSelf?.collectionView.reloadData()
                
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
    
    /// 播放器自定义属性 创建播放器前设定
    func resetPlayerManager() {
        // 是否打印日志，默认false
        BMPlayerConf.allowLog = false
        // 是否自动播放，默认true
        BMPlayerConf.shouldAutoPlay = false
        // 主体颜色，默认白色
        BMPlayerConf.tintColor = kWhiteColor
        // 顶部返回和标题显示选项，默认.Always，可选.HorizantalOnly、.None
        BMPlayerConf.topBarShowInCase = .horizantalOnly
        // 加载效果，更多请见：https://github.com/ninjaprox/NVActivityIndicatorView
        BMPlayerConf.loaderType  = NVActivityIndicatorType.lineSpinFadeLoader
    }
    
    func setVideo(){
        if detailModel != nil {
            
            let model = detailModel?.detailModel
            self.navigationItem.title = model?.title
            
            let asset = BMPlayerResource(url: URL(string: (model?.video)!)!, name: (model?.title)!, cover:URL.init(string: (model?.pic)!))
            player.setVideo(resource: asset)
        }
        
    }
}

extension BPWangKeDetailVC : UICollectionViewDataSource,UICollectionViewDelegate{
    // MARK: UICollectionViewDataSource 代理方法
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if detailModel == nil {
            return 0
        }
        return (detailModel?.wangkeList.count)!
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: zhuanJiaWangKeDetailCell, for: indexPath) as! BPStudyVideoChildCell
        
        cell.dataModel = detailModel?.wangkeList[indexPath.row]
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate的代理方法
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
}

extension BPWangKeDetailVC: BMPlayerDelegate {
    
    func bmPlayer(player: BMPlayer, playerStateDidChange state: BMPlayerState) {
        
    }
    
    func bmPlayer(player: BMPlayer, loadedTimeDidChange loadedDuration: TimeInterval, totalDuration: TimeInterval) {
        
    }
    
    func bmPlayer(player: BMPlayer, playTimeDidChange currentTime: TimeInterval, totalTime: TimeInterval) {
        self.currentTime = currentTime
    }
    
    func bmPlayer(player: BMPlayer, playerIsPlaying playing: Bool) {
        
    }
    
    func bmPlayer(player: BMPlayer, playerOrientChanged isFullscreen: Bool) {
        self.player.snp.remakeConstraints { (make) in
            make.top.left.right.equalTo(view)
            if isFullscreen {
                make.bottom.equalTo(view)
            } else {
                make.height.equalTo(view.snp.width).multipliedBy(9.0/16.0).priority(500)
            }
        }
    }
    
}

