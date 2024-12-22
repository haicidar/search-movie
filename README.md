
# Search-Movie


## Installation

- Clone the Repository:
   Clone this project to your local machine:  
   ```bash
   git clone https://github.com/haicidar/search-movie.git
   cd search-movie

- Create config file "Config.xcconfig" under "search-movie" folder
- Sign up for a free or paid API key from [OMDB API](https://www.omdbapi.com/).
- Add the following to the Config.xcconfig file:
    ```bash
    API_KEY = your_api_key
    ```
    
## Tech Reasoning

### MVVM
The **Model-View-ViewModel (MVVM)** architecture is implemented to maintain a clean and testable codebase. However, given the scope of this project, the architecture has been kept as simple as possible to avoid unnecessary complexity.

### UserDefaults
**UserDefaults** is used as a data cache in this project due to the nature of the data being stored—small and lightweight (e.g., 10 search queries). Unlike **NSCache**, **UserDefaults** provides reliable persistence as it is not purged under memory pressure. Additionally, its simplicity makes it an ideal choice for this use case.

---

## Trade-offs

### MVVM
While simplifying MVVM reduced architectural complexity, it also introduced challenges, such as making the codebase less clean and harder to scale for larger features or future expansions.

### UserDefaults
Although **UserDefaults** works well for small data, it lacks memory management and can become inefficient if the amount of data stored grows significantly.

---

## Future Improvements

### Layering
Refactor the codebase to introduce proper separation between low-level and high-level layers. Ensure dependencies between these layers are loosely coupled to create a clean, maintainable, reusable, and testable architecture.

### Caching
Implement a more robust and appropriate caching mechanism for better performance and scalability.

### Error Handling and Retry Logic
Enhance error handling mechanisms and introduce retry logic for API requests to improve reliability and user experience.

### UI Enhancements
Work on improving the user interface by adding smoother animations and creating more user-friendly interactions.
