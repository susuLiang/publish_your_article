//
//  NewMessagesViewController.swift
//  chatTogther
//
//  Created by Susu Liang on 2017/11/24.
//  Copyright © 2017年 Susu Liang. All rights reserved.
//

import UIKit

class PublishViewController: UIViewController {
    
    let dateTextField: UITextField = {
        let dateText = UITextField()
        dateText.placeholder = "Date"
        dateText.frame = CGRect(x: 10, y: 30, width: 80, height: 20)
        dateText.borderStyle = .line
        return dateText
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(titleTextField)
        view.addSubview(contentTextField)
        view.addSubview(dateTextField)
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

   
}
