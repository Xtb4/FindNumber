//
//  BlueViewController.swift
//  FindNumber
//
//  Created by Павел on 05.07.2021.
//

import UIKit

class BlueViewController: UIViewController {
    
    @IBOutlet weak var testLabel: UILabel!
    var textForLabel = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testLabel.text = textForLabel
    }
    
    @IBAction func goToGreenController(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "greenVC") as? GreenViewController {
            vc.textForLabel = "Text String"
            vc.title = "Зелёный"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
