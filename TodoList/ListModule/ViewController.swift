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
 //       presenter?.viewDidLoad()
        
        self.title = "TODO List"
        self.navigationController?.navigationBar.prefersLargeTitles = true
            // Do any additional setup after loading the view.
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewDidLoad()

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
        edit.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        return UISwipeActionsConfiguration(actions: [delete, edit])
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let check = checkAction(at: indexPath)
        if (self.presenter?.todos[indexPath.row].isChecked)!{
            check.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        }else{
           check.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        }
        
        return UISwipeActionsConfiguration(actions: [check])
    }
    
    private func deleteAction (at indexPath: IndexPath) -> UIContextualAction{
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, compeletion) in
            self.presenter?.deleteRowAt(index: indexPath.row)
//            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            compeletion(true)
        }
        return action
    }
    private func checkAction (at indexPath: IndexPath) -> UIContextualAction{
        let titl = ((self.presenter?.todos[indexPath.row].isChecked)!) ? "Uncheck" : "check"
        let action = UIContextualAction(style: .normal, title: titl ) { (action, view, compeletion) in
            self.presenter?.didCheckRowAt(index: indexPath.row)
            
            compeletion(true)
        }
        return action
    }
    
    private func editAction (at indexPath: IndexPath) -> UIContextualAction{
        let action = UIContextualAction(style: .normal, title: "edit") { (action, view, compeletion) in
            
            let ac = UIAlertController(title: "edit the todo...", message: "", preferredStyle: .alert)
            ac.addTextField { (textField) in
                if let cell = self.tableView.cellForRow(at: indexPath) {
                    textField.text = cell.textLabel?.text
                }
                
            }
            ac.addAction(UIAlertAction(title: "Submit", style: .default){ [weak self, weak ac] action in
                guard let answer = ac?.textFields?.first?.text    else {return}
                self?.presenter?.editRowAt(index: indexPath.row, to: answer, detail: nil)
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
            //self?.presenter?.addATodo(title, detail: detail)
            self?.presenter?.addATodo(TodoItem(title: title, isChecked: false, detail: detail, id: nil, imageURL: nil))
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        present(ac,animated: true)
    }
    
    

}

extension ViewController : PresenterToViewListProtocol {
    func onAddImageSuccess(with url: URL) {
        
    }
    
      
    func onCreationSuccess(_ title: String, at index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        //
    }
    
    func onDeletionSuccess(at index: Int){
        let indexPath = IndexPath(row: index, section: 0)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func toggle(at index: Int, _ isChecked: Bool) {

        self.tableView.reloadData()
    }
    
    func onEditSuccess(at index: Int, to title: String) {
        print("edited successfully")
        tableView.reloadData()
    }
    
    
    func onFetchSuccess() {
        self.tableView.reloadData()
    }
    
    func onFetchFailure(error: String) {
        print("failed to fetch list")
    }
    
    func getNavController() -> UINavigationController? {
        return self.navigationController
    }
    
}


