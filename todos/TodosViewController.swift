//
//  ViewController.swift
//  todos
//
//  Created by Wang Pin <guyusay@gmail.com> on 2021/8/6.
//

import UIKit
import os.log
import CoreData

class TodosViewController: UITableViewController {
    
    var allItems = [Item]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var items: [Item] {
        allItems.filter {$0.finished_at == nil}
    }
    
    lazy var container = NSPersistentContainer(name: "todos")
    
    lazy var fetchedResultsController: NSFetchedResultsController<Item> = {
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "created_at", ascending: true)]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: container.viewContext,
                                                    sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        
        do {
            try controller.performFetch()
        }
        catch {
            fatalError("###\(#function): Failed to performFetch: \(error)")
        }
        
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.allItems = fetchedResultsController.fetchedObjects ?? []
        // Do any additional setup after loading the view.
    }
    
    func addItem(content: String) {
        let id = UUID()
        let item = Item(context: container.viewContext)
        item.id = id
        item.content = content
        item.created_at = Date()
        try! container.viewContext.save()
    }
    
    //Not sure if delete a todo item is reasonable
    func removeItem(_ item: Item) {
        container.viewContext.delete(item)
        try! container.viewContext.save()
    }
    
    func updateItem(_ item: Item) {
        if container.viewContext.hasChanges {
            try! container.viewContext.save()
        }
    }
    
    @IBAction func unwindToItemList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? NewItemViewController {
            if sourceViewController.content != nil {
                self.addItem(content: sourceViewController.content!)
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentitifier = "todocell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentitifier, for: indexPath) as? TodoCell else {
            fatalError("The dequeued cell is not an instance of TodoViewCell.")
        }
       
        cell.configure(items[indexPath.row])
        
        return cell
    }
    

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        
        switch (segue.identifier) {
        case "AddItem":
            os_log("To Add item", log: OSLog.default, type: .debug)
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
}

extension TodosViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        do {
            try self.fetchedResultsController.performFetch()
            guard self.fetchedResultsController.fetchedObjects != nil else {
                return
            }
            self.allItems = (self.fetchedResultsController.fetchedObjects)!
        } catch {
            fatalError("###\(#function): Failed to performFetch: \(error)")
        }
        
    }
}

extension TodosViewController {
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let item = items[indexPath.row]

        let doneAction = UIContextualAction(style: .normal, title: "Done") { (action, view, bool) in
            item.finished_at = Date()
            self.updateItem(item)
        }
        doneAction.backgroundColor = UIColor.green

        return UISwipeActionsConfiguration(actions: [doneAction])
    }
}

