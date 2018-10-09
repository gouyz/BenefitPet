//
//  BPChatMessageVC.swift
//  BenefitPet
//  患者聊天
//  Created by gouyz on 2018/8/16.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class BPChatMessageVC: GYZBaseVC {
    
    var conversation: JMSGConversation

    
    var chatViewLayout: JCChatViewLayout = .init()
    var chatView: JCChatView!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _init()
    }
    
    override func loadView() {
        super.loadView()
        let frame = CGRect(x: 0, y: kTitleAndStateHeight, width: self.view.width, height: self.view.height - kTitleAndStateHeight)
        chatView = JCChatView(frame: frame, chatViewLayout: chatViewLayout)
        chatView.delegate = self
        chatView.messageDelegate = self
        //        toolbar.translatesAutoresizingMaskIntoConstraints = false
        //        toolbar.delegate = self
        //        toolbar.text = draft
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let group = conversation.target as? JMSGGroup {
            self.navigationItem.title = group.displayName()
        }
    }
    
    deinit {
        JMessage.remove(self, with: conversation)
    }
    
    private func _init() {
        myAvator = UIImage.getMyAvator()
        _updateTitle()
        view.backgroundColor = .white
        JMessage.add(self, with: conversation)
        
        _loadMessage(messagePage)
//        let tap = UITapGestureRecognizer(target: self, action: #selector(_tapView))
//        tap.delegate = self
//        chatView.addGestureRecognizer(tap)
        view.addSubview(chatView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(_removeAllMessage), name: NSNotification.Name(rawValue: kDeleteAllMessage), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(_reloadMessage), name: NSNotification.Name(rawValue: kReloadAllMessage), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(_updateFileMessage(_:)), name: NSNotification.Name(rawValue: kUpdateFileMessage), object: nil)
    }
    
    func _updateFileMessage(_ notification: Notification) {
        let userInfo = notification.userInfo
        let msgId = userInfo?[kUpdateFileMessage] as! String
        let message = conversation.message(withMessageId: msgId)!
        let content = message.content as! JMSGFileContent
        let url = URL(fileURLWithPath: content.originMediaLocalPath ?? "")
        let data = try! Data(contentsOf: url)
        updateMediaMessage(message, data: data)
    }
    
    private func _updateTitle() {
        if let group = conversation.target as? JMSGGroup {
            title = group.displayName()
        } else {
            title = conversation.title
        }
    }
    
    
    func _reloadMessage() {
        _removeAllMessage()
        messagePage = 0
        _loadMessage(messagePage)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            self.chatView.scrollToLast(animated: false)
        }
    }
    
    func _removeAllMessage() {
        jMessageCount = 0
        messages.removeAll()
        chatView.removeAll()
    }
    fileprivate func _loadMessage(_ page: Int) {
        
        let messages = conversation.messageArrayFromNewest(withOffset: NSNumber(value: jMessageCount), limit: NSNumber(value: 17))
        if messages.count == 0 {
            return
        }
        var msgs: [JCMessage] = []
        for index in 0..<messages.count {
            let message = messages[index]
            let msg = _parseMessage(message)
            msgs.insert(msg, at: 0)
            if isNeedInsertTimeLine(message.timestamp.intValue) || index == messages.count - 1 {
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
            let timeContent = JCMessageTimeLineContent(date: Date(timeIntervalSince1970: TimeInterval(jmessage.timestamp.intValue / 1000)))
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
        if let group = conversation.target as? JMSGGroup {
            message.targetType = .group
            message.unreadCount = group.memberArray().count - 1
        } else {
            message.targetType = .single
            message.unreadCount = 1
        }
        chatView.append(message)
        messages.append(message)
        chatView.scrollToLast(animated: false)
        conversation.send(jmessage, optionalContent: JMSGOptionalContent.ex.default)
    }
    
    func send(forText text: NSAttributedString) {
        let message = JCMessage(content: JCMessageTextContent(attributedText: text))
        let content = JMSGTextContent(text: text.string)
        let msg = JMSGMessage.ex.createMessage(conversation, content, reminds)
        reminds.removeAll()
        send(message, msg)
    }
}

//MARK: - JMSGMessage Delegate
extension BPChatMessageVC: JMessageDelegate {
    
    fileprivate func updateMediaMessage(_ message: JMSGMessage, data: Data) {
        DispatchQueue.main.async {
            if let index = self.messages.index(message) {
                let msg = self.messages[index]
                switch(message.contentType) {
                case .file:
                    if message.ex.isShortVideo {
                        let videoContent = msg.content as! JCMessageVideoContent
                        videoContent.data = data
                        videoContent.delegate = self
                        msg.content = videoContent
                    } else {
                        let fileContent = msg.content as! JCMessageFileContent
                        fileContent.data = data
                        fileContent.delegate = self
                        msg.content = fileContent
                    }
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
                    m = _parseMessage(conversation.message(withMessageId: m.msgId)!, false)
                    chatView.update(m, at: index.row)
                }
            }
            return
        }
        
        messages.append(message)
        chatView.append(message)
        updateUnread([message])
        conversation.clearUnreadCount()
        if !chatView.isRoll {
            chatView.scrollToLast(animated: true)
        }
//        _updateBadge()
    }
    
    func onSendMessageResponse(_ message: JMSGMessage!, error: Error!) {
        if let error = error as NSError? {
            if error.code == 803009 {
                
                MBProgressHUD_JChat.show(text: "发送失败，消息中包含敏感词", view: view, 2.0)
            }
            if error.code == 803005 {
                MBProgressHUD_JChat.show(text: "您已不是群成员", view: view, 2.0)
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
