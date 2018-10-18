//
//  IssueTableViewCell.swift
//  RedmineMobile
//
//  Created by Callum Trounce on 15/04/2018.
//  Copyright © 2018 DTT. All rights reserved.
//

import UIKit

class IssueTableViewCell: UITableViewCell {

    static let identifier = "issueCell"
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var priorityView: UIView! {
        didSet {
            priorityView.clipsToBounds = true
            priorityView.layer.cornerRadius = 4
        }
    }

    @IBOutlet weak var priorityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .gray
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = ""
        descriptionLabel.text = ""
        priorityView.backgroundColor = .white
        priorityLabel.text = ""
    }
    
    func configure(name: String, description: String?, priority: String, priorityColor: UIColor) {
        nameLabel.text = name
        descriptionLabel.text = description
        priorityLabel.text = priority
        priorityView.backgroundColor = priorityColor
        
        if description == nil || (description?.isEmpty ?? true) {
            descriptionLabel.isHidden = true
        } else {
            descriptionLabel.isHidden = false
        }
    }
}
