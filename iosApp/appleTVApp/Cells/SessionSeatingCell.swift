//
//  SessionSeatingCell.swift
//  appleTVApp
//
//  Created by Justin Carstens on 2/24/21.
//  Copyright © 2021 orgName. All rights reserved.
//

import UIKit
#if os(tvOS)
import tvOSShared
#else
import shared
#endif

class SessionSeatingCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var openSeatsLabel: UILabel!
    @IBOutlet weak var checkedInLabel: UILabel!
    @IBOutlet weak var reservedLabel: UILabel!
    
    // MARK: - Configuration
    
    func configure(_ seat: SeatingInfo?) {
        openSeatsLabel.text = "\(seat?.open ?? 0)"
        checkedInLabel.text = "\(seat?.checkedIn ?? 0)"
        reservedLabel.text = "\(seat?.reserved ?? 0)"
    }
    
}
