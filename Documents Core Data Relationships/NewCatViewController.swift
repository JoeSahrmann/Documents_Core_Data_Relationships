//
//  NewCatViewController.swift
//  Documents Core Data Relationships
//
//  Created by Joe Sahrmann on 9/28/20.
//

import UIKit

class NewCatViewController: UIViewController {


   
    @IBOutlet weak var titleTF: UITextField!
    
    var existingCat: Category?
    override func viewDidLoad() {
        super.viewDidLoad()

        titleTF.delegate = self
        titleTF.text = existingCat?.title
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        titleTF.resignFirstResponder()
    }
    
    @IBAction func saveCategory(_ sender: Any) {
        //let category = Category(title: titleTF.text ?? "")
        let title = titleTF.text  ?? ""
        var categor: Category?
        if let existinCat = existingCat{
            existinCat.title = title
            categor = existinCat
        }else{
            categor = Category(title: title)
        }
        if let category = categor{
        do{
            try category.managedObjectContext?.save()
            self.navigationController?.popViewController(animated: true)
        }catch{
            print("could not save category!")
        }
        }
    }
}

extension NewCatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
