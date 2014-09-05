#!/bin/bash
rm -rf contacts
rails new contacts
cd contacts

# Migrations
mkdir -p ./db/migrate && cp ../migrate/* ./db/migrate/
rake db:migrate

# Models
mkdir -p ./app/models && cp ../models/* ./app/models/

rails runner ../test.rb


