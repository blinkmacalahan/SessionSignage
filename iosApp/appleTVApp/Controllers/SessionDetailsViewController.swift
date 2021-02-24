//
//  SessionDetailsViewController.swift
//  appleTVApp
//
//  Created by Justin Carstens on 2/23/21.
//  Copyright © 2021 orgName. All rights reserved.
//

import UIKit
#if os(tvOS)
import tvOSShared
#else
import shared
#endif

class SessionDetailsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Outlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var tagsStackView: UIStackView!
    @IBOutlet weak var contentCollectionView: UICollectionView!
    
    // MARK: - Variables
    var sessionID: String?
    private var loadedSession: Session?
    private var menuPressRecognizer: UITapGestureRecognizer?
    private var nextItemTimer: Timer?
    private var currentIndex = 0
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load Session
        SignageSDK.shared.loadSessionForId(sessionID ?? "") { [weak self] (session: Session?) in
            self?.loadSessionInfo(session: session)
        }
        
        // Add Menu Override
        menuPressRecognizer = UITapGestureRecognizer()
        menuPressRecognizer?.addTarget(self, action: #selector(menuButtonAction))
        menuPressRecognizer?.allowedPressTypes = [NSNumber(value: UIPress.PressType.menu.rawValue)]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if nextItemTimer == nil {
            moveToNextItem()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Add Menu Override
        if let menuAction = menuPressRecognizer {
            view.addGestureRecognizer(menuAction)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Remove Menu Override
        if let menuAction = menuPressRecognizer {
            view.removeGestureRecognizer(menuAction)
        }
        
        nextItemTimer?.invalidate()
        nextItemTimer = nil
    }
    
    // MARK: - UI
    
    private func loadSessionInfo(session: Session?) {
        loadedSession = session
        resetInformation()
        guard let session = session else { return }
        
        nameLabel.text = session.name
        locationLabel.text = session.location
        dateLabel.text = Platform().formatDay(time: session.startTime)
        timeLabel.text = Platform().formatTime(time: session.startTime)
        
        for nextTag in session.tags {
            tagsStackView.addArrangedSubview(viewForTag(nextTag))
        }
        
        contentCollectionView.reloadData()
        
        nextItemTimer?.invalidate()
        nextItemTimer = nil
        currentIndex = 0
        
        moveToNextItem()
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
    
    private func resetInformation() {
        nameLabel.text = nil
        locationLabel.text = nil
        dateLabel.text = nil
        timeLabel.text = nil
        
        for nextSubview in tagsStackView.arrangedSubviews {
            tagsStackView.removeArrangedSubview(nextSubview)
        }
    }
    
    // MARK: - Animations
    
    private func moveToNextItem() {
        var shouldAnimate = false
        if nextItemTimer != nil {
            nextItemTimer?.invalidate()
            nextItemTimer = nil
            
            currentIndex += 1
            
            // Check to see if this is the last screen.
            if (currentIndex + 1) >= contentCollectionView.numberOfItems(inSection: 0) {
                if DisplayManager.shared?.displayNextScreen(from: self) ?? false {
                    // We are moving to the next screen don't continue
                    return
                }
            }
            
            // Loop Code
            if currentIndex >= contentCollectionView.numberOfItems(inSection: 0) {
                // Move back to the first one so we can loop everything
                contentCollectionView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: false)
                currentIndex = 1
            }
            shouldAnimate = true
        }
        
        // Figure out position to move to.
        var width = contentCollectionView.visibleSize.width
        if currentIndex == 0 {
            width = 0
        }
        contentCollectionView.scrollRectToVisible(CGRect(x: (width * CGFloat(currentIndex + 1)), y: 0, width: 1, height: 1), animated: shouldAnimate)
//        contentCollectionView.scrollToItem(at: IndexPath(row: currentIndex, section: 0), at: .right, animated: shouldAnimate)
        
        nextItemTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: { [weak self] (timer: Timer) in
            Block.performOnMainThread {
                self?.moveToNextItem()
            }
        })
    }
    
    // MARK: - User Actions

    @objc func menuButtonAction() {
        DisplayManager.shared?.dismissDisplay(from: self)
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 1 {
            let cell : SessionSeatingCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SessionSeatingCell", for: indexPath) as! SessionSeatingCell
            return cell
        } else if indexPath.row == 2 {
            let cell : SessionSpeakersCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SessionSpeakersCell", for: indexPath) as! SessionSpeakersCell
            return cell
        } else {
            // This is the first and last cell so we get a continuous loading
            let cell : SessionTextCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SessionTextCell", for: indexPath) as! SessionTextCell
            cell.configure(loadedSession?.description())
            return cell
        }
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.visibleSize
    }
    
}
