# Valid Passwords Calculator

This is a project for calculating valid passwords based on certain criteria using Rails 7 (Trailblazer) and React.


## Getting Started

To get started with the project, you will need to clone the repository and install the necessary dependencies.


### Prerequisites

- Ruby 3.1.0 or higher
- Rails 7.0.0.alpha or higher
- Node.js and npm
- Yarn


### Installation

1. Clone the repository: `git clone https://github.com/popovycj/password-calculator.git`
2. Navigate into the project directory: `cd password-calculator`
3. Install Ruby dependencies: `bundle install`
4. Install JavaScript dependencies: `yarn install`
5. Set your database credentials: `rails credentials:edit`
6. Start the development server: `rails s`


## Usage

Once the development server is running, you can access the project in your web browser by navigating to http://localhost:3000. The application allows you to upload file with .txt extension which follow certain rules stated in instruction to calculate the number of valid passwords that meet those criteria.


## Running Tests

The project uses rspec for testing. To run the tests, navigate to the project directory and run the following command:

`rspec`


## Deployment

The project is currently deployed on Heroku and can be accessed at the following link: https://password-calculator-popovycj.fly.dev/


## Built With

- Rails 7 (Trailblazer)
- React
- rspec
