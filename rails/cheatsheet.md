
Adding a resource
==================

* (Optional) Generate model
  `rails generate model Cat`

* Create the table

  If you don't have a migration for this yet, create one with
    `rails generate migration CreateCats`
  
  ```ruby
  # db/migrate/..._create_cats.rb
  class CreateCats < ActiveRecord::Migration
    def change
      create_table :cats do |t|
        t.integer :age
        t.date :birth_date
        t.string :color
        t.string :name
        t.string :sex
        t.text :description

        t.timestamps
      end
    end
  end
  ```

* Create a controller

  If the file `app/controllers/cats.rb` does not exist, create it.
  
  ```ruby
  # app/controllers/cats.rb
  class CatsContoller < ApplicationController
    def index
      # ...
    end
  end
  ```



* List a your resource in `routes.rb`

  ```ruby
  # config/routes.rb
  My99cats::Application.routes.draw do
    resources :cats
  end
  ```


