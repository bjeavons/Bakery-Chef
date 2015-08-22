name             "bakery"
maintainer       "Ben Jeavons"
maintainer_email "benjamin.jeavons@colorado.edu"
license          "Apache 2.0"
description      "Installs Bakery-enabled Drupal sites"
version          "0.1"

%w{ debian ubuntu centos }.each do |os|
  supports os
end


