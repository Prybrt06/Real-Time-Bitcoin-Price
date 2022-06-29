import Foundation

struct CoinModel
{
    let currencyID: String
    let price: Double
    
    var priceString: String
    {
        return String(format: "%0.2f", price)
    }
}
