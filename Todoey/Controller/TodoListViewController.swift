//
//  ViewController.swift
//  Todoey
//
//  Created by Os! on 15/01/2019.
//  Copyright © 2019 Os!. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    var todoItems : Results<Item>?
    let realm = try! Realm()
    
    
    //4:30 , section 19 , lecture 261
    var selectedCategory : Category? {
        didSet{

            loadItem()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //loadItem()
        
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
        
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            //Turnary Operator:
            //value = condition ? valueIfTrue : valueIfFalse
            cell.accessoryType = item.done == true ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Item Added Yet!"
        }
      
        
        return cell
    }
    
    //MARK: - TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        if let item = todoItems?[indexPath.row] {
            do {
            try realm.write {
//                realm.delete(item)
                item.done = !item.done
            }
            } catch {
                print("Error for updating item \(error)")
            }
        }
        
        tableView.reloadData() //to call override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell (AGAIN!)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    //MARK: - Add New Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert) //Main alert
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happen once the user clicks Add Item button on UIAlert
            
            if textField.text != "" {
                
                if let currentCategory = self.selectedCategory {

        do {
            try self.realm.write {
                let newItem = Item()
                newItem.title = textField.text!
                newItem.done = false
                newItem.dateCreated? = Date()
                currentCategory.items.append(newItem)
            }
           
            } catch {
                     print("Error for adding a new item")
            }
                    
                    self.tableView.reloadData()
                   
                }
              
            }
            
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
    
  
    func loadItem() {

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true) //as you can see it is List for Relationship

        tableView.reloadData()
    }

    
    }


//MARK: - SearchBar Mesthods
extension TodoListViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) { //This method is not going to called when the app is begi running because the search bar is not changed yet.
        
        if searchBar.text?.count != 0 {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        }
        else {
            loadItem()
            DispatchQueue.main.async {
            searchBar.resignFirstResponder() //To make keyboard and everything go away
            }
        }
    }

}



//0570416640

