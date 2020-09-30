//
//  DocumentsViewController.swift
//  Documents Core Data Relationships
//
//  Created by Joe Sahrmann on 9/28/20.
//
import CoreData
import UIKit

class DocumentsViewController: UIViewController {
    //@IBOutlet weak var expensesTableView: UITableView!
    @IBOutlet weak var documentsTV: UITableView!
    
    var category: Category?
    var documentz = [Document]()
    
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.timeStyle = .long
        dateFormatter.dateStyle = .long
        title = category?.title
        

    }
    override func viewWillAppear(_ animated: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Document> = Document.fetchRequest()
        do {
            documentz = try managedContext.fetch(fetchRequest)
           
            self.documentsTV.reloadData()
            
        }catch{
            print("fetch failed")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addNewDoc(_ sender: Any) {
        performSegue(withIdentifier: "newDocument", sender: self)
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? NewDocViewController
        else{
            return
        }
        destination.category = category
      
       // let see if this is right
//        if segue.identifier == "selectedDocument" {
//            guard let destination = segue.destination as? NewDocViewController,
//               let row = self.documentsTV.indexPathForSelectedRow?.row else{
//                return
//                }
//            destination.document = documentz[row]
//        }
    }
    func deleteDoc(at indexPath: IndexPath){
        guard let document = category?.documents?[indexPath.row], let managedContext = document.managedObjectContext else {
            return
        }
        managedContext.delete(document)
        do{
            try managedContext.save()
            
            documentsTV.deleteRows(at: [indexPath], with: .automatic)
        }catch{
            print("could not delete")
            documentsTV.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}

extension DocumentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category?.documents?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = documentsTV.dequeueReusableCell(withIdentifier: "docCell", for: indexPath)
        if let cell = cell as? DocumentsTableViewCell,
        let document = category?.documents?[indexPath.row]{
            cell.nameLabel?.text = document.name
            cell.sizeLabel?.text = String(document.size ?? 0) + " bytes"
            if let date = document.date{
                cell.dateLabel?.text = dateFormatter.string(from:date)
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            deleteDoc(at: indexPath)
        }
    }
}

extension DocumentsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         performSegue(withIdentifier: "newDocument", sender: self)
                  
    }
  
}


