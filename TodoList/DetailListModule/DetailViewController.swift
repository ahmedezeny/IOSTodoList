//
//  DetailViewController.swift
//  TodoList
//
//  Created by Blink22 on 7/27/20.
//  Copyright © 2020 Blink22. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var presenter : ViewToPresenterListProtocol?
    var todoItem : TodoItem?
    var index: Int?
    
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var detailTF: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        title = "Details"
        self.navigationController?.navigationBar.prefersLargeTitles = true
            // Do any additional setup after loading the view.
        setTFs()
        
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editItem))
        
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func check(_ sender: UIButton) {
      //  presenter?.didCheckRowAt(index: index!)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    
    private func setTFs(){
        titleTF.text = todoItem?.title
        detailTF.text = todoItem?.details
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DetailViewController : PresenterToViewListProtocol {
    func onFetchSuccess() {
        
    }
    
    func onFetchFailure(error: String) {
        
    }
    
    func onEditSuccess(at index: Int, to title: String) {
        
    }
    
    func toggle(at index: Int, _ isChecked: Bool) {
        
    }
    
    func onCreationSuccess(_ title: String, at index: Int) {
        
    }
    
    func onDeletionSuccess(at index: Int) {
        
    }
    
    func getNavController() -> UINavigationController? {
        return self.navigationController
    }
    

}


