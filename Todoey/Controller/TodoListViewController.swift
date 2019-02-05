//
//  ViewController.swift
//  Todoey
//
//  Created by Os! on 15/01/2019.
//  Copyright © 2019 Os!. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray : [Item] = [Item]()
    
    var selectedCategory : Category?
    
    var num  = 5
    //4:30 , section 19 , lecture 261
//    var selectedCategory : Category? {
//        didSet{
//
//        }
//    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)) //our own local storage path)
        
        loadItem()
        
//        for index in 0...7 {
//            let object = Item()
//            
//            object.itemTitle = String(index)
//            itemArray.append(object)
//        }
        
        
        
        //To grab data from local storage , and if it is nil it will be crashed so we have to do if statement
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//
//            itemArray = items
//        }
        
    }
    
    //MARK: - TableView DataSource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        //Turnary Operator:
        //value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = itemArray[indexPath.row].done == true ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        print(itemArray[indexPath.row])
        
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
    itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
    saveItem()
        
//    tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    //MARK: - Add New Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert) //Main alert
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happen once the user clicks Add Item button on UIAlert
            
            let newItem = Item(context: self.context)
            
            if textField.text != "" {
            
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory //because we accossiated in the DataModel
            
                
            self.itemArray.append(newItem)
                
           self.saveItem()
            
        } //The button of alert
            
            }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create New Item"
            
            textField = alertTextField //because alertTextField is local virable and we want to use it globally
            
        }
        
        alert.addAction(action)

        //show AlertViewController
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Method Manupulation Method
    
    func saveItem() { //To save item into Item.plist file
        
        do {
          try context.save()
        } catch {
           print("Error saving context \(error)")
        }
        
        
        self.tableView.reloadData() //Magic method that relaod and refresh the table view after adding a new item.
    }
    
    func loadItem(with request: NSFetchRequest<Item> = Item.fetchRequest() , predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES%@", selectedCategory!.name!)

        if let additionalPredicate = predicate {
            
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalPredicate, categoryPredicate])
            
            request.predicate = compoundPredicate
        } else {
            
            request.predicate = categoryPredicate
        }
                
        do {
        itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from persistent container \(error)")
        }
        
        tableView.reloadData()
    }
    
    

}

//MARK: - SearchBar Mesthods
extension TodoListViewController: UISearchBarDelegate {
    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//        
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        
//        
//        request.predicate = predicate
//        
//        let sortDiscriptor  = NSSortDescriptor(key: "title", ascending: true)
//        
//        request.sortDescriptors = [sortDiscriptor]
//        
//        
//        loadItem(with: request)
//        
//        
//    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) { //This method is not going to called when the app is begi running because the search bar is not changed yet.
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
        
        if searchBar.text?.count != 0 {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
    
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        
        loadItem(with: request , predicate: predicate)
        }
        else {
            loadItem()
            
            DispatchQueue.main.async {
                  searchBar.resignFirstResponder() //To make keyboard and everything go away

            } //make this part of code in higest priority and move it to the first one in the queue
          
        }
        
    }
}

