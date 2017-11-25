# swift-assignment2
Mobile Application Enterprise Development Assignment 2

Notes: 

Shopping App

Cosplay 3D printing company

6 different items in the master view menu:

Homepage - nice graphic eithera picture or 3D rendering
List - of products with pictures for each model, together with pricing information for multiple print materials and a button to add items to a shopping cart
Search function - users can easily locate model
Cart”, which stores all information about the user's purchases and provides a running total in dollars.
Finder - Allows user to find closest 3D printing venue relative to current location
Checkout - Allows user to enter credit card details to make purchase

Required Elements:
Master-View Controller with at least 6 different detail views configured in storyboard and containing different outlets (graphics, buttons, text fields etc) 
Model-View-controller design pattern with custom classes specifying all the detail view properties and methods, + local db containing specifying all the items on the product menu and their metadata (image, pricing, availability) 
Network database accessibility using SwiftyJSON framework for checkout (15%) and network-based location mapping for the store finder (15%)

Intent to produce the app closely mirror a commercial product

Pricing 
Each product will have set price, price is for printing in PLA with no painting, printing in ABS will add 10% to the price, painting and finished adds 55%

Server
Provided access with JSON data stream and the specifications for the server 
Checkout doesn’t need to be secure - need to collect credit card data, not transmit it
You’ll be able to submit a request for checkout to the server without including credit card information, it will respond confirming that checkout has been completed
Server will provide a list of outlets with GPS coordinates and confirmation of a successful checkout

Server will be located at http://partiklezoo.com/3dprinting/
To get a list of products, base URL will work, products will be returned as JSON data, array in which each record has the fields UID, price, name, description, image and category. 
Category can be “3D printers” or “Consumable” 
