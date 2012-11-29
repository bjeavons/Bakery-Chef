Bakery-enabled cluster of Drupal sites for Bakery testing using Vagrant and Chef.

[![Build Status](https://secure.travis-ci.org/bjeavons/Bakery-Chef.png)](http://travis-ci.org/bjeavons/Bakery-Chef)

## Installation

1. [Download Virtual Box](https://www.virtualbox.org/wiki/Downloads)
1. [Download & install vagrant](http://downloads.vagrantup.com/tags/v1.0.3)
1. `git clone git://github.com/bjeavons/Bakery-Chef.git`
1. `cd Bakery-Chef`
1. `vagrant up`

Running `vagrant up` will take awhile because it downloads the VM image. It may 
fail with message about mysql returning status 1. Just type `vagrant provision`
to restart.

When it is done you can connect to the vm server using `vagrant ssh`.

The vm's apache server will be accessible at 172.22.22.22 and it will create
the following sites that you should add to your /etc/hosts file (all at 172.22.22.22):

* masterd6.vbox - Drupal 6 master
* d6.masterd6.vbox - Drupal 6 slave of Drupal 6 master
* d7.masterd6.vbox - Drupal 7 slave of Drupal 6 master
* masterd7.vbox - Drupal 7 master
* d6.masterd7.vbox - Drupal 6 slave of Drupal 7 master
* d7.masterd7.vbox - Drupal 7 slave of Drupal 7 master

Drupal sites come pre-installed with latest Bakery 2.x development release.

## Testing

Cucumber tests of SSO and basic data synchronization are available in the /tests directory.

