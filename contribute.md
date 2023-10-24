**Key:**

- 📁 - folder
- 📄 - file
- 📦 - class/object
- 🏷️ - parameter


# Folder Layout

- `📁 components` - widgets used accross the app.
- `📁 global_state` - The global state of the app including user accounts and settings
- `📁 pages` - contains the three pages accessible via the bottom navigation bar
and in there contains all the screen that will be pushed onto the page.
- `📁 repo` - contains classes used for communicating with web API's.
- `📁 utils` - functions used accross the app.

# Screen Template

[Example of a screen](https://github.com/freshfieldreds/muffed/tree/main/lib/pages/home_page/screens/community_screen)

- `📁 example_screen`
	- `📁 bloc`
		- `📄 bloc.dart`
		- `📄 state.dart`
          - `🏷️ Object? err`
          - `🏷️ bool isLoading`
		- `📄 event.dart`
	- `📄 example_screen.dart`
		- `📦 ExampleScreen`
			- `📦 BlocProvider`
				- `📦 SetPageInfo` - Tells the bottom navigation bar how to respond to the page
					- `📦 MuffedPage` - Adds the ability to show loading inidcator and errors on the page
		
		
