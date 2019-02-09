//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Os! on 24/01/2019.
//  Copyright © 2019 Os!. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    
    let realm = try! Realm()

    var categories: Results<Category>? //it is auto-update countainer

    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategory()
        
    }
    
    
    //MARK: - TableView Datasource Mesthods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1 //it called nil coallescing operator which means, if it is not nil return categories.count but if it is nil return 1
  
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet!"
        
        
        return cell
            }
    
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
       
            
            let destenationVC = segue.destination as! TodoListViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                
                destenationVC.selectedCategory = categories?[indexPath.row]
                
                
            }
     
        
    }
    
    

    //MARK: - Add New Category
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            if textField.text != "" {
                
                let newCategory = Category()
                newCategory.name = textField.text!
//                self.categories.append(newCategory) //no need for this because the category virable is of Result datatype which is auto-updated countainer
                
                self.save(category: newCategory)
            }
            
            
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
         self.present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - Manapulation Methods
    
    func save(category: Category) {
        
        do {
           try realm.write {
                realm.add(category)
            }
        } catch {
            print(error)
        }
        
     tableView.reloadData()
    }
    
    
    func loadCategory() {

         categories = realm.objects(Category.self)
        
        tableView.reloadData()
        
    }
    
    

}

//0555103416 .. 684
