//
//  ViewController.swift
//  todoey
//
//  Created by Furkan Bahat on 22.02.2019.
//  Copyright © 2019 Furkan Bahat. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext// Data bellegimizin yolunu buradan acmis bulunduk. Kullanacagimiz data bellek. Belgelerin savelenmesi icin

        var itemArray =  [Item]()
    
    var selectedCategory : Category? {
        didSet {
            loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
         print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
            
        
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
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)// Bu komut ile beaber row a bastigimizda item silinmektedir.
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true) // Bu komut ile beraber sectigimiz row yanip sonmektedir.
        
        savedItems()
    }
    
        
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()

        let alert = UIAlertController(title: "Add New To Do List", message: "" , preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (UIAlertAction) in
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
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
        
        do{
           try context.save()
        } catch{
            print("Error saving context 2233 \(error)")
        }
        self.tableView.reloadData()

    }
    func loadData() {       //Bu komut ile beraber listeye ekledigimiz butun hucreler save edilecektir.
        let request : NSFetchRequest<Item>  = Item.fetchRequest()
        
        do{
           itemArray =  try context.fetch(request) }
        catch
        {
            print("Sanirim burada hata var hatanin adi \n(error)")
        }
    }
}
// Search bar methods
extension ToDoListViewController : UISearchBarDelegate  {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title Contains[cd] %@", searchBar.text!)
        request.predicate = predicate
        let sortDescprt = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescprt]
        loadData()
        do{
            itemArray =  try context.fetch(request) }
        catch
        {
            print("Sanirim burada hata var hatanin adi \n(error)")
        }
        tableView.reloadData()
        func searchBar(_: UISearchBar, textDidChange: String){ // Bu komut ile beraber search kismini sildigimizde tekrardan datayi geri toplanmasi saglaniyor.
            if searchBar.text?.count == 0 {
                loadData()
                DispatchQueue.main.async {
                    searchBar.resignFirstResponder()
                    }
            }
        }
    }
    
}

