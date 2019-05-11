#!/bin/bash
set -x
# ******* Running OpenPolice Intaller *******

composer global require "laravel/installer"
composer create-project laravel/laravel $1 "5.8.*"
cd $1

# Laravel basic preparations
php artisan key:generate
php artisan make:auth

# Install SurvLoop & OpenPolice
composer require flexyourrights/openpolice

composer dump-autoload
php artisan optimize

# Install SurvLoop user model
#cp vendor/wikiworldorder/survloop/src/Models/User.php app/User.php
#sed -i 's/namespace App\\Models;/namespace App;/g' app/User.php
sed -i 's/App\\User::class/SurvLoop\\Models\\User::class/g' config/auth.php

# Clear caches for good measure, then push copies of vendor files
echo "0" | php artisan vendor:publish --force

# Migrate database designs, and seed with data
php artisan migrate

php artisan optimize
composer dump-autoload

php artisan db:seed --class=SurvLoopSeeder
php artisan db:seed --class=ZipCodeSeeder
php artisan db:seed --class=OpenPoliceSeeder
php artisan db:seed --class=OpenPoliceDeptSeeder

php artisan optimize
composer dump-autoload