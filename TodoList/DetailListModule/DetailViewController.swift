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
    
    @IBOutlet weak var checkButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        title = "Details"
        self.navigationController?.navigationBar.prefersLargeTitles = true
            // Do any additional setup after loading the view.
        setTFs()
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editItem))
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if todoItem!.isChecked{
            checkButton.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            checkButton.setTitle("UnCheck", for: .normal)
        }
        
    }
    
    
    
    @IBAction func check(_ sender: UIButton) {
        presenter?.didCheckRowAt(index: index!)
        
    }
    
    @objc private func editItem(){
        presenter?.editRowAt(index: index!, to: titleTF.text!, detail: detailTF.text)
    }
    
    
    
    private func setTFs(){
        titleTF.text = todoItem?.title
        detailTF.text = todoItem?.details
    }
    

}

extension DetailViewController : PresenterToViewListProtocol {
    func onFetchSuccess() {
        
    }
    
    func onFetchFailure(error: String) {
        
    }
    
    func onEditSuccess(at index: Int, to title: String) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func toggle(at index: Int, _ isChecked: Bool) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func onCreationSuccess(_ title: String, at index: Int) {
        
    }
    
    func onDeletionSuccess(at index: Int) {
        
    }
    
    func getNavController() -> UINavigationController? {
        return self.navigationController
    }
    

}


