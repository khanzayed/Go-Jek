//
//  ContactTableViewCell.swift
//  GoJekContactApp
//
//  Created by Faraz on 18/05/19.
//  Copyright © 2019 Faraz. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var favImageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    var contactCellViewModel: ContactCellViewModel? {
        didSet {
            if let value = contactCellViewModel {
                userImageView.image = nil
                favImageView.isHidden = !value.isFavorite
                nameLbl.text = value.name
            }
        }
    }

}
