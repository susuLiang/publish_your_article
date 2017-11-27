//
//  UserArticlesController.swift
//  chatTogther
//
//  Created by Aries Yang on 2017/11/26.
//  Copyright © 2017年 Susu Liang. All rights reserved.
//

import UIKit
import Firebase

class UserArticlesController: UITableViewController {
    
    var authorUid: String = " "
    var articles: [Article] = []
    var articleKeys: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableCell()
        tableView.register(PublishArticleCell.self, forCellReuseIdentifier: "articleCell")
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(done))
        Database.database().reference().observe(.value) { (snapshot) in
            self.articles = []
            
            if let objects = snapshot.children.allObjects as? [DataSnapshot] {
                for object in objects {
                    if let users = object.value as? [String: AnyObject],
                        let currentUser = users[self.authorUid],
                        let firstname = currentUser["firstName"] as? String,
                        let lastname = currentUser["lastName"] as? String,
                        let articles = currentUser["articles"] as? NSDictionary {
                        guard let keys = articles.allKeys as? [String] else { return }
                        self.articleKeys = keys
                        for key in keys {
                            guard
                                let theArticle = articles[key] as? [String: String],
                                let title = theArticle["title"],
                                let content = theArticle["content"],
                                let date = theArticle["date"]
                                else { return }
                            
                            self.articles.insert(Article(id: key, title: title, content: content, date: date, author: firstname + " " + lastname, uid: self.authorUid), at: 0)
                            self.articles.sort() { $0.date > $1.date }
                        }
                        self.tableView.reloadData()
                        
                    }
                }
            }
        }
    }
    
    @objc func done() {
        navigationController?.popViewController(animated: true)
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
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath
            ) as! PublishArticleCell
        
        cell.titleLabel.text = articles[indexPath.row].title
        cell.contentLabel.text = articles[indexPath.row].content
        cell.authorButton.setTitle(" ", for: .normal)
        cell.dateLabel.text = "\(articles[indexPath.row].date)"
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
