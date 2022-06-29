import UIKit

class ViewController: UIViewController
{
    var coinManager = CoinManager()
    var currencyNos: Int
    {
        coinManager.currencyArray.count
    }
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var currecyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        coinManager.delegate = self
        currecyLabel.text = "INR"

        coinManager.getCoinPrice(for: "INR")
    }
}

//MARK: - CoinManagerDelegate

extension ViewController: CoinManagerDelegate
{
    func priceDidUpdate(coin: CoinModel) {
        DispatchQueue.main.async {
            self.currecyLabel.text = coin.currencyID
            self.priceLabel.text = coin.priceString
        }
    }
    
    func errorOccured(error: Error) {
        print(error)
    }
}

//MARK: - UIPickerViewDataSource, UIPickerViewDelegate

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyNos
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrecy = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectedCurrecy)
    }
}
