Description
===========

Install Percona server components, leveraging the Opscode MySQL cookbook
as much as possible. Currently, this cookbook requires the use of a
modified mysql cookbook (linked below), pending possible acceptance of a
pull request.

Tested only on Ubuntu 10.04. Not tested on enterprise linux distros.

Requirements
============

* [modified mysql cookbook](http://tickets.opscode.com/browse/COOK-1236)
* [mysql cookbook bugfix](http://tickets.opscode.com/browse/COOK-1113)

Attributes
==========

`percona['version']`
Which version of Percona to install. Options are `5.0`, `5.1`,
`5.5`, or `latest`.

Other attributes override the default mysql attributes related to
package names.

Recipes
=======

percona_repo
------------

Installs Apt and Yum repos as required to download Percona packages.

client
------

Install Percona client using mysql::client recipe.

server
------

Installs Percona server using mysql::server recipe.

Usage
=====

