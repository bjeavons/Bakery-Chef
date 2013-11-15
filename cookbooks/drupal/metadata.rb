name             "drupal"
maintainer       "Ben Jeavons"
maintainer_email "benjamin.jeavons@colorado.edu"
license          "Apache 2.0"
description      "Sets up Drupal sites"
version          "0.1"

%w{ debian ubuntu centos }.each do |os|
  supports os
end
