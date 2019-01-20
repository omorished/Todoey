//
//  ViewController.swift
//  Todoey
//
//  Created by Os! on 15/01/2019.
//  Copyright © 2019 Os!. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray : [Item] = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist") //our own local storage path
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print(dataFilePath!)
        
        
//        for index in 0...7 {
//            let object = Item()
//            
//            object.itemTitle = String(index)
//            itemArray.append(object)
//        }
        
        loadItem() //To grab data from Item.plist (local storage)
        
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
        
        cell.textLabel?.text = itemArray[indexPath.row].itemTitle
        
        //Turnary Operator:
        //value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = itemArray[indexPath.row].isChecked == true ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        print(itemArray[indexPath.row])
        
    itemArray[indexPath.row].isChecked = !itemArray[indexPath.row].isChecked
        
    saveItem()
        
    tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    //MARK: - Add New Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let itemObject = Item()
        
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert) //Main alert
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happen once the user clicks Add Item button on UIAlert
            
            if textField.text != "" {
            
            itemObject.itemTitle = textField.text!
                
            self.itemArray.append(itemObject)
                
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
        
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Encoder error is: \(error)")
        }
        
        
        self.tableView.reloadData() //Magic method that relaod and refresh the table view after adding a new item.
    }
    
    func loadItem() {
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            
            let decoder = PropertyListDecoder()
            
            do {
            itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Decoder error is: \(error)")
            }
        }
    }
    
    

}

