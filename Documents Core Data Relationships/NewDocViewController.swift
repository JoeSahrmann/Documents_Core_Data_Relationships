//
//  NewDocViewController.swift
//  Documents Core Data Relationships
//
//  Created by Joe Sahrmann on 9/28/20.
//

import UIKit

class NewDocViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var contentTF: UITextView!
   
    var category: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameTF.delegate = self
        contentTF.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameTF.resignFirstResponder()
        contentTF.resignFirstResponder()
    }
    
    @IBAction func saveExpense(_ sender: Any) {
        let name = nameTF.text
        let content = contentTF.text
        let size = Int64(contentTF.text.count)
        let date = Date()
        
        if let doc = Document(name: name,content: content, size: size, date: date){
            category?.addToRawDocument(doc)
            do{
                try doc.managedObjectContext?.save()
                
                self.navigationController?.popViewController(animated: true)
            }catch{
                print("could not save")
            }
        }
    }
}

extension NewDocViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
