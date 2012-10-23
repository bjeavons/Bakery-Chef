<?php

/**
 * Implements COMMANDFILE_drush_command().
 */
function vm_drush_command() {
  $items = array();

  $items['vm-bakery-mode'] = array(
    'description' => "Get Bakery mode",
    'aliases' => array('vmbm'),
  );

  $items['vm-setup-bakery-master'] = array(
    'description' => "Setup Bakery master",
    'aliases' => array('vmbm'),
    'arguments' => array(
      'master' => dt('Master URL'),
      'domain' => dt('Master domain')
    ),
    'options' => array(
      'slaves' => dt('List of slave URLs separated by comma'),
    ),
  );
 $items['vm-setup-bakery-slave'] = array(
    'description' => "Setup Bakery slave",
    'aliases' => array('vmbs'),
    'arguments' => array(
      'master' => dt('Master URL'),
      'domain' => dt('Master domain'),
    ),
  );
  $items['vm-create-test-user'] = array(
    'description' => "Create test user account",
    'aliases' => array('vmcu'),
    'arguments' => array(
      'name' => dt('Username'),
      'password' => dt('Password'),
    ),
  );

  $items['vm-change-username'] = array(
    'description' => "Enable authenticated users to change their username",
    'aliases' => array('vmchm'),
  );

  return $items;
}

function drush_vm_setup_bakery_master($master, $domain) {
  $slaves = drush_get_option('slaves');
  if (empty($master)) {
    return drush_set_error('ARGUMENT_ERROR', 'Specify master');
  }
  elseif (empty($slaves)) {
    return drush_set_error('OPTION_ERROR', 'Specify slave sites');
  }
  drush_unset_option('slaves');
  $slaves = explode(',', $slaves);
  $prior = drush_get_context('DRUSH_AFFIRMATIVE');
  drush_set_context('DRUSH_AFFIRMATIVE', TRUE);
  drush_invoke('en', 'bakery');
  drush_invoke('vset', array('bakery_is_master', 1));
  drush_invoke('vset', array('bakery_key', 'bakerysecret'));
  drush_invoke('vset', array('bakery_master', $master));
  drush_invoke('vset', array('bakery_domain', '.' . $domain));
  drush_invoke('vset', array('bakery_slaves', $slaves));
  drush_invoke('cc', 'all');
  drush_set_context('DRUSH_AFFIRMATIVE', $prior);
}

function drush_vm_setup_bakery_slave($master, $domain) {
  if (empty($master)) {
    return drush_set_error('ARGUMENT_ERROR', 'Specify master');
  }
  $prior = drush_get_context('DRUSH_AFFIRMATIVE');
  drush_set_context('DRUSH_AFFIRMATIVE', TRUE);
  drush_invoke('en', 'bakery');
  drush_invoke('vset', array('bakery_is_master', 0));
  drush_invoke('vset', array('bakery_key', 'bakerysecret'));
  drush_invoke('vset', array('bakery_master', $master));
  drush_invoke('vset', array('bakery_domain', '.' . $domain));
  drush_invoke('cc', 'all');
  drush_set_context('DRUSH_AFFIRMATIVE', $prior);
}

function drush_vm_create_test_user($name, $password) {
  drush_set_option('mail', $name . '@example.com');
  drush_set_option('password', $password);
  if (!empty($name) && !empty($password)) {
    drush_invoke('user-create', $name);
  }
}

/**
 * Enable authenticated users to change their username
 */
function drush_vm_change_username() {
  $version = drush_drupal_version();
  if (strpos($version, '7') === 0) {
    drush_print("Set permission");
  }
  elseif (strpos($version, '6') === 0) {
    drush_print("Set permission");
  }
}
