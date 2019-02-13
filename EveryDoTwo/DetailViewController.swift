
import UIKit

class DetailViewController: UIViewController {

  @IBOutlet weak var detailDescriptionLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var completedSwitch: UISwitch!
  @IBOutlet weak var completedLabel: UILabel!
  

  func configureView() {
    // Update the user interface for the detail item.
    if let detail = detailItem {
        if let label = detailDescriptionLabel {
            label.text = detail.title
        }
      if let desc = descriptionLabel{
        desc.text = detail.todoDescription ?? "assmass"
      }
      if let mySwitch = completedSwitch{
        mySwitch.isOn = detail.isCompleted
        updateCompletedLabel()
      }
    }
  }
  @IBAction func toggleComplete(_ sender: Any) {
    //TODO update core data
    updateCompletedLabel()
    
    if let detail = detailItem {
      detail.isCompleted = true
    }
    
    if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
      appDelegate.saveContext()
    }
    
  }
  
  func updateCompletedLabel(){
    completedLabel.text = completedSwitch.isOn ? "Complete!" : "Not Complete"
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    configureView()
  }

  var detailItem: ToDo? {
    didSet {
      print("calling did set")
        // Update the view.
        configureView()
    }
  }


}

