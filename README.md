# weather

This is a Swift project that demonstrates the use of the OpenWeatherMap API to display weather information of different cities. The app allows the user to search for a city by name and get its current weather information. The user can also add a city to a list of saved cities, which is displayed in a collection view. The saved cities can be reordered, edited or deleted.

The app is built using the Model-View-Controller (MVC) architecture. The main view controller, ViewController, handles the user interface and user interactions. It has outlets for displaying the weather icon, temperature, and city name, as well as a search field and a collection view. The view controller also has a weather manager to retrieve weather data from the OpenWeatherMap API and a location manager to get the user's current location.

The app is also integrated with pull-to-refresh and drag-and-drop functionalities. The user can refresh the weather information by pulling down the collection view. The user can also reorder the saved cities in the collection view by long-pressing and dragging a cell to a new position.

The app is built to be responsive to different device sizes and orientations, and it has been tested on various iOS devices running iOS 14 and above.
