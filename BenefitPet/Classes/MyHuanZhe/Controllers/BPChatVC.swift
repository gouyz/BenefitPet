//
//  BPChatVC.swift
//  BenefitPet
//  既往问诊聊天
//  Created by gouyz on 2018/10/18.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD
import DKImagePickerController

class BPChatVC: GYZBaseVC {

    var conversation: JMSGConversation?
    /// 用户极光id
    var userJgId: String = ""
    
    var chatViewLayout: JCChatViewLayout = JCChatViewLayout.init()
    
    fileprivate lazy var reminds: [JCRemind] = []
    
    fileprivate var myAvator: UIImage?
    lazy var messages: [JCMessage] = []
    fileprivate let currentUser = JMSGUser.myInfo()
    fileprivate var messagePage = 0
    fileprivate var currentMessage: JCMessageType!
    fileprivate var maxTime = 0
    fileprivate var minTime = 0
    fileprivate var minIndex = 0
    fileprivate var jMessageCount = 0
    fileprivate var isFristLaunch = true
    
    var huanZheId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        conversation = JMSGConversation.singleConversation(withUsername: userJgId)
        /// 根据极光id获取患者id  yichongc、yichongd
        huanZheId = userJgId.subString(start: 8, length: userJgId.count - 8)
        if conversation == nil {
            
            JMSGConversation.createSingleConversation(withUsername: userJgId) {[weak self] (resultObject, error) in
                
                if error == nil{
                    self?.conversation = resultObject as? JMSGConversation
                    
                    self?.initData()
                }
            }
        }else{
            initData()
        }
        
        //注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(refreshView(noti:)), name: NSNotification.Name(rawValue: kSendMessageData), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initData(){
        let user = conversation?.target as? JMSGUser
        self.navigationItem.title = user?.displayName() ?? ""
        
        _init()
    }
    deinit {
        JMessage.remove(self, with: conversation)
        ///移除通知
        NotificationCenter.default.removeObserver(self)
    }
    lazy var chatView: JCChatView = {
        var y = kTitleAndStateHeight
        if #available(iOS 11.0, *) {
            y = 0
        }
        
        let chatview = JCChatView(frame: CGRect(x: 0, y: y, width: self.view.width, height: self.view.height - 160 -  y), chatViewLayout: chatViewLayout)
        chatview.delegate = self
        chatview.messageDelegate = self
        
        return chatview
    }()
    ///
    lazy var bottomView: BPChatBottomView = BPChatBottomView.init(frame: CGRect.init(x: 0, y: chatView.bottomY, width: kScreenWidth, height: 160))
    
    private func _init() {
        myAvator = UIImage.getMyAvator()
        view.backgroundColor = .white
        JMessage.add(self, with: conversation)
        
        _loadMessage(messagePage)
        goLastMessage()
        //        let tap = UITapGestureRecognizer(target: self, action: #selector(_tapView))
        //        tap.delegate = self
        //        chatView.addGestureRecognizer(tap)
        view.addSubview(chatView)
        view.addSubview(bottomView)
        
        bottomView.sendBtn.addTarget(self, action: #selector(onClickedSend), for: .touchUpInside)
        bottomView.onClickedOperatorBlock = { [weak self] (index) in
            
            self?.bottomOperator(index: index)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(_removeAllMessage), name: NSNotification.Name(rawValue: kDeleteAllMessage), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(_reloadMessage), name: NSNotification.Name(rawValue: kReloadAllMessage), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(_updateFileMessage(_:)), name: NSNotification.Name(rawValue: kUpdateFileMessage), object: nil)
    }
    /// 定位最后一条
    func goLastMessage(){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            self.chatView.scrollToLast(animated: false)
        }
    }
    /// 发送
    @objc func onClickedSend(){
        bottomView.conmentField.resignFirstResponder()
        if !(bottomView.conmentField.text?.isEmpty)! {
            send(forText: bottomView.conmentField.text!)
            bottomView.conmentField.text = ""
        }
    }
    /// 底部操作
    func bottomOperator(index: Int){
        switch index {
        case 101:// 小贴士
            goPetTips()
        case 102:// 问诊表
            goWenZhenTable()
        case 103:// 随访计划
            goFollowPlan()
        case 104:// 日程提醒
            goRiCheng()
        case 105:// 图片
            selectImg()
        default:
            break
        }
    }
    /// 小贴士
    func goPetTips(){
        let vc = BPPetTipsVC()
        vc.huanZheId = huanZheId
        navigationController?.pushViewController(vc, animated: true)
    }
    //问诊表
    func goWenZhenTable(){
        let vc = BPWenZhenTableView()
        vc.huanZheId = huanZheId
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //随访计划
    func goFollowPlan(){
        let vc = BPFollowPlanVC()
        vc.huanZheId = huanZheId
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 日程
    func goRiCheng(){
        let vc = BPRiChengVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    //图片
    func selectImg(){
        GYZAlertViewTools.alertViewTools.showSheet(title: "选择照片", message: nil, cancleTitle: "取消", titleArray: ["拍照","从相册选取"], viewController: self) { [weak self](index) in
            
            if index == 0{//拍照
                self?.openCamera()
            }else if index == 1 {//从相册选取
                self?.openPhotos()
            }
        }
    }
    
    /// 记录发送离线消息提醒
    func requestMessageRecord(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        let dJgId: String = "yichongd" + userDefaults.string(forKey: "userId")!
        
        GYZNetWork.requestNetwork("patient/offline", parameters: ["u_jg_id": userJgId,"d_jg_id": dJgId],  success: { (response) in
            
            
        }, failture: { (error) in
            GYZLog(error)
        })
    }
    
    /// 发送小贴士等消息
    /// - Parameter noti: 参数
    @objc func refreshView(noti: NSNotification) {
        
        let userInfo = noti.userInfo!
        let url: String = userInfo["url"] as! String
        
        send(forText: url)
    }
    
    @objc func _updateFileMessage(_ notification: Notification) {
        let userInfo = notification.userInfo
        let msgId = userInfo?[kUpdateFileMessage] as! String
        let message = conversation?.message(withMessageId: msgId)!
        let content = message?.content as! JMSGFileContent
        let url = URL(fileURLWithPath: content.originMediaLocalPath ?? "")
        let data = try! Data(contentsOf: url)
        updateMediaMessage(message!, data: data)
    }
    
    
    @objc func _reloadMessage() {
        _removeAllMessage()
        messagePage = 0
        _loadMessage(messagePage)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            self.chatView.scrollToLast(animated: false)
        }
    }
    
    @objc func _removeAllMessage() {
        jMessageCount = 0
        messages.removeAll()
        chatView.removeAll()
    }
    fileprivate func _loadMessage(_ page: Int) {
        
        let messages = conversation?.messageArrayFromNewest(withOffset: NSNumber(value: jMessageCount), limit: NSNumber(value: 17))
        if messages == nil || messages?.count == 0 {
            return
        }
        var msgs: [JCMessage] = []
        for index in 0..<(messages?.count)! {
            let message = messages![index]
            let msg = _parseMessage(message)
            msgs.insert(msg, at: 0)
            if isNeedInsertTimeLine(message.timestamp.intValue) || index == (messages?.count)! - 1 {
                let timeContent = JCMessageTimeLineContent(date: Date(timeIntervalSince1970: TimeInterval(message.timestamp.intValue / 1000)))
                let m = JCMessage(content: timeContent)
                m.options.showsTips = false
                msgs.insert(m, at: 0)
            }
        }
        if page != 0 {
            minIndex = minIndex + msgs.count
            chatView.insert(contentsOf: msgs, at: 0)
        } else {
            minIndex = msgs.count - 1
            chatView.append(contentsOf: msgs)
        }
        self.messages.insert(contentsOf: msgs, at: 0)
    }
    
    private func isNeedInsertTimeLine(_ time: Int) -> Bool {
        if maxTime == 0 || minTime == 0 {
            maxTime = time
            minTime = time
            return true
        }
        if (time - maxTime) >= 5 * 60000 {
            maxTime = time
            return true
        }
        if (minTime - time) >= 5 * 60000 {
            minTime = time
            return true
        }
        return false
    }
    
    // MARK: - parse message
    fileprivate func _parseMessage(_ message: JMSGMessage, _ isNewMessage: Bool = true) -> JCMessage {
        if isNewMessage {
            jMessageCount += 1
        }
        return message.parseMessage(self, { [weak self] (message, data) in
            self?.updateMediaMessage(message, data: data)
        })
    }
    
    // MARK: - send message
    func send(_ message: JCMessage, _ jmessage: JMSGMessage) {
        if isNeedInsertTimeLine(jmessage.timestamp.intValue) {
            let timeContent = JCMessageTimeLineContent(date: Date(timeIntervalSince1970: TimeInterval(jmessage.timestamp.int64Value / 1000)))
            let m = JCMessage(content: timeContent)
            m.options.showsTips = false
            messages.append(m)
            chatView.append(m)
        }
        message.msgId = jmessage.msgId
        message.name = currentUser.displayName()
        message.senderAvator = myAvator
        message.sender = currentUser
        message.options.alignment = .right
        message.options.state = .sending
        if let group = conversation?.target as? JMSGGroup {
            message.targetType = .group
            message.unreadCount = group.memberArray().count - 1
        } else {
            message.targetType = .single
            message.unreadCount = 1
        }
        chatView.append(message)
        messages.append(message)
        chatView.scrollToLast(animated: false)
        conversation?.send(jmessage, optionalContent: JMSGOptionalContent.ex.default)
        
        requestMessageRecord()
    }
    
    func send(forText text: String) {
        let message = JCMessage(content: JCMessageTextContent.init(text: text))
        let content = JMSGTextContent(text: text)
        let msg = JMSGMessage.ex.createMessage(conversation!, content, reminds)
        reminds.removeAll()
        send(message, msg)
    }
    func send(forImage image: UIImage) {
        let data = UIImageJPEGRepresentation(image, 1.0)!
        let content = JMSGImageContent(imageData: data)
        
        let message = JMSGMessage.ex.createMessage(conversation!, content!, nil)
        let imageContent = JCMessageImageContent()
        imageContent.delegate = self
        imageContent.image = image
        content?.uploadHandler = {  (percent:Float, msgId:(String?)) -> Void in
            imageContent.upload?(percent)
        }
        let msg = JCMessage(content: imageContent)
        send(msg, message)
    }
}

//MARK: - JMSGMessage Delegate
extension BPChatVC: JMessageDelegate {
    
    fileprivate func updateMediaMessage(_ message: JMSGMessage, data: Data) {
        DispatchQueue.main.async {
            if let index = self.messages.index( message) {
                let msg = self.messages[index]
                switch(message.contentType) {
                case .file:
                    break
                case .image:
                    let imageContent = msg.content as! JCMessageImageContent
                    let image = UIImage(data: data)
                    imageContent.image = image
                    msg.content = imageContent
                default: break
                }
                msg.updateSizeIfNeeded = true
                self.chatView.update(msg, at: index)
                msg.updateSizeIfNeeded = false
                //                self.chatView.update(msg, at: index)
            }
        }
    }
    
    //    func _updateBadge() {
    //        JMSGConversation.allConversations { (result, error) in
    //            guard let conversations = result as? [JMSGConversation] else {
    //                return
    //            }
    //            let count = conversations.unreadCount
    //            if count == 0 {
    //                self.leftButton.setTitle("会话", for: .normal)
    //            } else {
    //                self.leftButton.setTitle("会话(\(count))", for: .normal)
    //            }
    //        }
    //    }
    
    func onReceive(_ message: JMSGMessage!, error: Error!) {
        if error != nil {
            return
        }
        let message = _parseMessage(message)
        // TODO: 这个判断是sdk bug导致的，暂时只能这么改
        if messages.contains(where: { (m) -> Bool in
            return m.msgId == message.msgId
        }) {
            let indexs = chatView.indexPathsForVisibleItems
            for index in indexs {
                var m = messages[index.row]
                if !m.msgId.isEmpty {
                    m = _parseMessage((conversation?.message(withMessageId: m.msgId)!)!, false)
                    chatView.update(m, at: index.row)
                }
            }
            return
        }
        
        messages.append(message)
        chatView.append(message)
        updateUnread([message])
        conversation?.clearUnreadCount()
        if !chatView.isRoll {
            chatView.scrollToLast(animated: true)
        }
        //        _updateBadge()
    }
    
    func onSendMessageResponse(_ message: JMSGMessage!, error: Error!) {
        if let error = error as NSError? {
            if error.code == 803009 {
                
                MBProgressHUD.showAutoDismissHUD(message: "发送失败，消息中包含敏感词")
            }
            if error.code == 803005 {
                MBProgressHUD.showAutoDismissHUD(message: "您已不是群成员")
            }
        }
        if let index = messages.index(message) {
            let msg = messages[index]
            msg.options.state = message.ex.state
            chatView.update(msg, at: index)
        }
    }
    
    func onReceive(_ retractEvent: JMSGMessageRetractEvent!) {
        if let index = messages.index(retractEvent.retractMessage) {
            let msg = _parseMessage(retractEvent.retractMessage, false)
            messages[index] = msg
            chatView.update(msg, at: index)
        }
    }
    
    func onSyncOfflineMessageConversation(_ conversation: JMSGConversation!, offlineMessages: [JMSGMessage]!) {
        let msgs = offlineMessages.sorted(by: { (m1, m2) -> Bool in
            return m1.timestamp.intValue < m2.timestamp.intValue
        })
        for item in msgs {
            let message = _parseMessage(item)
            messages.append(message)
            chatView.append(message)
            updateUnread([message])
            conversation.clearUnreadCount()
            if !chatView.isRoll {
                chatView.scrollToLast(animated: true)
            }
        }
        //        _updateBadge()
    }
    
    func onReceive(_ receiptEvent: JMSGMessageReceiptStatusChangeEvent!) {
        for message in receiptEvent.messages! {
            if let index = messages.index(message) {
                let msg = messages[index]
                msg.unreadCount = message.getUnreadCount()
                chatView.update(msg, at: index)
            }
        }
    }
}

// MARK: - JCMessageDelegate
extension BPChatVC: JCMessageDelegate {
    
    func message(message: JCMessageType, videoData data: Data?) {
        //        if let data = data {
        //            JCVideoManager.playVideo(data: data, currentViewController: self)
        //        }
    }
    
    func message(message: JCMessageType, location address: String?, lat: Double, lon: Double) {
        //        let vc = JCAddMapViewController()
        //        vc.isOnlyShowMap = true
        //        vc.lat = lat
        //        vc.lon = lon
        //        navigationController?.pushViewController(vc, animated: true)
    }
    
    func message(message: JCMessageType, image: UIImage?) {
        let browser = SKPhotoBrowser(photos: GYZTool.createWebPhotosWithImgs(imgs: [image!]))
        browser.initializePageIndex(0)
        
        self.present(browser, animated: true, completion: nil)
    }
    
    func message(message: JCMessageType, fileData data: Data?, fileName: String?, fileType: String?) {
        
    }
    
    func message(message: JCMessageType, user: JMSGUser?, businessCardName: String, businessCardAppKey: String) {
        //        if let user = user {
        //            let vc = JCUserInfoViewController()
        //            vc.user = user
        //            navigationController?.pushViewController(vc, animated: true)
        //        }
    }
    
    func clickTips(message: JCMessageType) {
        currentMessage = message
        //        let alertView = UIAlertView(title: "重新发送", message: "是否重新发送该消息？", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "发送")
        //        alertView.show()
    }
    
    func tapAvatarView(message: JCMessageType) {
        //        toolbar.resignFirstResponder()
        //        if message.options.alignment == .right {
        //            navigationController?.pushViewController(JCMyInfoViewController(), animated: true)
        //        } else {
        //            let vc = JCUserInfoViewController()
        //            vc.user = message.sender
        //            navigationController?.pushViewController(vc, animated: true)
        //        }
    }
    
    func longTapAvatarView(message: JCMessageType) {
        //        if !isGroup || message.options.alignment == .right {
        //            return
        //        }
        //        toolbar.becomeFirstResponder()
        //        if let user = message.sender {
        //            toolbar.text.append("@")
        //            handleAt(toolbar, NSMakeRange(toolbar.text.length - 1, 0), user, false, user.displayName().length)
        //        }
    }
    
    func tapUnreadTips(message: JCMessageType) {
        //        let vc = UnreadListViewController()
        //        let msg = conversation.message(withMessageId: message.msgId)
        //        vc.message = msg
        //        navigationController?.pushViewController(vc, animated: true)
    }
}

extension BPChatVC: JCChatViewDelegate {
    func refershChatView( chatView: JCChatView) {
        messagePage += 1
        _loadMessage(messagePage)
        chatView.stopRefresh()
    }
    
    func deleteMessage(message: JCMessageType) {
        conversation?.deleteMessage(withMessageId: message.msgId)
        if let index = messages.index(message) {
            jMessageCount -= 1
            messages.remove(at: index)
            if let message = messages.last {
                if message.content is JCMessageTimeLineContent {
                    messages.removeLast()
                    chatView.remove(at: messages.count)
                }
            }
        }
    }
    
    func forwardMessage(message: JCMessageType) {
        //        if let message = conversation.message(withMessageId: message.msgId) {
        //            let vc = JCForwardViewController()
        //            vc.message = message
        //            let nav = JCNavigationController(rootViewController: vc)
        //            self.present(nav, animated: true, completion: {
        //                self.toolbar.isHidden = true
        //            })
        //        }
    }
    
    func withdrawMessage(message: JCMessageType) {
        guard let message = conversation?.message(withMessageId: message.msgId) else {
            return
        }
        JMSGMessage.retractMessage(message, completionHandler: { (result, error) in
            if error == nil {
                if let index = self.messages.index(message) {
                    let msg = self._parseMessage((self.conversation?.message(withMessageId: message.msgId)!)!, false)
                    self.messages[index] = msg
                    self.chatView.update(msg, at: index)
                }
            } else {
                MBProgressHUD.showAutoDismissHUD(message: "发送时间过长，不能撤回")
            }
        })
    }
    
    func indexPathsForVisibleItems(chatView: JCChatView, items: [IndexPath]) {
        for item in items {
            if item.row <= minIndex {
                var msgs: [JCMessage] = []
                for index in item.row...minIndex  {
                    msgs.append(messages[index])
                }
                updateUnread(msgs)
                minIndex = item.row
            }
        }
    }
    
    fileprivate func updateUnread(_ messages: [JCMessage]) {
        for message in messages {
            if message.options.alignment != .left {
                continue
            }
            if let msg = conversation?.message(withMessageId: message.msgId) {
                if msg.isHaveRead {
                    continue
                }
                msg.setMessageHaveRead({ _,_  in
                    
                })
            }
        }
    }
}

extension BPChatVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        guard let image = info[picker.allowsEditing ? UIImagePickerControllerEditedImage : UIImagePickerControllerOriginalImage] as? UIImage else { return }
        picker.dismiss(animated: true) { [weak self] in
            
            self?.send(forImage: image)
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    ///打开相机
    func openCamera(){
        
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            MBProgressHUD.showAutoDismissHUD(message: "该设备无摄像头")
            return
        }
        
        GYZOpenCameraPhotosTool.shareTool.checkCameraPermission { (granted) in
            if granted{
                let photo = UIImagePickerController()
                photo.delegate = self
                photo.sourceType = .camera
                photo.allowsEditing = true
                self.present(photo, animated: true, completion: nil)
            }else{
                GYZOpenCameraPhotosTool.shareTool.showPermissionAlert(content: "请在iPhone的“设置-隐私”选项中，允许访问你的摄像头",controller : self)
            }
        }
        
    }
    
    ///打开相册
    func openPhotos(){
        
        let pickerController = DKImagePickerController()
        
        weak var weakSelf = self
        
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            
            for item in assets {
                item.fetchFullScreenImageWithCompleteBlock({ (image, info) in
                    
                    weakSelf?.send(forImage: image!)
                    
                })
            }
        }
        
        self.present(pickerController, animated: true) {}
    }
}

