<?php
/**
 * @file
 * vm_bakery.features.user_permission.inc
 */

/**
 * Implements hook_user_default_permissions().
 */
function vm_bakery_user_default_permissions() {
  $permissions = array();

  // Exported permission: change own username.
  $permissions['change own username'] = array(
    'name' => 'change own username',
    'roles' => array(
      0 => 'administrator',
      1 => 'authenticated user',
    ),
    'module' => 'user',
  );

  return $permissions;
}
