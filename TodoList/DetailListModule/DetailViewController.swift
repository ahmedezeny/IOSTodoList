//
//  DetailViewController.swift
//  TodoList
//
//  Created by Blink22 on 7/27/20.
//  Copyright © 2020 Blink22. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var presenter : ViewToPresenterListProtocol?
    var todoItem : TodoItem?
    var index: Int?
    
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var detailTF: UITextView!
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var checkButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        title = "Details"
        self.navigationController?.navigationBar.prefersLargeTitles = true
            // Do any additional setup after loading the view.
        setTFs()
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editItem))
        let addImg = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(addImage))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbarItems = [addImg,spacer]
        navigationController?.isToolbarHidden = false
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
    
    @objc private func addImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
            picker.sourceType = .camera
        }else{
            picker.sourceType = .photoLibrary
        }
        picker.allowsEditing = true
           
        self.present(picker, animated: true, completion: nil)
    }
    
    
    private func setTFs(){
        titleTF.text = todoItem?.title
        detailTF.text = todoItem?.details
        image.load(url: URL(string: (todoItem?.imageURL ?? "")))
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }

        // print out the image size as a test
        print(image.size)
        presenter?.addAnImage(at: index!, image: image)
    }

}

extension DetailViewController : PresenterToViewListProtocol {
    func onAddImageSuccess(with url: URL) {
        todoItem?.imageURL = url.absoluteString
        self.setTFs()
    }
    
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

extension UIImageView {
    func load(url: URL?) {
        DispatchQueue.global().async { [weak self] in
            guard let imgUrl = url else {return}
            if let data = try? Data(contentsOf: imgUrl) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}


