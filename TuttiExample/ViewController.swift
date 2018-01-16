//
//  ViewController.swift
//  TuttiExample
//
//  Created by Daniel Saidi on 2017-12-03.
//  Copyright © 2017 Daniel Saidi. All rights reserved.
//

import UIKit
import EasyTipView
import Tutti

class ViewController: UIViewController {

    
    // MARK: - Dependencies
    
    let hintPresenter = EasyTipViewHintPresenter()
    var tutorialPresenter: TutorialPresenter?
    
    
    // MARK: - Properties
    
    fileprivate let options: [ListOption] = [
        .hint,
        .tutorial,
        .tutorial_user(id: "1"),
        .tutorial_user(id: "2"),
        .tutorial_l10n,
        .spacer,
        .reset
    ]
    
    
    // MARK: - Outlets

    @IBOutlet weak var tableView: UITableView? {
        didSet {
            guard let view = tableView else { return }
            view.dataSource = self
            view.delegate = self
        }
    }
}


// MARK: - Private Functions

fileprivate extension ViewController {
    
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func alertAlreadyDisplayed(title: String) {
        alert(title: title, message: "Press 'reset' to reset its display state. You can then display it again.")
    }
    
    func alertAlreadyDisplayedHint() {
        alertAlreadyDisplayed(title: "This hint has already been displayed")
    }
    
    func alertAlreadyDisplayedTutorial() {
        alertAlreadyDisplayed(title: "This tutorial has already been displayed")
    }
    
    func getHint(forUser userId: String?) -> Hint {
        return StandardHint(identifier: "hint", text: "This is a quick hint. It will only be displayed once.", userId: userId)
    }
    
    func getLocalizedTutorial(forUser userId: String?) -> Tutorial {
        return StandardTutorial(identifier: "tutorial_l10n", pageCount: 1, userId: userId)
    }
    
    func getTutorial(forUser userId: String?) -> Tutorial {
        return StandardTutorial(identifier: "tutorial", pageCount: 1, userId: userId)
    }

    func resetDisplayState() {
        let displayables: [Displayable] = [
            getHint(forUser: nil),
            getHint(forUser: "1"),
            getHint(forUser: "2"),
            getTutorial(forUser: nil),
            getTutorial(forUser: "1"),
            getTutorial(forUser: "2"),
            getLocalizedTutorial(forUser: nil),
            getLocalizedTutorial(forUser: "1"),
            getLocalizedTutorial(forUser: "2")
        ]
        displayables.forEach { $0.hasBeenDisplayed = false }
        alert(title: "Done!", message: "All hints and tutorials are now set to not displayed")
    }
    
    func showHint(forUser userId: String?, from view: UIView) {
        let hint = getHint(forUser: userId)
        if hint.hasBeenDisplayed { return alertAlreadyDisplayedHint() }
        _ = hintPresenter.present(hint: hint, in: self, from: view)
    }
    
    func showTutorial(forUser userId: String?, from view: UIView) {
        let tutorial = getTutorial(forUser: userId)
        let vc = TutorialViewController(nibName: nil, bundle: nil)
        tutorialPresenter = TutorialViewControllerPresenter(vc: vc)
        _ = tutorialPresenter?.present(tutorial: tutorial, in: self, from: view)
    }
    
    func showLocalizedTutorial(forUser userId: String?, from view: UIView) {
        let tutorial = LocalizedTutorial(identifier: "basicTutorial")
        if tutorial.hasBeenDisplayed { return alertAlreadyDisplayedTutorial() }
        let vc = TutorialViewController(nibName: nil, bundle: nil)
        tutorialPresenter = TutorialViewControllerPresenter(vc: vc)
        _ = tutorialPresenter?.present(tutorial: tutorial, in: self, from: view)
    }
}


// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    
    func listOption(at indexPath: IndexPath) -> ListOption {
        return options[indexPath.row]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = "Cell"
        let option = listOption(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: id)
            ?? UITableViewCell(style: .default, reuseIdentifier: id)
        cell.textLabel?.text = option.title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}


// MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let option = listOption(at: indexPath)
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        switch option {
        case .hint: showHint(forUser: nil, from: cell)
        case .reset: resetDisplayState()
        case .spacer: break
        case .tutorial: showTutorial(forUser: nil, from: cell)
        case .tutorial_l10n: showLocalizedTutorial(forUser: nil, from: cell)
        case .tutorial_user(let id): showTutorial(forUser: id, from: cell)
        }
    }
}

