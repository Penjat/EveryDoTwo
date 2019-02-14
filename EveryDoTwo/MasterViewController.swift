

import UIKit
import CoreData

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate {

  var detailViewController: DetailViewController? = nil
  var managedObjectContext: NSManagedObjectContext? = nil
  var currentTheme = Theme.Rainbow
  

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    navigationItem.leftBarButtonItem = editButtonItem

    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(openAlert(_:) ))
    //navigationItem.rightBarButtonItem = addButton
    
    let themeButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(openThemesAlert(_:) ))
    navigationItem.rightBarButtonItems = [addButton,themeButton]
    
    if let split = splitViewController {
        let controllers = split.viewControllers
        detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
    }
    //TODO get from user prefs
    currentTheme = getTheme(int: UserDefaults.standard.integer(forKey: "userTheme"))
    
    self.tableView.backgroundColor = currentTheme.getColor(uiType: UIType.Background)
    
  }
  func getTheme(int:Int) -> Theme{
    switch (int){
    case 0:
      return Theme.Dark
    case 1:
      return Theme.Light
    case 2:
      return Theme.Rainbow
    case 3:
      return Theme.Brown
    default :
      return Theme.Light
    }
    
  }
  @objc
  func openThemesAlert(_ sender: Any){
    print("opening themes")
    //    insertNewObject(_:)
    let alertController = UIAlertController(title: "Select Theme", message: "", preferredStyle: .alert)
    
    
    let darkTheme = UIAlertAction(title: "Dark", style: .default) { (_) in
      self.setTheme(theme: Theme.Dark)
    }
    let lightTheme = UIAlertAction(title: "Light", style: .default) { (_) in
      self.setTheme(theme: Theme.Light)
    }
    let rainbowTheme = UIAlertAction(title: "Rainbow", style: .default) { (_) in
      self.setTheme(theme: Theme.Rainbow)
    }
    let brownTheme = UIAlertAction(title: "Brown", style: .default) { (_) in
      self.setTheme(theme: Theme.Brown)
    }
    
    alertController.addAction(darkTheme)
    alertController.addAction(lightTheme)
    alertController.addAction(rainbowTheme)
    alertController.addAction(brownTheme)
    
    self.present(alertController, animated: true) {
      // ...
    }
  }
  @objc
  func openAlert(_ sender: Any){
    print("opening alert")
//    insertNewObject(_:)
    let alertController = UIAlertController(title: "New ToDo", message: "", preferredStyle: .alert)
    
    
    let createTodo = UIAlertAction(title: "Create", style: .default) { (_) in
      let titleTextField = alertController.textFields![0] as! UITextField
      let descriptionTextField = alertController.textFields![1] as! UITextField
      
      let todoData = (title:titleTextField.text , todoDescription:descriptionTextField.text)
      
      self.insertNewObject(todoData)
      //login(loginTextField.text, passwordTextField.text)
    }
    createTodo.isEnabled = false
    
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
    
    alertController.addTextField { (textField) in
      textField.placeholder = UserDefaults.standard.string(forKey: "todoTitle")
      
      NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main) { (notification) in
        createTodo.isEnabled = textField.text != ""
      }
    }
    
    alertController.addTextField { (textField) in
      textField.placeholder = UserDefaults.standard.string(forKey: "todoDescription")
      
    }
    
    alertController.addAction(createTodo)
    alertController.addAction(cancelAction)
    
    self.present(alertController, animated: true) {
      // ...
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
    super.viewWillAppear(animated)
  }

  @objc
  func insertNewObject(_ sender: (Any)) {
    
    let todoData = sender as! (title:String! , todoDescription:String!)
    print("inserting new object \(todoData.title)")
    
    let context = self.fetchedResultsController.managedObjectContext
    let newToDo = ToDo(context: context)
         
    // If appropriate, configure the new managed object.
    newToDo.title = todoData.title!
    newToDo.todoDescription = todoData.todoDescription!
    newToDo.isCompleted = false
    // Save the context.
    do {
        try context.save()
    } catch {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    }
  }

  // MARK: - Segues

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showDetail" {
        if let indexPath = tableView.indexPathForSelectedRow {
        let object = fetchedResultsController.object(at: indexPath)
            let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
            controller.detailItem = object
            controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            controller.navigationItem.leftItemsSupplementBackButton = true
        }
    }
  }

  // MARK: - Table View

  override func numberOfSections(in tableView: UITableView) -> Int {
    return fetchedResultsController.sections?.count ?? 0
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let sectionInfo = fetchedResultsController.sections![section]
    return sectionInfo.numberOfObjects
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    let todo = fetchedResultsController.object(at: indexPath)
    configureCell(cell, withToDo: todo)
    return cell
  }

  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
  }

  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
        let context = fetchedResultsController.managedObjectContext
        context.delete(fetchedResultsController.object(at: indexPath))
            
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
  }
  func setTheme(theme:Theme){
    currentTheme = theme
    
    self.tableView.backgroundColor = currentTheme.getColor(uiType: UIType.Background)
    tableView.reloadData()
    UserDefaults.standard.set(currentTheme.toInt(), forKey: "userTheme")
  }
  func configureCell(_ cell: UITableViewCell, withToDo event: ToDo) {
    let isDoneString = event.isCompleted ? "☑︎" : "◻︎"
    cell.textLabel!.text = "\(isDoneString)  \(event.title ?? "") - \(event.todoDescription ?? "")"
    cell.textLabel?.textColor = currentTheme.getColor(uiType: UIType.Text)
    //cell.detailTextLabel!.text = "\(event.priority)"
    cell.backgroundColor = currentTheme.getColor(uiType: UIType.Cell)
  }

  // MARK: - Fetched results controller
  
  var fetchedResultsController: NSFetchedResultsController<ToDo> {
      if _fetchedResultsController != nil {
          return _fetchedResultsController!
      }
      
      let fetchRequest: NSFetchRequest<ToDo> = ToDo.fetchRequest()
      
      // Set the batch size to a suitable number.
      fetchRequest.fetchBatchSize = 20
      
      // Edit the sort key as appropriate.
      let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
      
      fetchRequest.sortDescriptors = [sortDescriptor]
      
      // Edit the section name key path and cache name if appropriate.
      // nil for section name key path means "no sections".
      let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
      aFetchedResultsController.delegate = self
      _fetchedResultsController = aFetchedResultsController
      
      do {
          try _fetchedResultsController!.performFetch()
      } catch {
           // Replace this implementation with code to handle the error appropriately.
           // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
           let nserror = error as NSError
           fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
      
      return _fetchedResultsController!
  }    
  var _fetchedResultsController: NSFetchedResultsController<ToDo>? = nil

  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
      tableView.beginUpdates()
  }

  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
      switch type {
          case .insert:
              tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
          case .delete:
              tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
          default:
              return
      }
  }

  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
      switch type {
          case .insert:
              tableView.insertRows(at: [newIndexPath!], with: .fade)
          case .delete:
              tableView.deleteRows(at: [indexPath!], with: .fade)
          case .update:
              configureCell(tableView.cellForRow(at: indexPath!)!, withToDo: anObject as! ToDo)
          case .move:
              configureCell(tableView.cellForRow(at: indexPath!)!, withToDo: anObject as! ToDo)
              tableView.moveRow(at: indexPath!, to: newIndexPath!)
      }
  }

  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
      tableView.endUpdates()
  }

  /*
   // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
   
   func controllerDidChangeContent(controller: NSFetchedResultsController) {
       // In the simplest, most efficient, case, reload the table view.
       tableView.reloadData()
   }
   */

}

