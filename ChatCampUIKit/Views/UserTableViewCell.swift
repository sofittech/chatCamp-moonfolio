//
//  UserTableViewCell.swift
//  ChatCampUIKit
//
//  Created by Saurabh Gupta on 05/12/18.
//  Copyright © 2018 chatcamp. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView! {
        didSet {
            avatarImageView.layer.cornerRadius = avatarImageView.bounds.width/2
            avatarImageView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var onlineStatusImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
