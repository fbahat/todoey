//
//  CategoryTableViewController.swift
//  todoey
//
//  Created by Furkan Bahat on 2.03.2019.
//  Copyright © 2019 Furkan Bahat. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext //Data belleginin nerede oldugunu boyle buluyoruz.
        var categoryArray = [Category]()
            
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        print(context)

      
    }

   

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let items = categoryArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell")
        cell?.textLabel?.text = categoryArray[indexPath.row].name
        return cell!
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        tableView.deselectRow(at: indexPath, animated: true)
//        context.delete(categoryArray[indexPath.row])
//        categoryArray.remove(at: indexPath.row)
//        categorySavedItems()
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Yeni Kategori Ekleyiniz", message: "", preferredStyle: .alert)
        let action = UIAlertAction (title: "Add Item", style: .default) { (action) in
            
            let newItems = Category(context: self.context)
            newItems.name = textField.text!
            self.categoryArray.append(newItems)
        
            self.categorySavedItems()
            self.loadData()
            }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            print(alertTextField.text)
            textField = alertTextField
            
            alert.addAction(action)

            self.present(alert, animated: true  , completion: nil)
            self.categorySavedItems()
            self.loadData()
            
        }
    }
    func categorySavedItems() {
        
        do{
            try context.save()
        } catch{
            print("Error saving context 2233 \(error)")
        }
        self.tableView.reloadData()
}
    func loadData() {       //Bu komut ile beraber listeye ekledigimiz butun hucreler save edilecektir.
        let request : NSFetchRequest<Category>  = Category.fetchRequest()
        do{
            categoryArray =  try context.fetch(request) }
        catch
        {
            print("Sanirim burada hata var hatanin adi \n(error)")
        }
    }
}
