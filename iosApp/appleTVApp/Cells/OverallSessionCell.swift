//
//  OverallSessionCell.swift
//  appleTVApp
//
//  Created by Justin Carstens on 2/26/21.
//  Copyright © 2021 orgName. All rights reserved.
//

import UIKit
#if os(tvOS)
import tvOSShared
#else
import shared
#endif

class OverallSessionCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var tagsStackView: UIStackView!
    @IBOutlet weak var openSeatsLabel: UILabel!
    @IBOutlet weak var checkedInSeatsLabel: UILabel!
    @IBOutlet weak var reserevedSeatsLabel: UILabel!
    
    // MARK: - Configure
    
    func configure(_ session: Session?) {
        resetInformation()
        guard let session = session else { return }
        
        nameLabel.text = session.name
        locationLabel.text = session.location
        openSeatsLabel.text = "\(session.seatingInfo.open)"
        checkedInSeatsLabel.text = "\(session.seatingInfo.checkedIn)"
        reserevedSeatsLabel.text = "\(session.seatingInfo.reserved)"
        
        for nextTag in session.tags {
            tagsStackView.addArrangedSubview(viewForTag(nextTag))
        }
    }
    
    private func resetInformation() {
        nameLabel.text = nil
        locationLabel.text = nil
        openSeatsLabel.text = "0"
        checkedInSeatsLabel.text = "0"
        reserevedSeatsLabel.text = "0"
        
        for nextSubview in tagsStackView.arrangedSubviews {
            tagsStackView.removeArrangedSubview(nextSubview)
            nextSubview.removeFromSuperview()
        }
    }
    
    private func viewForTag(_ tag: Tag) -> UIView {
        let tagView = UIView()
        tagView.backgroundColor = .clear
        tagView.translatesAutoresizingMaskIntoConstraints = false
        
        let circleView = UIView()
        circleView.backgroundColor = UIColor(hexString: tag.color)
        circleView.layer.masksToBounds = true
        circleView.layer.cornerRadius = 20.0
        circleView.translatesAutoresizingMaskIntoConstraints = false
        tagView.addSubview(circleView)
        
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.text = tag.name
        label.translatesAutoresizingMaskIntoConstraints = false
        tagView.addSubview(label)
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[circle(==40)]-(10)-[label]-(0)-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["circle" : circleView, "label" : label]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[circle(==40)]-(0)-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["circle" : circleView]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=0)-[label]-(>=0)-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["label" : label]))
        NSLayoutConstraint(item: label, attribute: .centerYWithinMargins, relatedBy: .equal, toItem: tagView, attribute: .centerYWithinMargins, multiplier: 1.0, constant: 0.0).isActive = true
        
        return tagView
    }
    

}
