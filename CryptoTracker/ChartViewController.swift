//
//  ChartViewController.swift
//  CryptoTracker
//
//  Created by MKHS on 4/6/19.
//  Copyright © 2019 mkhs. All rights reserved.
//

import UIKit
import WebKit

class ChartViewController: UIViewController, WKUIDelegate, WKNavigationDelegate  {
    
    
    var delegate: UrlReq?

    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        webView.load(URLRequest(url: (delegate?.getUrl())!))
    }
    


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //AppUtility.lockOrientation(.landscapeLeft)
        // Or to rotate and lock
        AppUtility.lockOrientation(.landscapeLeft, andRotateTo: .landscapeLeft)

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

