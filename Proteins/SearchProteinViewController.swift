//
//  SearchProteinViewController.swift
//  Proteins
//
//  Created by lrussu on 6/28/17.
//  Copyright © 2017 lrussu. All rights reserved.
//

import UIKit

class SearchProteinViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var searchActive: Bool = false
    var dataArray: [String] = []
    var filtered: [String] = []
    var proteinId: String?
    
    
    func loadListOfLigands() {
        // Specify the path to the countries list file.
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        let pathFile: String? = Bundle.main.path(forResource: "ligands", ofType: "txt")
        
        if let path = pathFile {
            // Load the file contents as a string.
            do {
                let ligandsString = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
                dataArray = (ligandsString?.components(separatedBy: "\n"))!
                
                // Reload the tableview.
                tableView.reloadData()
            } catch {
                
            }
            // Append the countries from the string to the dataArray array by breaking them using the line change character.
            
        } else {
        
        }
        self.activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /* Setup delegates */
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        loadListOfLigands()
        
        // Do any additional setup after loading the view.
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    private func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    private func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filtered = dataArray.filter({ (text) -> Bool in
            let tmp: NSString = text as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        }
        return dataArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "proteinCell")! as UITableViewCell;
        if(searchActive){
            cell.textLabel?.text = filtered[indexPath.row]
        } else {
            cell.textLabel?.text = dataArray[indexPath.row];
        }
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
        
        // Get Cell Label
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        
        
        proteinId = currentCell.textLabel?.text
        performSegue(withIdentifier: "segueProtein3D", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {        
        if (segue.identifier == "segueProtein3D") {
            // initialize new view controller and cast it as your view controller
            let viewController = segue.destination as! ProteinViewController
            // your new view controller should have property that will store passed value
            viewController.passedProteinId = self.proteinId!
        }
    }

}
