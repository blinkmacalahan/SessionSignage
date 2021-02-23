//
//  ViewController.swift
//  iosApp
//
//  Created by Justin Carstens on 2/23/21.
//  Copyright © 2021 orgName. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var textView: UITextView!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the text
        textView.text = SignageSDK.shared.sessionText()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            // your code here
            self.textView.text = SignageSDK.shared.sessionText()
        }
    }

}
