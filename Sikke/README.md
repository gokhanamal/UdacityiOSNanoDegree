## Sikke: Currency Wallet

Sikke is a simple currency wallet that allow to save your currency investments to your wallet and you can see realtime value of your investments according to your base currency.

## Screenshots

![Sikke](https://i.hizliresim.com/H2mqO2.jpg)

## Features

- The main screen show the all investments and theirs current vallue according to base currency.
- You can see the total current value on the top of the screen.
- You can delete an investment by swiping left or clicking edit button
- You can add an invesment by using the plus button on the top of the screen
- You can see the gain/loss percentage of your investments on each row. Gain has green color and up arrow, loss has red color and down arrow.
- You can change the base currency by clicking right arrow button on the right side of base currency
- Sikke app allows to choose 32 different currency.

## How to use

1. Click the right arrow button to change your base currency and choose appropriate base currency. When you choose a currency, the app will send a new request to get the rates of you base currency.
2. Click plus icon to choose an investment. Choose and investment from the list, or you can use the search box to find currency.
3. Type your investment amount and the exchange rate of your currency.
4. Save your invesment to your wallet by clicking save button.

## Dependencies

- [FlagKit](https://github.com/madebybowtie/FlagKit)
- [JGProgressHUD](https://github.com/JonasGessner/JGProgressHUD)
- [Exchange Rates API](https://exchangeratesapi.io/)

# How to run

1. Clone this repository
   `$ git clone https://github.com/gokhanamal/UdacityiOSNanoDegree`
2. Change directory
   `$ cd UdacityiOSNanoDegree/Sikke`
3. This project use [CocoaPods](https://cocoapods.org/) for dependency manager. You have to install cocoapods to your computer.
   `$ sudo gem install cocoapods`
4. Install the pod files
   `$ pod install`
5. Open Sikke.xcworkspace on Xcode
6. Build and Run the project
