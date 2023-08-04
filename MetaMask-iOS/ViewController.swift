import UIKit
import Glaip

class ViewController: UIViewController {
    
    var glaip = Glaip(
        title: "Glaip Demo App",
        description: "Demo app to demonstrate Web3 login",
        supportedWallets: [.Rainbow]
    )
  
    @IBOutlet weak var chainIDLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
        
    }
    
    
    @IBAction func linkWalletButton(_ sender: Any) {
        
        connectToMetaMask()
        
        
    }
    
    private func connectToMetaMask() {
        glaip.loginUser(type: .MetaMask) { result in
            switch result {
            case .success(let user):
                print(user.wallet.address)
                DispatchQueue.main.async {
                    self.chainIDLabel.text = "Chain ID: \(user.wallet.address)"
                }
            case .failure(let error):
                print(error)
            }
        }
    }

}
