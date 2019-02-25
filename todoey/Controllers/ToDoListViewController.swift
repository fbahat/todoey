//
//  ViewController.swift
//  todoey
//
//  Created by Furkan Bahat on 22.02.2019.
//  Copyright © 2019 Furkan Bahat. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

        var itemArray =  [Item]()
        let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "Eggs"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Whatsapp"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Brother"
        itemArray.append(newItem3)
       

        
        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
                    itemArray = items}
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = itemArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        cell.accessoryType = item.done ? .checkmark : .none // if statement
        
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row])
        
        
        
        
        tableView.deselectRow(at: indexPath, animated: true) // Bu komut ile beraber sectigimiz row yanip sonmektedir.
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
}
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark

        }
    }
       
        
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()

        let alert = UIAlertController(title: "Add New To Do List", message: "" , preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (UIAlertAction) in
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            self.tableView.reloadData()
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            print(alertTextField.text)
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true  , completion: nil)
    
            
    }
    
    }
    


