//
//  DetailViewController.swift
//  MyChallengeDay74
//
//  Created by Георгий Евсеев on 1.10.22.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var textView: UITextView!
    var detailNote: Note?
    var selectedNote: String?

    override func loadView() {
        textView = UITextView()
        view = textView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        guard detailNote != nil else { return }
        detailNote?.body = textView.text
        print(detailNote?.body as Any)
        
    }

    @objc func shareTapped() {
        guard let text = textView.text else {
            print("No note found")
            return
        }

        let vc = UIActivityViewController(activityItems: [text, "\(textView!)"], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}
