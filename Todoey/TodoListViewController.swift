//
//  ViewController.swift
//  Todoey
//
//  Created by Os! on 15/01/2019.
//  Copyright © 2019 Os!. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray : [String] = [String]()
    
    var defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //To grab data from local storage , and if it is nil it will be crashed so we have to do if statement
        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
            
            itemArray = items
        }
        
    }
    
    //MARK: - TableView DataSource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    //MARK: - TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        print(itemArray[indexPath.row])
        
      
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            
              tableView.cellForRow(at: indexPath)?.accessoryType = .none
            
            }
        else {
            
             tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    //MARK: - Add New Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert) //Main alert
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happen once the user clicks Add Item button on UIAlert
            
            if textField.text != "" {
                
            self.itemArray.append(textField.text!)
                
            self.defaults.set(self.itemArray, forKey: "TodoListArray") //To save data inside the local storage
            
            self.tableView.reloadData() //Magic method that relaod and refresh the table view after adding a new item.
            
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
    
    

}

