<?php
/**
 */
global $gBitInstaller;

$infoHash = [
	'package'      => WIKI_PKG_NAME,
	'version'      => str_replace( '.php', '', basename( __FILE__ )),
	'description'  => "Fixed new format updates",
	'post_upgrade' => NULL,
];

