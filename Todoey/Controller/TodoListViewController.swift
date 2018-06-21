//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Abhishek on 6/12/18.
//  Copyright © 2018 Abhishek Banerji. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    var itemArray = [Item]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath!)
        
        loadItems()
     
    }

    // MARK: - Datasource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = itemArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListItemCell", for: indexPath)
        cell.textLabel?.text = item.title
    
        
        
        cell.accessoryType = item.done ? .checkmark : .none
    
        return cell
    }
    
    //MARK: - Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    
        let item = itemArray[indexPath.row]
    
        item.done = !item.done
        
        self.saveData()
    
    }
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
        let newItem = Item(context: self.context)
            
        newItem.title = textField.text!
        newItem.done = false
            
        self.itemArray.append(newItem)
            
        self.saveData()
    }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            field.placeholder = "Enter New Item"
            textField = field
            
        }
        
        present(alert, animated: true, completion: nil)
        
    
    }
    
    func saveData() {
       
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest()) {

        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error")
        }
        
        tableView.reloadData()
    }
    
    
    
    
}

//MARK - SearchBar Delegate functions

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        print("extension")
        
        loadItems(with: request)
        
        searchBar.resignFirstResponder()
        
        print("resign")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
           
            
            print("resign")
        }
    }
    
}

/*

 How to delete from database:
 
 context.delete(itemArray[indexPath.row]
 itemArray.remove(at: indexPath.row)

*/

