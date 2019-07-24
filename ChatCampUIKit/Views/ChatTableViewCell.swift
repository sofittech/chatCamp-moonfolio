//
//  ChatTableViewCell.swift
//  ChatCamp Demo
//
//  Created by Tanmay Khandelwal on 10/02/18.
//  Copyright © 2018 iFlyLabs Inc. All rights reserved.
//

import UIKit

open class ChatTableViewCell: UITableViewCell {
    @IBOutlet weak open var avatarImageView: UIImageView! {
        didSet {
            avatarImageView.layer.cornerRadius = 25
            avatarImageView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak open var nameLabel: UILabel!
    @IBOutlet weak open var messageLabel: UILabel!
    @IBOutlet weak open var accessoryLabel: UILabel!
    var onlineView:UIView!
    @IBOutlet weak open var unreadCountLabel: UILabel! {
        didSet {
            unreadCountLabel.layer.cornerRadius = unreadCountLabel.frame.width / 2
            unreadCountLabel.layer.masksToBounds = true
        }
    }
    @IBOutlet weak open var lastMessageLabel: UILabel! {
        didSet {
            lastMessageLabel.text = ""
        }
    }
    
    var user: ParticipantViewModelItem? {
        didSet {
            nameLabel?.text = user?.displayName
            if let avatarUrl = user?.avatarURL {
                avatarImageView?.sd_setImage(with: URL(string: avatarUrl), completed: nil)
            } else {
                avatarImageView.setImageForName(string: user?.displayName ?? "?", circular: true, textAttributes: nil)
            }
        }
    }
    
    override open func prepareForReuse() {
        super.prepareForReuse()
        
        avatarImageView.image = UIImage(named: "user_placeholder", in: Bundle(for: ChatTableViewCell.self), compatibleWith: nil)
        nameLabel.text = ""
        messageLabel.text = ""
        lastMessageLabel.text = ""
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        self.onlineView = UIView()
        self.onlineView.frame = CGRect(x:self.contentView.frame.maxX - 40, y: self.contentView.frame.midY, width: 10, height: 10)
                        onlineView.backgroundColor = .green
                        onlineView.layer.cornerRadius = 5
                        self.contentView.addSubview(onlineView)
                        onlineView.bringSubviewToFront(self.contentView)
                        onlineView.isHidden = true
        
        selectionStyle = .none
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // update UI
        accessoryType = selected ? .checkmark : .none
    }
}
