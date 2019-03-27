# docker-openpolice
Docker Compose configuration for Open Police Complaints ^0.1 running PHP 7.3 with Nginx, PHP-FPM, PostgreSQL 11.2 and Composer.

## Overview

Docker Compose configuration for openpolice ^0.1 running PHP 7.3 with Nginx, PHP-FPM, PostgreSQL 11.2 and Composer. 
It exposes 4 services:

* web (Nginx)
* php (PHP 7.3 with PHP-FPM)
* db (PostgreSQL 11.2)
* composer
* openpolice

The PHP image comes with the most commonly used extensions and is configured with xdebug.
The UUID extension for PostgreSQL has been added.
Nginx default configuration is set up for Symfony 4 and serves the working directory.
Composer is run at boot time and will automatically install the vendors.

## Install prerequisites

You will need:

* [Docker CE](https://docs.docker.com/engine/installation/)
* [Docker Compose](https://docs.docker.com/compose/install)
* Git (optional)

## How to use it




<h1 class="slBlueDark">How To Install openpolice with Docker on Digital Ocean</h1>
<p>This process runs a variety of <a href="https://www.digitalocean.com/community/tutorials/how-to-set-up-laravel-nginx-and-mysql-with-docker-compose" target="_blank">Digital Ocean's layered tutorials</a>. I don't understand all of it yet, so will leave the explanations to their superb articles. This variation also adds SurvLoop and OpenPolice structures.</p>
<p>After starting up a new <b class="red">Ubuntu 18.04</b> Droplet — I couldn't pull this off with less than <span class="red">2GB RAM</span> — connect it with the root account and your SSH key. The first install script will create a non-root user, e.g. <span class="red">survuser</span>. Be sure to create and save a copy of a strong password, which you'll need handy throughout this install:</p>
<pre>$ git clone https://github.com/flexyourrights/docker-openpolice.git /usr/local/lib/docker-openpolice
$ chmod +x /usr/local/lib/docker-openpolice/bin/*.sh
$ /usr/local/lib/docker-openpolice/bin/openpolice-install-1.sh <span class="red">survuser</span>
$ exit
# ssh <span class="red">survuser</span>@<span class="red">YOUR.SERVER.IP</span>
</pre>

<p>Exit to logout as root, and log back in as <span class="red">survuser</span>. Your key should work, and you should have sudo power. During these installs you can accept all defaults, but I do opt for the latest manufacturer's version of the OpenSSH package.</p>
<h3 class="slBlueDark">Now logged in as a non-root user</h3>
<pre>$ sudo chmod +x /usr/local/lib/docker-openpolice/bin/*.sh
$ bash /usr/local/lib/docker-openpolice/bin/openpolice-install-2.sh
</pre>
<p>Build and boot Docker Containers...</p>
<pre>$ bash /usr/local/lib/docker-openpolice/bin/openpolice-install-3.sh
</pre>
<p>Update the .env file for your system with a database password you can create now. (Also a great time to change the user and database names, if you like.)</p>
<pre>$ cd ~/openpolice
$ docker-compose exec app nano .env
</pre>
<pre>DB_DATABASE=openpolice
DB_USERNAME=openpoliceuser
DB_PASSWORD=<span class="red">openpoliceuserpassword</span></pre>
<h4>Create Database & Permissions</h4>
<p>If you haven't already, enter the database container, then the MYSQL command line, using the strong database user password you entered in the .env file.</p>
<pre>$ cd ~/openpolice
$ docker-compose exec db bash
root@9472354969ea:/# mysql -u root -p</pre>
<p>Next, give your <span class="red">openpoliceuser</span> permission to your new database.</p>
<pre>mysql> GRANT ALL ON <span class="red">openpolice</span>.* TO '<span class="red">openpoliceuser</span>'@'%' IDENTIFIED BY '<span class="red">openpoliceuserpassword</span>';
mysql> FLUSH PRIVILEGES;
mysql> EXIT;
root@9472354969ea:/# exit</pre>
<h4>Tweak Composer.json</h4>
<pre>$ cd ~/openpolice
$ docker-compose exec app nano composer.json</pre>
<p>Update `composer.json` to add requirements and an easier SurvLoop and OpenPolice reference:</p>
<pre>...
"autoload": {
    ...
    "psr-4": {
        ...
        "SurvLoop\\": "vendor/wikiworldorder/survloop/src/",
        "OpenPolice\\": "vendor/flexyourrights/openpolice/src/",
    }
    ...
},
...</pre>

<h4>Fill Database</h4>
<p>Once your database is created, and login info linked with Laravel, we can install database...</p>
<pre>$ bash /usr/local/lib/docker-openpolice/bin/openpolice-install-4.sh</pre>
<p>Which provider or tag's files would you like to publish? <b>0</b></p>



## Change configuration

### Configuring PHP

To change PHP's configuration edit `.docker/conf/php/php.ini`.
Same goes for `.docker/conf/php/xdebug.ini`.

### Configuring PostgreSQL

Any .sh or .sql file you add in `./.docker/conf/postgres` will be automatically loaded at boot time.

If you want to change the db name, db user and db password simply edit the `.env` file at the project's root.

If you connect to PostgreSQL from localhost a password is not required however from another container you will have to supply it.
