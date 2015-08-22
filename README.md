Bakery-enabled cluster of Drupal sites for Bakery testing using Vagrant and Chef.

## Installation

1. [Download Virtual Box](https://www.virtualbox.org/wiki/Downloads)
1. [Download & install Vagrant](https://www.vagrantup.com/downloads.html)
1. `git clone git://github.com/bjeavons/Bakery-Chef.git`
1. `cd Bakery-Chef`
1. `gem install librarian-chef`
2. `librarian-chef install`
1. `vagrant up`

Running `vagrant up` will take awhile because it downloads the VM image. If it fails try running `vagrant provision`
to retry the build.

When it is done you can connect to the vm server using `vagrant ssh`.

The vm's apache server will be accessible at 172.22.22.22 and it will create
the following sites that you should add to your /etc/hosts file (all at 172.22.22.22):

* masterd6.vbox - Drupal 6 master
* d6.masterd6.vbox - Drupal 6 slave of Drupal 6 master
* d7.masterd6.vbox - Drupal 7 slave of Drupal 6 master
* masterd7.vbox - Drupal 7 master
* d6.masterd7.vbox - Drupal 6 slave of Drupal 7 master
* d7.masterd7.vbox - Drupal 7 slave of Drupal 7 master

Sites over SSL (self-signed cert)

* smasterd6.vbox - Drupal 6 secure master
* d6.smasterd6.vbox - Drupal 6 secure slave of Drupal 6 master
* d7.smasterd6.vbox - Drupal 7 secure slave of Drupal 6 master
* smasterd7.vbox - Drupal 7 secure master
* d6.smasterd7.vbox - Drupal 6 secure slave of Drupal 7 master
* d7.smasterd7.vbox - Drupal 7 secure slave of Drupal 7 master

Drupal sites come pre-installed with latest Bakery 2.x development release.

Edit the Vagrantfile to symlink Bakery modules from your host to ease development.

All admin accounts are username: admin and password: 1234

## Testing

Cucumber tests of SSO and basic data synchronization are available in the /tests directory.

1. [Install Cucumber](https://github.com/cucumber/cucumber/wiki/Install)
1. [Install PhantomJS](http://phantomjs.org/download.html)
1. `gem install poltergeist`
1. `gem install rspec-expectations`
1. Run tests: `cucumber tests/bakery/features`
