import UIKit
import GooglePlaces

class placeSuggestionViewController: UIViewController ,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var searchTF: UIView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var placeTableView: UITableView!
    
    var PlacesuggestionArr = [GMSAutocompletePrediction].init()
    
    
    
    
    
    
    //==========================================================================================
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PlacesuggestionArr.count
    }
    
    //==========================================================================================
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TableViewCell
        
        cell.primaryLabel.text = PlacesuggestionArr[indexPath.row].attributedPrimaryText.string
       
        cell.SecondaryLabel.text = PlacesuggestionArr[indexPath.row].attributedSecondaryText?.string
        
        return cell
    }
    
    //==========================================================================================
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < PlacesuggestionArr.count{
            GetPlaceDetails(placeID: "\((PlacesuggestionArr[indexPath.row].placeID)!)")
            
        }
    }
    //==========================================================================================
    
    func GetPlaceDetails(placeID: String)
    {
        let client = GMSPlacesClient.shared()
        client.lookUpPlaceID(placeID) { (place, error) in
            if error != nil
            {
                let alert = UIAlertController.init(title: "ERROR", message: "Something went wrong", preferredStyle: .alert)
                alert.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: nil))
                self.present(alert,animated: true,completion: nil)
                return
            }
            if place != nil{
                self.delegate?.abc(places: (place?.formattedAddress)!, COrdinates: (place?.coordinate)!)
                self.navigationController?.popViewController(animated: true)
                print(place?.formattedAddress)
                print(place?.coordinate)
            }
        }
    }
    //==========================================================================================
    
    var delegate : GETPLACESDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placeTableView.dataSource = self
        placeTableView.delegate = self
    }

    //==========================================================================================
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    //==========================================================================================
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //==========================================================================================
    
    
    @IBAction func TFEditingChange(_ sender: UITextField) {
        print(getPlacesSuggestions(text: "\((sender.text)!)"))
    }
    
    //==========================================================================================
    
    func getPlacesSuggestions(text :String)
    {
        loader.startAnimating()
        let Client = GMSPlacesClient.shared()
        let filter   = GMSAutocompleteFilter.init()
        filter.country = "IND"
        filter.type = .city
    Client.autocompleteQuery(text, bounds: nil, filter: filter)
    {
        
        (Places,error) in
        
        self.loader.stopAnimating()
        if error != nil
        {
            let alert = UIAlertController.init(title: "ERROR", message: "Something went wrong", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: nil))
            self.present(alert,animated: true,completion: nil)
            return
        }
        
        if Places != nil
        {
            self.PlacesuggestionArr = Places!
            self.placeTableView.reloadData()
        }
        
        }
       
    }
    

}
protocol GETPLACESDelegate {
    func abc (places : String, COrdinates : CLLocationCoordinate2D)
}
