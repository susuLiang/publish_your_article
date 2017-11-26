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
}

class MessagesController: UITableViewController {

    var articles: [Article] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(sendNew))
        
        checkLoggedIn()

        Database.database().reference().observe(.value) { (snapshot) in
            self.articles = []
            print(snapshot.value)
            if let objects = snapshot.children.allObjects as? [DataSnapshot] {
                for object in objects {
                    if let users = object.value as? [String: AnyObject] {
                        let ref = Database.database().reference(fromURL: "https://chattogther.firebaseio.com/")
                        
                        print(users)
                    }
                }
            }
        }
 
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        checkLoggedIn()
    }
    
    @objc func sendNew() {
        let publishViewController = PublishViewController()
        present(publishViewController, animated: true, completion: nil)
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
                    self.navigationItem.title = firstName + " " + lastName
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
}

