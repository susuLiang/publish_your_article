//
//  ViewController.swift
//  chatTogther
//
//  Created by Susu Liang on 2017/11/24.
//  Copyright © 2017年 Susu Liang. All rights reserved.
//

import UIKit
import Firebase

struct Article {
    let id: String
    let title: String
    let content: String
    let date: String
    let author: String
    let uid: String
}

class MessagesController: UITableViewController {

    var publishArticles: [Article] = []
    var publishArticleKeys: [String] = []
    var userIDs: [String] = []
    var userLikes: [String: [String]] = [:]
    var author: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableCell()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(publishAnArticle))
        
        checkLoggedIn()

        Database.database().reference().observe(.value) { (snapshot) in
            self.publishArticles = []
            
            if let objects = snapshot.children.allObjects as? [DataSnapshot] {
                for object in objects {
                    if let users = object.value as? NSDictionary {
                        guard let userKeys = users.allKeys as? [String] else { return }
                        for uid in userKeys {
                            if
                                let userInfo = users[uid] as? [String: Any],
                                let firstname = userInfo["firstName"] as? String,
                                let lastname = userInfo["lastName"] as? String,
                                let articles = userInfo["articles"] as? NSDictionary {
                                    if let likes = userInfo["postLikes"] as? [String: Bool] {
                                        let likeId = Array(likes.keys)
                                        self.userLikes.updateValue(likeId, forKey: uid)
                                    }
                                guard let keys = articles.allKeys as? [String] else { return }
                                self.publishArticleKeys = keys
                                for key in keys {
                                    guard
                                        let theArticle = articles[key] as? [String: String],
                                        let title = theArticle["title"],
                                        let content = theArticle["content"],
                                        let date = theArticle["date"]
                                    else { return }
                                    
                                    self.publishArticles.insert(Article(id: key, title: title, content: content, date: date, author: firstname + " " + lastname, uid: uid), at: 0)
                                    self.publishArticles.sort() { $0.date > $1.date }
                                }
                            }
                        }
                        self.tableView.reloadData()
                    }
                }
            }
        }
 
    }
    
    func setupTableCell() {
        let nib = UINib(
            nibName: "PublishArticleCell",
            bundle: nil
        )
        
        tableView.register(
            nib,
            forCellReuseIdentifier: "cell"
        )
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        checkLoggedIn()
    }
    
    func checkLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(uid!).observe(.value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any],
                    let firstName = dictionary["firstName"] as? String,
                    let lastName = dictionary["lastName"] as? String {
                    self.author = "\(firstName) \(lastName)"
                    self.navigationItem.title = "All Articles"
                }
            })
        }
    }

    @objc func handleLogout() {
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }

    @objc func authorAtcs(_ sender: UIButton) {
        let authorArticleController = UserArticlesController()
        authorArticleController.authorUid = publishArticles[sender.tag].uid   
        navigationController?.pushViewController(authorArticleController, animated: true)
    }
    
    @objc func publishAnArticle() {
        let publishViewController = PublishViewController()
        publishViewController.author = self.author
        navigationController?.pushViewController(publishViewController, animated: true)
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return publishArticles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath
            ) as! PublishArticleCell
    
        cell.titleLabel.text = publishArticles[indexPath.row].title
        cell.contentLabel.text = publishArticles[indexPath.row].content
        cell.dateLabel.text = "\(publishArticles[indexPath.row].date)"

        cell.authorButton.setTitle("Author: \(publishArticles[indexPath.row].author)", for: .normal)
        cell.authorButton.setTitle(publishArticles[indexPath.row].author, for: .normal)
        cell.authorButton.tag = indexPath.row
        cell.authorButton.addTarget(self, action: #selector(authorAtcs), for: .touchUpInside)
        
        let image = UIImage(named: "icon-heart")?.withRenderingMode(.alwaysTemplate)
        cell.likeButton.setImage(image, for: .normal)
        if exist(articleId: publishArticles[indexPath.row].id) {
            cell.likeButton.tintColor = UIColor.red
        } else {
            cell.likeButton.tintColor = UIColor.black
        }
        cell.likeButton.tag = indexPath.row
        cell.likeButton.addTarget(self, action: #selector(like), for: .touchUpInside)
        
        return cell
    }
    
    @objc func like(_ sender: UIButton) {
        if exist(articleId: publishArticles[sender.tag].id) {
            sender.tintColor = UIColor.black
            guard let userid = Auth.auth().currentUser?.uid else { return }
            let ref = Database.database().reference(fromURL: "https://chattogther.firebaseio.com/")
            let userReference = ref.child("users").child(userid).child("postLikes").child(publishArticles[sender.tag].id)
            userReference.removeValue()
        } else {
            sender.tintColor = UIColor.red
            guard let userid = Auth.auth().currentUser?.uid else { return }
            let ref = Database.database().reference(fromURL: "https://chattogther.firebaseio.com/")
            let userReference = ref.child("users").child(userid).child("postLikes").child(publishArticles[sender.tag].id)
            userReference.setValue(true)
        }
        
    }
    
    func exist(articleId: String) -> Bool {
        
        guard let uid = Auth.auth().currentUser?.uid else {return false}
        if let userlike = userLikes[uid] {
            for postId in userlike  {
                if articleId == postId {
                    return true
                }
            }
        }
        return false
    }
    
}

