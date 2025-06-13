# Currency-Converter
Test Assignment “Currency Converter”

Objective:
Develop an iOS application for currency conversion that also allows users to search through the history of completed conversions (SwiftUI, iOS 17+).

# Minimum Requirements:

Currency Selection: Users can choose from the following currencies: Russian Rubles (RUB), US Dollars (USD), Euros (EUR), British Pounds (GBP), Swiss Francs (CHF), and Chinese Yuan (CNY).
Currency Pair Selection: Users select a currency pair (for example, USD/RUB) and enter an amount in the source currency.
Conversion and Result Display: The app recalculates the amount in the target currency based on the current exchange rate, showing the amount and conversion rate. Cached data is used for conversions, with rate freshness checked at a set time interval.
Offline Operation: The latest currency rates are saved in the app for use in offline mode or when an error occurs while fetching data.
Selection Saving: The chosen currency pair is saved for automatic pre-filling upon subsequent app launches.


Advanced Requirements:

Conversion History: Implement an additional screen that displays the history of all conversions.
Search in History: Provide the ability to search the conversion history by currency pair. The search should be efficient and available in offline mode.


Evaluation Criteria:

Application Architecture: Evaluation will focus on code structuring, use of architectural patterns for cleanliness, and scalability of the code.
Error Handling: Implementation of error handling mechanisms.
Code Testability: Code organization should facilitate unit testing, demonstrating a thoughtful approach to testing.


Additional Information:

UI: A primitive UI is acceptable, however, the application should demonstrate a meaningful approach to interface design and user interaction.
Currency Rates API: For fetching current exchange rates, it is recommended to use (https://freecurrencyapi.com/) or any other of your choice.




Идеи для доработки: 

 - добавить возможность заметки
 - вынесли список поддерживаемых валют в dropBox, для легкого удаленного контроля
 - прикрутить StoreKit - 
 - прикрутить график ??
 - прикрутить запрос на получение исторического рейта на определенный день
