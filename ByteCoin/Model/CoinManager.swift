import Foundation

protocol CoinManagerDelegate
{
    func priceDidUpdate(coin: CoinModel)
    func errorOccured(error: Error)
}

struct CoinManager
{
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "6BEFB356-BA67-4067-996D-F2452864E1BC"
    
    var delegate: CoinManagerDelegate?
    
    let currencyArray = ["INR","AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currecy: String)
    {
        let urlString = "\(baseURL)/\(currecy)?apikey=\(apiKey)"
        
        //1. Create a URL
        
        if let url = URL(string: urlString)
        {
            //2. Create a URLSession
            
            let session = URLSession(configuration: .default)
            
            //3. Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil
                {
                    delegate?.errorOccured(error: error!)
                    return
                }
                
                if let safeData = data
                {
                    if let coin = parseJSON(currencyData: safeData)
                    {
                        delegate?.priceDidUpdate(coin: coin)
                    }
                }
            }
            
            //4. Start the task
            
            task.resume()
        }
    }
    
    func parseJSON(currencyData: Data) -> CoinModel?
    {
        let decoder = JSONDecoder()
        
        do
        {
            let decodedData = try decoder.decode(CoidData.self, from: currencyData)
            
            let value = decodedData.rate
            let currecy = decodedData.asset_id_quote
            
            let coinModel = CoinModel(currencyID: currecy, price: value)
            
            return coinModel
        }
        
        catch
        {
            delegate?.errorOccured(error: error)
            return nil
        }
    }
}
