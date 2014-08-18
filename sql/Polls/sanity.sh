#!/bin/bash
# Perform some sanity checks.
rake db:migrate VERSION=0 && rake db:migrate && rails runner bin/init_sample_db.rb && rails runner bin/sample_test.rb
