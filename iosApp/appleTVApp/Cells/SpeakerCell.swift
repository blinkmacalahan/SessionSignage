//
//  SpeakerCell.swift
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

class SpeakerCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var speakerImageView: ImageLoader!
    @IBOutlet weak var speakerName: UILabel!
    @IBOutlet weak var speakerCompany: UILabel!
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        speakerImageView.layer.masksToBounds = true
        speakerImageView.layer.cornerRadius = (speakerImageView.frame.size.height / 2.0)
    }
    
    // MARK: - Configure
    
    func configure(_ speaker: Speaker?) {
        if let imageString = speaker?.img, let url = URL(string: imageString) {
            speakerImageView.loadImageWithUrl(url)
        } else {
            speakerImageView.image = nil
        }
        speakerName.text = speaker?.name
        speakerCompany.text = speaker?.company
    }
    
}
