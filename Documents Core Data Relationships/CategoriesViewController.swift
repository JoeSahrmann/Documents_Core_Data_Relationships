//
//  CategoriesViewController.swift
//  Documents Core Data Relationships
//
//  Created by Joe Sahrmann on 9/28/20.
//

import UIKit
import CoreData

class CategoriesViewController: UIViewController {
   
    @IBOutlet weak var categoriesTV: UITableView!
    
    var categories: [Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        
        do{
            categories = try managedContext.fetch(fetchRequest)
            categoriesTV.reloadData()
        }catch{
            print("could not fetch")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? DocumentsViewController, let selectedRow = self.categoriesTV.indexPathForSelectedRow?.row else{
            return
        }
        destination.category = categories[selectedRow]
    }
    func deletCategory(at indexPath: IndexPath){
        let category = categories[indexPath.row]
        guard  let managedContext = category.managedObjectContext else{
            return
        }
        managedContext.delete(category)
        
        do{
            try managedContext.save()
            categories.remove(at: indexPath.row)
            categoriesTV.deleteRows(at: [indexPath], with: .automatic)
        }catch{
            print("could not delete")
            categoriesTV.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}

extension CategoriesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoriesTV.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        let category = categories[indexPath.row]
        cell.textLabel?.text = category.title
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            deletCategory(at: indexPath)
        }
    }
}
