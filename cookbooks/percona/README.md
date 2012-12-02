Description
===========

Install Percona server components, leveraging the Opscode MySQL cookbook
as much as possible.

Tested only on Ubuntu 10.04. Not tested on enterprise linux distros.

Requirements
============

* MySQL cookbook (=> 1.3.0)

Attributes
==========

`percona['version']`
Which version of Percona to install. Options are `5.0`, `5.1`,
`5.5`, or `latest`.

Other attributes necessarily override the default mysql attributes
related to package names.

Recipes
=======

default
-------

Mirror of `client` recipe.

percona_repo
------------

Installs Apt or Yum repos as required to download Percona packages.

client
------

Includes `percona_repo` recipe and installs Percona client using
`mysql::client` recipe.

server
------

Includes `percona_repo` recipe and installs Percona server using
`mysql::server` recipe.

Usage
=====

To Do
=====

  - Add recipes for additional Percona utilities.
