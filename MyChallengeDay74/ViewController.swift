//
//  ViewController.swift
//  MyChallengeDay74
//
//  Created by Георгий Евсеев on 1.10.22.
//

import UIKit

class ViewController: UITableViewController {
    var notes: [Note] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Note"
        navigationController?.navigationBar.prefersLargeTitles = true

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(callNote))
        
        let defaults = UserDefaults.standard

        if let savedNotes = defaults.object(forKey: "notes") as? Data {
            let jsonDecoder = JSONDecoder()

            do {
                notes = try jsonDecoder.decode([Note].self, from: savedNotes)
            } catch {
                print("Failed to load note")
            }
        }
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Note", for: indexPath)
        let note = notes[indexPath.row]
        cell.textLabel?.text = note.title
        cell.detailTextLabel?.text = note.body
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            let note = notes[indexPath.row]
            vc.selectedNote = note.body
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    @objc func callNote() {
        let ac = UIAlertController(title: "Enter notes", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
            guard let note = ac?.textFields?[0].text else { return }
            self?.submit(note)
        }

        ac.addAction(submitAction)
        present(ac, animated: true)
        tableView.reloadData()
    }

    func submit(_ note: String) {
        notes.append(Note(title: note, body: ""))
        tableView.reloadData()
        save()
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(notes) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "notes")
        } else {
            print("Failed to save people.")
        }
    }
}
