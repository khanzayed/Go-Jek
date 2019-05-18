//
//  ViewController.swift
//  GoJekContactApp
//
//  Created by Faraz on 18/05/19.
//  Copyright © 2019 Faraz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ContactsAPIHandler().getContacts { [weak self] (dataModel) in
            guard let _ = self else {
                return
            }
            
            if dataModel.contactsList.count > 0 {
                
            } else {
                print(dataModel.errMessage ?? "")
            }
        }
    }

}

