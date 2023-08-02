import UIKit
import metamask_ios_sdk
import Combine

class ViewController: UIViewController {
    
    private var ethereum: Ethereum {
        return MetaMaskSDK.shared.ethereum
    }
    private var cancellables: Set<AnyCancellable> = []
    private var chainId: String?
    private var balance: String?
    
    private let chainIdLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private let balanceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        connectToMetaMask()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(chainIdLabel)
        view.addSubview(balanceLabel)
        
        chainIdLabel.translatesAutoresizingMaskIntoConstraints = false
        chainIdLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100).isActive = true
        chainIdLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        chainIdLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        balanceLabel.translatesAutoresizingMaskIntoConstraints = false
        balanceLabel.topAnchor.constraint(equalTo: chainIdLabel.bottomAnchor, constant: 20).isActive = true
        balanceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        balanceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
    }
    
    private func connectToMetaMask() {
        let dapp = Dapp(name: "Baby colouring book for kids", url: "https://apps.apple.com/in/app/baby-colouring-book-for-kids/id1129192831")
        ethereum.connect(dapp)
        
        // Fetch Chain ID
        ethereum.$chainId
       // ethereum.requestChainId()
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    print("\(error.localizedDescription)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] result in
                self?.chainId = result
                DispatchQueue.main.async {
                    self?.chainIdLabel.text = "Chain ID: \(result)"
                }
            })
            .store(in: &cancellables)
        
        // Fetch Account Balance
        let parameters: [String] = [
            ethereum.selectedAddress, // address to check for balance
            "latest" // "latest", "earliest" or "pending" (optional)
        ]
        
        let getBalanceRequest = EthereumRequest(
            method: .ethGetBalance,
            params: parameters)
        
        if let balanceCancellable = ethereum.request(getBalanceRequest)?
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    print("\(error.localizedDescription)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] result in
                if let balance = result as? String {
                    self?.balance = balance
                    DispatchQueue.main.async {
                        self?.balanceLabel.text = "Account Balance: \(balance)"
                    }
                }
            }) {
            cancellables.insert(balanceCancellable)
        }
    }
}
