//
//  ViewController.swift
//  TodoList
//
//  Created by Blink22 on 7/27/20.
//  Copyright © 2020 Blink22. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var presenter : ViewToPresenterListProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        self.title = "TODO List"
        self.navigationController?.navigationBar.prefersLargeTitles = true
            // Do any additional setup after loading the view.
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        
    }
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRowsInSection() ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return presenter!.cellForRowAt(tableView,indexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter!.didSelectRowAt(index: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        let edit =  editAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete, edit])
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let check = checkAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [check])
    }
    
    private func deleteAction (at indexPath: IndexPath) -> UIContextualAction{
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, compeletion) in
            self.presenter?.deleteRowAt(index: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            compeletion(true)
        }
        return action
    }
    private func checkAction (at indexPath: IndexPath) -> UIContextualAction{
        let action = UIContextualAction(style: .normal, title: "check") { (action, view, compeletion) in
            self.presenter?.didCheckRowAt(index: indexPath.row)
            
            compeletion(true)
        }
        return action
    }
    private func editAction (at indexPath: IndexPath) -> UIContextualAction{
        let action = UIContextualAction(style: .normal, title: "check") { (action, view, compeletion) in
            
            let ac = UIAlertController(title: "edit the todo...", message: "", preferredStyle: .alert)
            ac.addTextField()
            ac.addAction(UIAlertAction(title: "Submit", style: .default){ [weak self, weak ac] action in
                guard let answer = ac?.textFields?.first?.text    else {return}
                self?.presenter?.editRowAt(index: indexPath.row, to: answer)
            })
            ac.addAction(UIAlertAction(title: "Cancel", style: .destructive))
            self.present(ac,animated: true)
            //self.presenter?.ed(index: indexPath.row)
            
            compeletion(true)
        }
        return action
    }
    
    @objc func addItem(){
        let ac = UIAlertController(title: "enter Task", message: nil, preferredStyle: .alert)

        ac.addTextField { (textField) in
            textField.placeholder = "Enter todo title"
        }
        
        ac.addTextField { (textField) in
            textField.placeholder = "Enter todo detail"
        }

        ac.addAction(UIAlertAction(title: "Add", style: .default){ [weak self, weak ac] action in
            guard let title = ac?.textFields?.first?.text    else {return}
            guard let detail = ac?.textFields?[1].text    else {return}
            self?.presenter?.addATodo(title, detail: detail)
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        present(ac,animated: true)
    }
    
    private func prepareTFPromptText(_ tf:UITextField?){
        tf?.text = "task title here"
        tf?.tintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        let promptPosition = tf?.beginningOfDocument
        tf?.selectedTextRange = tf!.textRange(from: promptPosition!, to: promptPosition!)
    }

}

extension ViewController : PresenterToViewListProtocol {
    
    func onCreationSuccess(_ title: String, at index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func toggle(at index: Int) {
        let indexPath = NSIndexPath(row: index, section: 0)
        let cell = self.tableView(self.tableView, cellForRowAt: indexPath as IndexPath)
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "Your Text")
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        cell.textLabel?.attributedText = attributeString
        self.tableView.reloadData()
    }
    
    func onEditSuccess(at index: Int, to title: String) {
        let indexPath = NSIndexPath(row: index, section: 0)
        let cell = self.tableView(self.tableView, cellForRowAt: indexPath as IndexPath)
        cell.textLabel?.text = title
        self.tableView.reloadData()
    }
    
    
    func onFetchSuccess() {
        self.tableView.reloadData()
    }
    
    func onFetchFailure(error: String) {
        print("failed to fetch list")
    }
    
}
