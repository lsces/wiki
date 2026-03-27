{strip}
{if $gBitSystem->isPackageActive( 'rss' ) && $gBitSystem->isFeatureActive( 'wiki_rss' ) && $gBitSystem->getActivePackage() eq 'wiki' && $gBitUser->hasPermission( 'p_wiki_view_page' )}
	<link rel="alternate" type="application/rss+xml"
		title="{$gBitSystem->getConfig('fisheye_rss_title',"Wiki RSS")}"
		href="{$smarty.const.WIKI_PKG_URL}wiki_rss.php?version={$gBitSystem->getConfig('rssfeed_default_version',0)}
	{if $gBitSystem->getConfig( 'rssfeed_httpauth' ) && $gBitUser->isRegistered()} &httpauth=y{/if}" />
{/if}
{/strip}
