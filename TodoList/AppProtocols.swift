//
//  AppProtocols.swift
//  TodoList
//
//  Created by Blink22 on 7/27/20.
//  Copyright © 2020 Blink22. All rights reserved.
//

import Foundation
import UIKit

protocol ViewToPresenterListProtocol {
    var view: PresenterToViewListProtocol? { get set }
    var interactor: PresenterToInteractorListProtocol? { get set }
    var router: PresenterToRouterListProtocol? { get set }
    var todos: [TodoItem] { get set }
    func viewDidLoad()
    func numberOfRowsInSection() -> Int
    func textLabelText(indexPath: IndexPath) -> String?
    func didSelectRowAt(index: Int)
    func cellForRowAt(_ tableView: UITableView,  indexPath: IndexPath) -> UITableViewCell
    func deleteRowAt(index: Int)
    func didCheckRowAt(index: Int)
    func editRowAt(index: Int, to title: String)
    func addATodo(_ title: String, detail: String?)
}

protocol PresenterToViewListProtocol{
    func onFetchSuccess()
    func onFetchFailure(error: String)
    func onEditSuccess(at index: Int,to title: String)
    func toggle(at index: Int, _ isChecked: Bool)
    func onCreationSuccess(_ title: String, at index: Int)
    func onDeletionSuccess(at index: Int)
}

protocol PresenterToInteractorListProtocol {
    var presenter: InteractorToPresenterListProtocol? {get set}
    func loadTodos(completion: @escaping (_ message: String, _ todos: [TodoItem]) -> Void)
    func addATodo(_ title: String, detail: String?, isChecked: Bool?, index: Int?)
    func retriveATodo(at index: Int)
    func deleteATodo(at index: Int)
    func editATodo(at index: Int, to title: String)
    func check(at index: Int)
}

protocol PresenterToRouterListProtocol {
    static func createModule() -> ViewController
    func pushToDetail(on view: PresenterToViewListProtocol, with todoItem: TodoItem)
}

protocol InteractorToPresenterListProtocol{
    func fetchListSuccess(list: [TodoItem])
    func fetchListFailure(errorCode: Int)
    func getItemSuccess(_ todo: TodoItem)
    func getItemFailure()
    func checkSuccess(at index: Int)
    func editSuccess(at index: Int, title: String)
    func deletionSuccess(at index: Int)
    func creationSuccess(_ title: String, detail: String?, isChecked: Bool?, index: Int?)
}
