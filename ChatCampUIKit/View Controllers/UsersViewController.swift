//
//  UsersViewController.swift
//  ChatCamp Demo
//
//  Created by Saurabh Gupta on 21/05/18.
//  Copyright © 2018 iFlyLabs Inc. All rights reserved.
//

import UIKit
import ChatCamp
import SDWebImage
import MBProgressHUD

open class UsersViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 44
            tableView.register(UINib(nibName: String(describing: ChatTableViewCell.self), bundle: Bundle(for: ChatTableViewCell.self)), forCellReuseIdentifier: ChatTableViewCell.string())
        }
    }
    
    open var users: [CCPUser] = []
    fileprivate var usersToFetch: Int = 20
    fileprivate var loadingUsers = false
    open var usersQuery: CCPUserListQuery!

    open override func viewDidLoad() {
        super.viewDidLoad()

        usersQuery = CCPClient.createUserListQuery()
        loadUsers(limit: usersToFetch)
    }
    
    fileprivate func loadUsers(limit: Int) {
        let progressHud = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHud.label.text = "Loading..."
        progressHud.contentColor = .black
        loadingUsers = true
        usersQuery.load(limit: limit) { [unowned self] (users, error) in
            progressHud.hide(animated: true)
            if error == nil {
                guard let users = users else { return }
                self.users.append(contentsOf: users.filter({ $0.getId() != CCPClient.getCurrentUser().getId() }))
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.loadingUsers = false
                }
            } else {
                DispatchQueue.main.async {
                    self.showAlert(title: "Can't Load Users", message: "Unable to load Users right now. Please try later.", actionText: "Ok")
                    self.loadingUsers = false
                }
            }
        }
    }
}

// MARK:- UITableViewDataSource
extension UsersViewController: UITableViewDataSource {
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.string(), for: indexPath) as! ChatTableViewCell
        cell.nameLabel.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true

        let user = users[indexPath.row]
        cell.onlineView.isHidden = !user.getIsOnline()!
                        cell.accessoryLabel.isHidden = true
        cell.nameLabel.text = "\(user.getDisplayName()!)"
        cell.messageLabel.text = ""
        cell.unreadCountLabel.isHidden = true
        if let avatarUrl = user.getAvatarUrl() {
//            print ("IF: \(avatarUrl.contains("http"))")
            if (!avatarUrl.contains("http"))
            {
                var str = ("https://www.moonfolio.io/\(avatarUrl)").replacingOccurrences(of: "/./", with: "/").replacingOccurrences(of: " ", with: "_")
                print ("Loading: \(str)")
                cell.avatarImageView?.sd_setImage(with: URL(string: str), completed: nil)
            }
            else{
                var str = ("\(avatarUrl)").replacingOccurrences(of: "/./", with: "/").replacingOccurrences(of: " ", with: "_")
                print ("Loading: \(str)")
                cell.avatarImageView?.sd_setImage(with: URL(string: str), completed: nil)
            }
            
        } else {
//            print ("ELSE: \(user.getDisplayName())")
            cell.avatarImageView.setImageForName(string: user.getDisplayName() ?? "?", circular: true, textAttributes: nil)
        }
        
        cell.backgroundColor = UIColor.clear
        cell.backgroundView?.backgroundColor = UIColor.clear
        return cell
    }
}

// MARK:- UITableViewDelegate
extension UsersViewController: UITableViewDelegate {
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        let userID = CCPClient.getCurrentUser().getId()
        let username = CCPClient.getCurrentUser().getDisplayName()
        
        let sender = Sender(id: userID, displayName: username!)
        
        CCPGroupChannel.create(name: user.getDisplayName() ?? "", userIds: [userID, user.getId()], isDistinct: true) { groupChannel, error in
            if error == nil {
                let chatViewController = ChatViewController(channel: groupChannel!, sender: sender)
                self.navigationController?.pushViewController(chatViewController, animated: true)
            } else {
                self.showAlert(title: "Error!", message: "Some error occured, please try again.", actionText: "OK")
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK:- ScrollView Delegate Methods
extension UsersViewController {
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (tableView.indexPathsForVisibleRows?.contains([0, users.count - 1]) ?? false) && !loadingUsers && users.count >= 19 {
            loadUsers(limit: usersToFetch)
        }
    }
}
