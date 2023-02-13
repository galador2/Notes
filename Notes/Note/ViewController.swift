//
//  ViewController.swift
//  Note
//
//  Created by Kirill  Kostenko  on 09.02.2023.
//

import UIKit

class ViewController: UIViewController {
    private var notesArray : [Notes]?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.register(CustomHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "HeaderView")
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemYellow
        button.setTitle("Добавить заметку", for: .normal)
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(self.didTapButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var viewModel: [Post] = [
        Post(text: "sone", id: UUID().uuidString)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        notesArray = CoreDataManager.shared.getNotes()
       
        
        self.setupNavigationBar()
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notesArray = CoreDataManager.shared.getNotes()
        tableView.reloadData()
    }
    
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Заметки"
    }
    
    private func setupView() {
        self.view.backgroundColor = .systemBackground
        
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.button)
        
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            self.button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            self.button.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            self.button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }


}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderView") as? CustomHeaderFooterView else { return nil }
            
            let viewModel = CustomHeaderFooterView.ViewModel(text: "Мои заметки")
            headerView.setup(with: viewModel)
            return headerView
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        CoreDataManager.shared.getNotes().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell
        notesArray = CoreDataManager.shared.getNotes()
        let note = notesArray?[indexPath.row]
        cell.setup(with: note)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let photosViewController = CustomViewNote()
        photosViewController.index = indexPath.row
        photosViewController.id = notesArray?[indexPath.row].id
        print(notesArray?[indexPath.row].id)
        photosViewController.noteText = notesArray?[indexPath.row].text
        self.navigationController?.pushViewController(photosViewController, animated: true)
    }

    
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Поделиться") { _, _, _ in
        }
        action.backgroundColor = .systemBlue
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Удалить") { _, _, _ in
            self.notesArray = CoreDataManager.shared.getNotes()
            if let note = self.notesArray?[indexPath.row] {
                CoreDataManager.shared.persistentContainer.viewContext.delete(note)
                do {
                    try CoreDataManager.shared.persistentContainer.viewContext.save()

                } catch {
                    print(error.localizedDescription)
                }
            }
            self.tableView.reloadData()
        }
        let smthAction = UIContextualAction(style: .normal, title: "Добавить действие") { _, _, _ in
        }
        let configuration = UISwipeActionsConfiguration(actions: [action, smthAction])
        return configuration
    }
    @objc private func didTapButton() {
        let note = Post(text: "Новая заметка", id:  UUID().uuidString)
        CoreDataManager.shared.saveNewNote(note: note)
            self.notesArray = CoreDataManager.shared.getNotes()
        print("added \(notesArray)")

        let indexPath = IndexPath(row: notesArray?.count ?? 0 , section: 0)
        self.tableView.reloadData()

    }
    
}
