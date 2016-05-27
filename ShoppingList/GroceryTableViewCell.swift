//
//  GroceryTableViewCell.swift
//  ShoppingList
//
//  Created by Tyler on 5/27/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import UIKit

class GroceryTableViewCell: UITableViewCell {

    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var didGetButton: UIButton!
    
    
    var delegate: GroceryTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateWithGroceryItem(groceries: Groceries) {
        itemLabel.text = groceries.item
        groceryItemValueChanged(groceries.didGet.boolValue)
        
    }
    
    func groceryItemValueChanged(value: Bool) {
        if value == true {
            didGetButton.imageView?.image = UIImage(named: "complete")
        } else {
            didGetButton.imageView?.image = UIImage(named: "incomplete")
        }
    }
    
    // MARK: - Action Button
    
    
    @IBAction func didGetButtonTapped(sender: AnyObject) {
        delegate?.didGetButtonCellTapped(self)
    }

}
    // MARK: - Protocol

protocol GroceryTableViewCellDelegate {
    func didGetButtonCellTapped(cell: GroceryTableViewCell)
}
