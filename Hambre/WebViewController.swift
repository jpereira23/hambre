//
//  WebViewController.swift
//  Hambre
//
//  Created by Jeffery Pereira on 6/27/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    @IBOutlet var webView: UIWebView!
    private var website : String = "https://google.com"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.loadRequest(URLRequest(url: URL(string: self.website)! as URL) as URLRequest)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func setWebUrl(url: String)
    {
        self.website = url
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
