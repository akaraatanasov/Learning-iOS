//
//  TableSectionHeader.swift
//  TableViewExample
//
//  Created by Alexander on 21.03.18.
//  Copyright © 2018 Alexander. All rights reserved.
//

import UIKit

protocol TableSectionHeaderDelegate: class {
    func buttonWasTappedInHeaderView(_ header: TableSectionHeader)
}

class TableSectionHeader: UITableViewHeaderFooterView {
    
    weak var delegate: TableSectionHeaderDelegate?
    
    var indexOfSection: Int = 0

    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var expansionButton: UIButton!

    func configureCell(withTitle title: String, isSelected selected: Bool) {
        headerLabel.text = title
        let buttonTitle = selected ? "Collapse" : "Expand"
        expansionButton.setTitle(buttonTitle, for: .normal)
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        delegate?.buttonWasTappedInHeaderView(self)
    }
}
