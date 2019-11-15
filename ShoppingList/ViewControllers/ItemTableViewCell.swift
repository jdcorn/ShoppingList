//
//  ItemTableViewCell.swift
//  ShoppingList
//
//  Created by jdcorn on 11/15/19.
//  Copyright © 2019 jdcorn. All rights reserved.
//

import UIKit

protocol ItemTableViewCellDelegate: class {
    func isCheckedToggled(_ sender: ItemTableViewCell)
}

class ItemTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    weak var delegate: ItemTableViewCellDelegate?
    
    // MARK: - Outlets
    @IBOutlet weak var ItemUILabel: UILabel!
    @IBOutlet weak var isCheckedButton: UIButton!
    
    // MARK: - Actions
    @IBAction func isCheckedButtonTapped(_ sender: Any) {
        delegate?.isCheckedToggled(self)
    }
} // Class end

extension ItemTableViewCell {
    func updateViews(item: Item) {
        ItemUILabel.text = item.itemName
        
        
        if item.isChecked {
            isCheckedButton.setImage(UIImage(named: "checked"), for: .normal)
        } else {
            isCheckedButton.setImage(UIImage(named: "emptycheck"), for: .normal)
        }
    }
} // Ext. end
