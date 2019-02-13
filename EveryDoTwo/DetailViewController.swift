
import UIKit

class DetailViewController: UIViewController {

  @IBOutlet weak var detailDescriptionLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  

  func configureView() {
    // Update the user interface for the detail item.
    if let detail = detailItem {
        if let label = detailDescriptionLabel {
            label.text = detail.title
        }
      if let desc = descriptionLabel{
        desc.text = detail.todoDescription ?? "assmass"
      }
    }
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

