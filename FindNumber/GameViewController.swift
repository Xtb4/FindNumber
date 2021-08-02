//
//  GameViewController.swift
//  FindNumber
//
//  Created by Павел on 01.07.2021.
//

import UIKit

class GameViewController: UIViewController {
    
    // MARK: - PROPERTIES
    @IBOutlet var buttons: [UIButton]!
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var nextDigit: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var newGameButton: UIButton!
    
    lazy var game = Game(countItems: buttons.count) { [weak self] (status, time) in
        guard let self = self else {return}
        self.timerLabel.text = time.secondsToString()
        self.updateInfoGame(with: status)
    }
    
    // MARK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreen()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        game.stopGame()
    }
    
    @IBAction func pressButton(_ sender: UIButton) {
        guard let buttonIndex = buttons.firstIndex(of: sender) else {
            return
        }
        
        game.check(index: buttonIndex)
        updateUI()
    }
    
    @IBAction func newGameAction(_ sender: UIButton) {
        sender.isHidden = true
        newGame()
    }
    
    private func newGame() {
        game.newGame()
        setupScreen()
    }
    
    private func setupScreen() {
        
        for index in game.items.indices {
            buttons[index].setTitle(game.items[index].title, for: .normal)
            buttons[index].alpha = 1
            buttons[index].isEnabled = true
        }
        
        nextDigit.text = game.nextItem?.title
    }
    
    private func updateUI() {
        for index in game.items.indices {
            buttons[index].alpha = game.items[index].isFound ? 0 : 1
            buttons[index].isEnabled = !game.items[index].isFound
            
            if game.items[index].isError {
                UIView.animate(withDuration: 0.3) { [weak self] in
                    self?.buttons[index].backgroundColor = .red
                } completion: { [weak self] (_) in
                    self?.buttons[index].backgroundColor = UIColor(named: "ButtonColor")
                    self?.game.items[index].isError = false
                }
            }
        }
        
        nextDigit.text = game.nextItem?.title
        
        updateInfoGame(with: game.status)
    }
    
    private func updateInfoGame(with status: StatusGame) {
        switch status {
        case .start:
            showGameStarted()
        case .win:
            showGameWin()
        case .lose:
            showGameLose()
        }
    }
    
    private func showGameStarted() {
        statusLabel.text = NSLocalizedString("game_started", comment: "")
        statusLabel.textColor = .black
        newGameButton.isHidden = true
    }
    
    private func showGameWin() {
        statusLabel.text = NSLocalizedString("you_won", comment: "")
        statusLabel.textColor = .green
        newGameButton.isHidden = false
        if game.isNewRecord {
            showNewRecordAlert()
        } else {
            showAlertActionShet()
        }
    }
    
    private func showGameLose() {
        statusLabel.text = NSLocalizedString("you_lose", comment: "")
        statusLabel.textColor = .red
        newGameButton.isHidden = false
        showAlertActionShet()
    }
    
    private func showNewRecordAlert() {
        let newRecordString = String(format: NSLocalizedString("new_record %i", comment: ""), UserDefaults.standard.integer(forKey: KeysUserDefaults.recordGame))
        let alert = UIAlertController(title: NSLocalizedString("congratulations", comment: ""), message: newRecordString, preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func showAlertActionShet() {
        let alert = UIAlertController(title: NSLocalizedString("end_game_menu_title", comment: ""), message: nil, preferredStyle: .actionSheet)
        
        let newGameAction = UIAlertAction(title: NSLocalizedString("new_game", comment: ""), style: .default) { [weak self] (_) in
            self?.newGame()
        }
        let showRecord = UIAlertAction(title: NSLocalizedString("view_record", comment: ""), style: .default) { [weak self] (_) in
            self?.performSegue(withIdentifier: "recordVC", sender: nil)
        }
        let menuAction = UIAlertAction(title: NSLocalizedString("go_to_menu", comment: ""), style: .destructive) { [weak self] (_) in
            self?.navigationController?.popViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: nil)
        
        alert.addAction(newGameAction)
        alert.addAction(showRecord)
        alert.addAction(menuAction)
        alert.addAction(cancelAction)
        
        if let popover = alert.popoverPresentationController {
            popover.sourceView = statusLabel
        }
        
        present(alert, animated: true, completion: nil)
    }
}
