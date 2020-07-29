//
//  ListInteractor.swift
//  TodoList
//
//  Created by Blink22 on 7/27/20.
//  Copyright © 2020 Blink22. All rights reserved.
//

import Foundation
import Firebase

class ListInteractor: PresenterToInteractorListProtocol {
    
    var presenter: InteractorToPresenterListProtocol?
    var todos : [TodoItem] = []
    
    private var ref = Database.database().reference()
    
    func addATodo(_ title: String, detail: String?) {
        self.ref.child("todos").child(title).setValue(["datail": detail ?? "", "isChecked": false])
        todos.append(TodoItem(title: title, isChecked: false, details: detail))
        presenter?.creationSuccess( title, detail: detail)
    }
    
    func loadTodos() {
       ref.child("todos").observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
         //get the todos
        for child in snapshot.children.allObjects as? [DataSnapshot] ?? []{
            let title = child.key
            let value = child.value as? NSDictionary
            let isChecked = value?["isChecked"] as? Bool ?? false
            //let detail = value?["datail"] as? String ?? ""
            self?.todos.append(TodoItem(title: title, isChecked: isChecked))
        }

         }) { (error) in
           print(error.localizedDescription)
       }

        presenter?.fetchListSuccess(list: todos)
    }
    
    func retriveATodo(at index: Int) {
        if !validated(index: index) {return}
        //get detail
        DispatchQueue.global().async {
            self.ref.child("todos").child(self.todos[index].title).observeSingleEvent(of: .value, with: {
            [weak self] (snapshot) in
                let value = snapshot.value as? NSDictionary
                let detail = value?["datail"] as? String ?? ""
                self?.todos[index].details = detail
            }){ (error) in
                print(error.localizedDescription)
                }
                
        }
        DispatchQueue.main.async {
            self.presenter?.getItemSuccess(self.todos[index])
        }
    }
    
    func deleteATodo(at index: Int) {
        if !validated(index: index) {return}
        ref.child("todos").child(todos[index].title).removeValue()
        todos.remove(at: index)
        presenter?.deletionSuccess(at: index)
    }
    
    func editATodo(at index: Int, to title: String) {
        if !validated(index: index) {return}
        ref.child("todos").child(todos[index].title).setValue(["title": title]) { [weak self]
          (error:Error?, ref:DatabaseReference) in
          if let error = error {
            print("Data could not be saved: \(error).")
          } else {
            self?.todos[index].title = title
            print("Data saved successfully!")
            self?.presenter?.editSuccess(at: index, title: title)
          }
        }
    }
    
    func check(at index: Int) {
        if !validated(index: index) {return}
        ref.child("todos").child(todos[index].title).setValue(["isChecked": !todos[index].isChecked]) {[weak self]
          (error:Error?, ref:DatabaseReference) in
          if let error = error {
            print("Data could not be saved: \(error).")
          } else {
            self?.todos[index].isChecked = !(self?.todos[index].isChecked ?? false)
            self?.presenter?.checkSuccess(at: index)
            print("Data saved successfully!")
            
          }
        }
    }
    
    private func validated(index: Int)-> Bool{
        if  !todos.indices.contains(index) {
            self.presenter?.getItemFailure()
            return false
        }
        return true
    }
    
    
}


