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
    var catArray = [Category]()
    var cat: Category?
    
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
        if segue.identifier == "NewCategory" {
                   guard let destination = segue.destination as? NewCatViewController,
                      let row = self.categoriesTV.indexPathForSelectedRow?.row else{
                       return
                       }
                   destination.existingCat = categories[row]
               }
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
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "NewCategory", sender: self)
//    }
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete{
//            deletCategory(at: indexPath)
//    }
//    }
    
     func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
      //this is the first swipe action that is created to let the user choose to delet or edit
        let action = UIContextualAction(style: .normal, title: "Delete/Edit") { (action, view, completion) in
            //this is where the action sheet controler is created to pop either delet or edit
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            //first action is added eddit
            alert.addAction(UIAlertAction(title: "Edit", style: .default) { (action) in
               //this should take you to the screen to edit the title
                self.performSegue(withIdentifier: "NewCategory", sender: self)
            })
            //this adds the delet action
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { (action) in
                
                if self.categories[indexPath.row].documents?.count ?? 0 > 0{
                    //this is where the confirmation is made if it has more than 0 documents
                    let confirm = UIAlertController(title: "Are You Sure", message: "There are \(String(self.categories[indexPath.row].documents?.count ?? 0)) Documents in \(String(describing: self.categories[indexPath.row].title ?? ""))", preferredStyle: .actionSheet)
                    //to cancle the deletion
                confirm.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (UIAlertAction) in
                    completion(true)
                }))
                    //go through with the deletion
                confirm.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (UIAlertAction) in
                    self.deletCategory(at: indexPath)
                }))
                    self.present(confirm, animated: true, completion: nil)

                }else{
                    self.deletCategory(at: indexPath)
                }
            })

            // This sets up the alert to show next to the button
            alert.popoverPresentationController?.sourceView = view
            alert.popoverPresentationController?.sourceRect = view.bounds

            self.present(alert, animated: true, completion: nil)
                    }

        return UISwipeActionsConfiguration(actions: [action])
    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "NewCategory", sender: self)
//    }
}
