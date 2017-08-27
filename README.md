# Proteins
Swift application. 3D gallery of ligands

Swifty Proteins - Your 3d-science library. Take, Roll, Research 3d-molecules and make pretty shots.
Use Touch Id or password for authorization. Proteins are arranged in ABC way or you can use search field. Be ready for research 3d model of protein, you can rotate, bring closer and farer, detect names of atoms. For most beautiful composition make shot, sign it and save on your device. 
Enjoy and have fun!

# Technics and components
1. Keychain service for saving password
2. Touch ID authentication
3. Scene Kit for 3d visualization of molecules
4. UISearchBar controller as element of user interface
5. UITableViewController for data presentation
6. Regular Expressions for getting needed data
7. Grand Central Dispatch

# Application functionality
Since application download you will see pretty lauch-screen image. Next step is authorization  by password / Touch ID. After successful authentication you will see list of loaded protein's ligands from attached file. Select protein ligand and view it's 3d-presentation. Data for visualization are took from site http://RCSB.org as text file. Befor construction 3d model of protein,  file will be parsed by regular expressions. Parsing operations are separated from UI updated tasks, for saving UI refreshing speed. Gesture recognizer are available, you can rotate and  scale molecule as you want. Also you can save protein image with custom text in your photos.
