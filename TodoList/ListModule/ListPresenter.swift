//
//  ListPresenter.swift
//  TodoList
//
//  Created by Blink22 on 7/27/20.
//  Copyright © 2020 Blink22. All rights reserved.
//

import Foundation
import UIKit

class ListPresenter: ViewToPresenterListProtocol{    
    
    var view: PresenterToViewListProtocol?
    
    var interactor: PresenterToInteractorListProtocol?
    
    var router: PresenterToRouterListProtocol?
    
    var todos: [TodoItem] = []
    
    func viewDidLoad() {
        self.interactor?.loadTodos(){ message, todos in
            if message == "success"{
                self.fetchListSuccess(list: todos)
            }else{
                print("failed to load data \n\n\n" )
            }
        }
        
    }
    
    func numberOfRowsInSection() -> Int {
        return todos.count
    }
    
    func textLabelText(indexPath: IndexPath) -> String? {
        return todos[indexPath.row].title
    }
    
    func cellForRowAt( _ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = todos[indexPath.row].title
        
        
        if todos[indexPath.row].isChecked{
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: cell.textLabel?.text ?? "")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            cell.textLabel!.attributedText = attributeString
                
        }else{
            //cell.backgroundColor = #colorLiteral(red: 1, green: 0.9924470415, blue: 0.9535258082, alpha: 1)
            //let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: (todos[indexPath.row].title))
            cell.textLabel?.attributedText = NSMutableAttributedString(string: todos[indexPath.row].title)
        }
        
        return cell
    }
    
    func didSelectRowAt(index: Int) {
        interactor?.retriveATodo(at: index)
    }
    
    func didCheckRowAt(index: Int){
        interactor?.check(at: index)
    }
    
    func deleteRowAt(index: Int){
        interactor?.deleteATodo(at: index)
    }
    
    func editRowAt(index: Int, to title: String){
        interactor?.editATodo(at: index, to: title)
    }
    
    func addATodo(_ title: String, detail: String?) {
        interactor?.addATodo(title, detail: detail, isChecked: nil, index: nil)
    }
       
}


extension ListPresenter: InteractorToPresenterListProtocol {
    func creationSuccess(_ title: String, detail: String?, isChecked: Bool?, index: Int?) {
        
        todos.append(TodoItem(title: title, isChecked: false, details: detail))
        
        view?.onCreationSuccess(title, at: (todos.count - 1))
        
    }
    
    func deletionSuccess(at index: Int) {
        todos.remove(at: index)
        print("deleted successfully")
        view?.onDeletionSuccess(at: index)
    }
    
    func checkSuccess(at index: Int) {
        self.todos[index].isChecked = !(self.todos[index].isChecked )
        view?.toggle(at: index, self.todos[index].isChecked)
        
    }
    
    func editSuccess(at index: Int, title: String) {
        self.todos[index].title = title
        view?.onEditSuccess(at: index, to: title)
    }
    
    
    func fetchListSuccess(list: [TodoItem]) {

        self.todos = list.compactMap{$0.self}
        DispatchQueue.main.async {
            self.view?.onFetchSuccess()
        }
        
    }
    
    func fetchListFailure(errorCode: Int) {
        view?.onFetchFailure(error: "Can't load Todo List")
    }
    
    func getItemSuccess(_ todo: TodoItem) {
        router?.pushToDetail(on: view!, with: todo)
    }
    
    func getItemFailure() {
        print("couldn't retreive item")
    }

    
}
