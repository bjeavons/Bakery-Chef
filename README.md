Bakery-enabled cluster of Drupal sites for Bakery testing using Vagrant and Chef.

## Installation

1. [Download Virtual Box](https://www.virtualbox.org/wiki/Downloads)
1. [Download & install vagrant](http://downloads.vagrantup.com/tags/v1.0.3)
1. `git clone git://github.com/bjeavons/Bakery-Chef.git`
1. `cd Bakery-Chef`
1. `vagrant up`

Running `vagrant up` will take awhile because it downloads the VM image.

When it is done you can connect to the vm server using `vagrant ssh`.

The vm's apache server will be accessible at 172.22.22.22.

