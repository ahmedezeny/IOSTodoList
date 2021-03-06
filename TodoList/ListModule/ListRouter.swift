//
//  ListRouter.swift
//  TodoList
//
//  Created by Blink22 on 7/27/20.
//  Copyright © 2020 Blink22. All rights reserved.
//

import Foundation
import UIKit

struct ListRouter: PresenterToRouterListProtocol {
    
    
    static func createModule() -> ViewController {
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = (storyboard.instantiateViewController(withIdentifier: "VC") as? ViewController){
            let presenter: ViewToPresenterListProtocol & InteractorToPresenterListProtocol = ListPresenter()
            
            viewController.presenter = presenter
            viewController.presenter?.router = ListRouter()
            viewController.presenter?.view = viewController
            viewController.presenter?.interactor = ListInteractor()
            viewController.presenter?.interactor?.presenter = presenter
            
            return viewController
        }
        return ViewController()
        
    }
    
    func pushToDetail(on view: PresenterToViewListProtocol, with todoItem: TodoItem, at index: Int) {
        let detailViewController = DetailRouter.createModule(with: todoItem, at: index)
        
        //let storyboard = UIStoryboard(name: "Detailed", bundle: nil)

        //if let detailedVC = (storyboard.instantiateViewController(withIdentifier: "Detail") as? detailViewController){
               //prepareVC here
            
        if let navC = view.getNavController(){
            navC.pushViewController(detailViewController, animated: true)
        }
                
        //}
        //let viewController = view as! DetailViewController
        
    }
    

}


