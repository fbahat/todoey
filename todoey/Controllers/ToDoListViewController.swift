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
    let dataFieldPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("item.plist")
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
       
    
        loadData()
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
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true) // Bu komut ile beraber sectigimiz row yanip sonmektedir.
        
        savedItems()
    }
    
        
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()

        let alert = UIAlertController(title: "Add New To Do List", message: "" , preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (UIAlertAction) in
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
           self.savedItems()

        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            print(alertTextField.text)
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true  , completion: nil)
    
            self.savedItems()
    }
    func savedItems() {
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFieldPath!)
        } catch{
            print("Error var sanirim hele bi bak, \(error)")
        }
        self.tableView.reloadData()

    }
    func loadData() {       //Bu komut ile beraber listeye ekledigimiz butun hucreler save edilecektir.
        do {
            if let data = try? Data(contentsOf: dataFieldPath!){
                let decoder = PropertyListDecoder()
                itemArray = try decoder.decode([Item].self, from: data)
            }
    }
        catch{
            print(error)
        }
    }
}


