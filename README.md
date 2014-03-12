drupal Cookbook
===============
This cookbook installs a Drupal site on a LAMP stack.

[![Build Status](https://travis-ci.org/newmediadenver/drupal.png?branch=master)](https://travis-ci.org/newmediadenver/drupal)

Usage
-----
This cookbook has been designed to work with [drupal-lamp](http://github.com/newmediadenver/drupal-lamp).

### Available deploy actions
#### deploy
deploy will pull down a fresh copy of your repo.

#### install
install will run drush site-install for the given install profile

#### import
This will import an existing database backup for your site.
In addition to including import in your action list, you will need a sql dump on your box. The easiest
way to do this is to place a *.sql dump in the same directory as your VagrantFile (or relative to it).
Then place the path to this sql dump file in db_file.

Example:
If your file was backup.sql and you placed it in the same directory as your VagrantFile, then you would simply put /vagrant/backup.sql in your json at db_file.

#### update
Will run:
````
drush updb -y; drush cc all
````

### Using drush
After a site is installed:
````
$ vagrant ssh
$ cd /assets/[site name]
$ [run drush commands]
````
### Using drush make

Drush make will build the site out of a github profile. If you would like to have
the profile pull from a github uri, and build using the variables in the drupal_lamp.json, a template option is available and will be used in the command ```drush make build.make```. If template is
false, you will need to have a ```"default":"build-[name-of-profile].make"``` in the
files hash. If the drush make is present, it will try to build the site, if not
the recipe assumes you have a full site.
```
"drush_make": {
  "api": "2",
  "files": {
    "default": "build-profile.make",
    "core": "drupal-org-core.make"
  },
  "template": false
},
```

Configuration
-------------
````
default[:drupal][:server][:web_user] = "www-data" # linux web user
default[:drupal][:server][:web_group] = "www-data" # linux web group
default[:drupal][:server][:base] = "/srv/www" # web root base
default[:drupal][:server][:assets] = "/assets" # where all folders will be linked to for sharing purposes

default[:drupal][:drush][:revision] = "6.2.0" # drush revision
default[:drupal][:drush][:repository] = "https://github.com/drush-ops/drush.git"
default[:drupal][:drush][:dir] = "/opt/drush" # where to place drush
default[:drupal][:drush][:executable] = "/usr/bin/drush" # where to place drush executable

# The below example will:
# 1. clone the repository found https://github.com/drupal/drupal.git
# 2. import a database from backup.sql
# 3. run drupal updates
default[:drupal][:sites] = {
"example": {  # site name
  "active": true, # true or false
  "deploy": {
    "action": ["deploy", "import", "update"], # see "available deploy actions"
    "releases": 1 # number of git releases to store (in addition to the active release)
  },
  "drupal": {
    "version": "7.0", # drupal version 8.0, 7.0 or 6.0
    "install": {
      "install_configure_form.update_status_module": "'array(FALSE,FALSE)'",
      "--clean-url": 1 # enable clean urls on site install
    },
    # Build the site using drush make
    "drush_make": {
      "api": "2",
      # Pull in all drush make files needed for the make
      "files": {
        "default": "build-profile.make",
        "core": "drupal-org-core.make"
      },
      # Use a template or use the the default file
      "template": false
    },
    "settings": {
      "profile": "standard", # if action is clean, this install profile will be installed
      "files": "sites/default/files", # location of the files directory
      "cookbook": "drupal", # the name of this cookbook
      "settings": {
        "default": {
          "location": "sites/default/settings.php" # location of the settings.php file
        },
        # use this section if you want to create a settings.php file from a template
        "example_template": {
          "location": "sites/default/example.settings.php",
          "template": "example.settings.php.erb"
        },
        # use this section if you want to include an additional settings.php
        #file onto the end of the default settings.php file
        "example_static": {
          "location": "profiles/standard/standard.settings.php"
        }
      },
      "db_name": "example", # database name
      "db_host": "localhost", # database host
      "db_prefix": "", # database prefix
      "db_driver": "mysql", # database driver
      "db_file": "backup.sql" # name of the database file that will be imported if action = import.
    }
  },
  "repository": {
    "host": "github.com",
    "uri": "https://github.com/drupal/drupal.git",
    "revision": "7.26" # branch, tag, or hash
  },
  # Apache configuration
  "web_app": {
    "80": { # port
      "server_name": "drupal.local",
      "rewrite_engine": "On",
      "docroot": "/srv/www/example/current",
      "server_name": "",
      "server_aliases": "",
      "rewrite_log": "",
      "rewrite_log_level": "",
      "directories": "",
      "rewrite": "",
      "log_level": "",
      "error_log": "",
      "custom_log": "",
      "transfer_log": "",
      "set_env_if": "",
      "redirect": ""
    },
    # include if you need https
    "443": {
    	"server_name": "drupal.local",
      "rewrite_engine": "On",
      "docroot": "/srv/www/example/current",
      "server_name": "",
      "server_aliases": "",
      "rewrite_log": "",
      "rewrite_log_level": "",
      "directories": "",
      "rewrite": "",
      "log_level": "",
      "error_log": "",
      "custom_log": "",
      "transfer_log": "",
      "set_env_if": "",
      "redirect": "",
      "ssl": {
        "ssl_engine": "",
        "ssl_protocol": "",
        "ssl_cipher_suite": "",
        "ssl_certificate_file": "",
        "ssl_certificate_key_file": ""
      }
    }
  }
}
````

Contributing
------------

We welcome contributed improvements and bug fixes via the usual workflow:

1. Fork this repository
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new pull request
