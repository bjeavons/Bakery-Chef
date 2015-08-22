<?php

/**
 * Implementation of hook_user_default_permissions().
 */
function vm_bakery_user_default_permissions() {
  $permissions = array();

  // Exported permission: change own username
  $permissions['change own username'] = array(
    'name' => 'change own username',
    'roles' => array(),
  );

  return $permissions;
}
