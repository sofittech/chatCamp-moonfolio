//
//  OpenChannelsViewController.swift
//  ChatCamp Demo
//
//  Created by Tanmay Khandelwal on 10/02/18.
//  Copyright © 2018 iFlyLabs Inc. All rights reserved.
//

import UIKit
import ChatCamp
import SDWebImage
import MBProgressHUD

open class OpenChannelsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UINib(nibName: String(describing: ChatTableViewCell.self), bundle: Bundle(for: ChatTableViewCell.self)), forCellReuseIdentifier: ChatTableViewCell.string())

        }
    }
    
    var channels: [CCPOpenChannel] = []
    fileprivate var loadingChannels = false
    var openChannelsQuery: CCPOpenChannelListQuery!

    override open func viewDidLoad() {
        super.viewDidLoad()
        
        openChannelsQuery = CCPOpenChannel.createOpenChannelListQuery()
        loadChannels()
    }
    
    fileprivate func loadChannels() {
        let progressHud = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHud.label.text = "Loading..."
        progressHud.contentColor = .black
        loadingChannels = true
        openChannelsQuery.load() { [weak self] (channels, error) in
            progressHud.hide(animated: true)
            if error == nil {
                guard let channels = channels else { return }
                self?.channels.append(contentsOf: channels)
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.loadingChannels = false
                }
            } else {
                DispatchQueue.main.async {
                    self?.showAlert(title: "Can't Load Open Channels", message: "Unable to load Open Channels right now. Please try later.", actionText: "Ok")
                    self?.loadingChannels = false
                }
            }
        }
    }
}

// MARK:- UITableViewDataSource
extension OpenChannelsViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.string(), for: indexPath) as! ChatTableViewCell
        cell.nameLabel.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        
        let channel = channels[indexPath.row]
        cell.messageLabel.isHidden = true
        cell.unreadCountLabel.isHidden = true
        cell.nameLabel.text = channel.getName()
        if let avatarUrl = channel.getAvatarUrl() {
            
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
            
            
            //cell.avatarImageView?.sd_setImage(with: URL(string: avatarUrl), completed: nil)
        } else {
            cell.avatarImageView.setImageForName(string: channel.getName(), backgroundColor: nil, circular: true, textAttributes: nil)
        }
        
        cell.backgroundColor = UIColor.clear
        cell.backgroundView?.backgroundColor = UIColor.clear
        return cell
    }
}

// MARK:- UITableViewDelegate
extension OpenChannelsViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userID = CCPClient.getCurrentUser().getId()
        let username = CCPClient.getCurrentUser().getDisplayName()
        
        let sender = Sender(id: userID, displayName: username!)
        let channel = channels[indexPath.row]
        channel.join() { error in
            if error == nil {
                print("Channel Joined")
                let openChannelChatViewController = OpenChannelChatViewController(channel: channel, sender: sender)
                self.navigationController?.pushViewController(openChannelChatViewController, animated: true)
            } else {
                self.showAlert(title: "Error!", message: "Unable to join this open channel. Please try again.", actionText: "Ok")
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK:- ScrollView Delegate Methods
extension OpenChannelsViewController {
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (tableView.indexPathsForVisibleRows?.contains([0, channels.count - 1]) ?? false) && !loadingChannels && channels.count >= 20 {
            loadChannels()
        }
    }
}
