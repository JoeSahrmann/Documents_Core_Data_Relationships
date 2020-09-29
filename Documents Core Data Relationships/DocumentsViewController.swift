//
//  DocumentsViewController.swift
//  Documents Core Data Relationships
//
//  Created by Joe Sahrmann on 9/28/20.
//

import UIKit

class DocumentsViewController: UIViewController {
    //@IBOutlet weak var expensesTableView: UITableView!
    @IBOutlet weak var documentsTV: UITableView!
    
    var category: Category?
    
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.timeStyle = .long
        dateFormatter.dateStyle = .long

    }
    override func viewWillAppear(_ animated: Bool) {
        self.documentsTV.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addNewExpense(_ sender: Any) {
        performSegue(withIdentifier: "Title", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? NewDocViewController
        else{
            return
        }
        destination.category = category
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
        if let document = category?.documents?[indexPath.row]{
            cell.textLabel?.text = document.name
            if let date = document.date{
                cell.detailTextLabel?.text = dateFormatter.string(from:date)
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
        performSegue(withIdentifier: "Title", sender: self)
    }
}


