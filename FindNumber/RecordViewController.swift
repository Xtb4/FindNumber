//
//  RecordViewController.swift
//  FindNumber
//
//  Created by Павел on 06.07.2021.
//

import UIKit

class RecordViewController: UIViewController {

    @IBOutlet weak var recordLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let record = UserDefaults.standard.integer(forKey: KeysUserDefaults.recordGame)
        if record != 0 {
            recordLabel.text = String(format: NSLocalizedString("record_text %i", comment: ""), record)
        } else {
            recordLabel.text = NSLocalizedString("no_record", comment: "")
        }
    }

    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
