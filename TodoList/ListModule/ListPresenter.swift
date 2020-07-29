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
    
    var todos: [TodoItem]?
    
    func viewDidLoad() {
            self.interactor?.loadTodos()
        
        
        
    }
    
    func numberOfRowsInSection() -> Int {
        return todos?.count ?? 0
    }
    
    func textLabelText(indexPath: IndexPath) -> String? {
        return todos?[indexPath.row].title
    }
    
    func cellForRowAt( _ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = todos?[indexPath.row].title ?? ""
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
        interactor?.addATodo(title, detail: detail)
    }
       
}


extension ListPresenter: InteractorToPresenterListProtocol {
    func creationSuccess(_ title: String, detail: String?) {
        todos?.append(TodoItem(title: title, isChecked: false, details: detail))
        view?.onCreationSuccess(title, at: todos?.count ?? 0)
        
    }
    
    func deletionSuccess(at index: Int) {
        todos?.remove(at: index)
        print("deleted successfully")
        //view is updated
    }
    
    func checkSuccess(at index: Int) {
        self.todos?[index].isChecked = !(self.todos?[index].isChecked ?? false)
        view?.toggle(at: index)
        
    }
    
    func editSuccess(at index: Int, title: String) {
        self.todos?[index].title = title
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
