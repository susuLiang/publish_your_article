//
//  NewMessagesViewController.swift
//  chatTogther
//
//  Created by Susu Liang on 2017/11/24.
//  Copyright © 2017年 Susu Liang. All rights reserved.
//

import UIKit
import Firebase

class PublishViewController: UIViewController {
    
    var ref: DatabaseReference?
    var handle: DatabaseHandle?
    
    
   
    let dateLabel: UILabel = {
        let date = UILabel()
        date.frame = CGRect(x: 10, y: 30, width: 300, height: 20)
        date.layer.borderColor = UIColor.black.cgColor
        date.layer.borderWidth = 1
        date.text = "\(Date())"
        date.textColor = UIColor.black
        return date
    }()
    
    let titleTextField: UITextField = {
        let titleText = UITextField()
        titleText.placeholder = "Title"
        titleText.frame = CGRect(x: 10, y: 60, width: 100, height: 40)
        titleText.borderStyle = .line
        return titleText
    }()
    
    let contentTextField: UITextField = {
        let contentText = UITextField()
        contentText.placeholder = "Content"
        contentText.frame = CGRect(x: 10, y: 110, width: 200, height: 300)
        contentText.borderStyle = .line
        return contentText
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 80/255, green: 101/255, blue: 161/255, alpha: 1)
        button.setTitle("Save", for: .normal)
        button.frame = CGRect(x: 175, y: 450, width: 100, height: 100)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(save), for: .touchUpInside)
        return button
    }()
    
    @objc func save() {
        guard let content = contentTextField.text,
            let title = titleTextField.text
        else {
            print("Form is not valid")
            return
        }
        guard let userid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference(fromURL: "https://chattogther.firebaseio.com/")
        let userReference = ref.child("users").child(userid).child("articles").childByAutoId()
        let value = ["title": title, "content": content, "date": dateLabel.text]
        userReference.setValue(value)
        
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(titleTextField)
        view.addSubview(contentTextField)
        view.addSubview(dateLabel)
        view.addSubview(saveButton)
     
    }
   
}
