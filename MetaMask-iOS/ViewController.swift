import UIKit
import Glaip

class ViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var chainIDLabel: UILabel!
    
    //MARK: variable
    var glaip = Glaip(
        title: "Glaip Demo App",
        description: "Demo app to demonstrate Web3 login",
        supportedWallets: [.Rainbow]
    )
    
    
    //MARK: Life cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: Action
    @IBAction func linkWalletButton(_ sender: Any) {
        
        connectToMetaMask()
        
        
    }
    
    //MARK: Redirect Chain ID
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
