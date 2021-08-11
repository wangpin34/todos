//
//  TodoCell.swift
//  todos
//
//  Created by Wang Pin <guyusay@gmail.com> on 2021/8/9.
//

import UIKit
import Foundation

class TodoCell: UITableViewCell {

    @IBOutlet weak var ContentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(_ item: Item) {
        ContentLabel.text = item.content
    }

}
