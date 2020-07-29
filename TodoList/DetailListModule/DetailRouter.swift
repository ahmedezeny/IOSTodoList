//
//  DetailRouter.swift
//  TodoList
//
//  Created by Blink22 on 7/28/20.
//  Copyright © 2020 Blink22. All rights reserved.
//

import Foundation
import UIKit

class DetailRouter{
    static func createModule(with todoItem: TodoItem) -> UIViewController{
        let storyboard = UIStoryboard(name: "Detailed", bundle: nil)

        if let viewController = (storyboard.instantiateViewController(withIdentifier: "Detail") as? DetailViewController){
               let presenter: ViewToPresenterListProtocol & InteractorToPresenterListProtocol = ListPresenter()
               //todo
//               viewController.presenter = presenter
//               viewController.presenter?.router = ListRouter()
//               viewController.presenter?.view = viewController
//               viewController.presenter?.interactor = ListInteractor()
//               viewController.presenter?.interactor?.presenter = presenter
               
               return viewController
        }
        return ViewController()
    }
}
