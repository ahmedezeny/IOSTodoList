//
//  ListInteractor.swift
//  TodoList
//
//  Created by Blink22 on 7/27/20.
//  Copyright © 2020 Blink22. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

class ListInteractor: PresenterToInteractorListProtocol {
    
    
    var presenter: InteractorToPresenterListProtocol?
    var todos : [TodoItem] = []
    
    private var ref = Database.database().reference()
    
    func addATodo(_ todoItem:TodoItem) {
        
        self.ref.child("todos").child(todoItem.id).updateChildValues(["title": todoItem.title,"detail": todoItem.details ?? "", "isChecked": false])
        
        todos.append(todoItem)
        
        presenter?.creationSuccess(todoItem)
    }
    
    func addAnImage(at index: Int, image: UIImage){
        let storage = Storage.storage()

        // Create a storage reference from our storage service
        let storageRef = storage.reference().child("images/\(todos[index].id)")
        if let data = image.pngData(){
            let uploadMetadata = StorageMetadata.init()
            uploadMetadata.contentType = "image/jpeg"
            storageRef.putData(data, metadata: nil) { (metaData, error) in
                if error != nil {
                    print(error ?? "error uploading the image")
                    return
                }
                storageRef.downloadURL { (url, error) in
                    if let error = error  {
                        print("error accessing photo \(error)")
                        return
                    }
                    
                    if let url = url {
                        print(url)
                        self.ref.child("todos").child(self.todos[index].id).updateChildValues(["imageURL": url.absoluteString])
                        self.todos[index].imageURL = url.absoluteString
                        self.presenter?.addAnImageSuccess(at: index, with: url)
                    }
                    
                }
            }
        }
        
        //var spaceRef = storageRef.child("images/space.jpg")
            
    }
    
    func loadTodos(completion: @escaping (_ message: String, _ todos: [TodoItem]) -> Void) {
        DispatchQueue.global().async {
            
        
            self.ref.child("todos").observeSingleEvent(of: .value){ (snapshot) in
             //get the todos
                var counter = 0
                self.todos = []
                for child in snapshot.children.allObjects as! [DataSnapshot]{
                    
                    let id = child.key
                    let todoRef = self.ref.child("todos").child(id)
                    
                    counter += 1
                    todoRef.observeSingleEvent(of: .value, with: { (todoSnapshot) in
                        let value = todoSnapshot.value as? NSDictionary
                        let title = value!["title"] as? String
                        let isChecked = value!["isChecked"] as? Bool
                        let detail = value!["detail"] as? String
                        let imageURL = value!["imageURL"] as? String
                        self.todos.append(TodoItem(title: title!, isChecked: isChecked!, detail: detail, id: id, imageURL: imageURL))
                        counter -= 1
                        if counter == 0{
                            completion("success", self.todos)
                        }
                    })

                }
                
                //self.presenter?.fetchListSuccess(list: self.todos)
                
             }
        }
        
    }
    
    func retriveATodo(at index: Int) {
        if !validated(index: index) {return}
        //get detail
//        DispatchQueue.global().async {
//            self.ref.child("todos").child(self.todos[index].title).observeSingleEvent(of: .value, with: {
//            [weak self] (snapshot) in
//                let value = snapshot.value as? NSDictionary
//                let detail = value?["datail"] as? String ?? ""
//                self?.todos[index].details = detail
//            }){ (error) in
//                print(error.localizedDescription)
//                }
//
//        }
//        DispatchQueue.main.async {
        self.presenter?.getItemSuccess(self.todos[index], index: index)
 //       }
    }
    
    func deleteATodo(at index: Int) {
        if !validated(index: index) {return}
        let todo = todos[index].id
        ref.child("todos").child(todo).removeValue()
        todos.remove(at: index)
        presenter?.deletionSuccess(at: index)
    }
    
    func editATodo(at index: Int, to title: String, detail: String?) {
        if !validated(index: index) {return}
        

        ref.child("todos").child(todos[index].id).updateChildValues(["title": title, "detail": detail ?? ""]) { [weak self]
          (error:Error?, ref:DatabaseReference) in
          if let error = error {
            print("Data could not be saved: \(error).")
          } else {
            self?.todos[index].title = title
            self?.todos[index].details = detail
            print("Data saved successfully!")
            self?.presenter?.editSuccess(at: index, title: title, detail: detail)
          }
        }
        //self.presenter?.editSuccess(at: index, title: title, detail: )
    }
    
    func check(at index: Int, completion: @escaping (_ message: String) -> Void) {
        if !validated(index: index) {return}
        ref.child("todos").child(todos[index].id).updateChildValues(["isChecked": !todos[index].isChecked]) {[weak self]
          (error:Error?, ref:DatabaseReference) in
          if let error = error {
            print("Data could not be saved: \(error).")
          } else {
            self?.todos[index].isChecked = !(self?.todos[index].isChecked ?? false)
            completion("success")
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


