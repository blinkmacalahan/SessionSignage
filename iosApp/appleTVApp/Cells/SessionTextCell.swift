//
//  SessionTextCell.swift
//  appleTVApp
//
//  Created by Justin Carstens on 2/24/21.
//  Copyright © 2021 orgName. All rights reserved.
//

import UIKit

class SessionTextCell: UICollectionViewCell {

    // MARK: - Outlets
    @IBOutlet weak var textTextView: UITextView!
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: - Configuration
    
    func configure(_ text: String?) {
        textTextView.text = text
    }

}
