//
//  ArticleTableViewCell.swift
//  chatTogther
//
//  Created by Cheng-Shan Hsieh on 2017/11/27.
//  Copyright © 2017年 Susu Liang. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    
    var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 80/255, green: 101/255, blue: 161/255, alpha: 1)
        button.setTitle("like", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        button.addTarget(self, action: #selector(like), for: .touchUpInside)
        return button
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func like() {
        
    }
    
//    func follow(_ otherUser: User) {
//        let ref = FIRDatabase.database().reference()
//        ref.child("users/\(otherUser.userId)/followers/")
//            .child(self.userId).setValue(true)
//        ref.child("user/\(self.userId)/following/")
//            .child(otherUser.userId).setValue(true)
//    }
//    
//    func unfollow(_ otherUser: User) {
//        let ref = FIRDatabase.database().reference()
//        ref.child("users/\(otherUser.userId)/followers/")
//            .child(self.userId).remove()
//        ref.child("user/\(self.userId)/following/")
//            .child(otherUser.userId).remove()
//    }
    
//    func setUpRegisterButton() {
//        registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        registerButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 12).isActive = true
//        registerButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
//        registerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
//    }

}
