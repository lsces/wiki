{strip}
{if !empty($packageMenuTitle)}<a class="dropdown-toggle" data-toggle="dropdown" href="#"> {tr}{$packageMenuTitle}{/tr} <b class="caret"></b></a>{/if}
<ul class="{$packageMenuClass}">
	{if $gBitUser->hasPermission( 'p_wiki_view_page' )}
		<li><a class="item" href="{$smarty.const.WIKI_PKG_URL}index.php">{biticon ipackage="icons" iname="user-home" iexplain="`$smarty.const.WIKI_PKG_DIR|ucwords` Home" ilocation=menu}</a></li>
	{/if}
	{if $gBitUser->hasPermission( 'p_wiki_list_pages' )}
		<li><a class="item" href="{$smarty.const.WIKI_PKG_URL}list_pages.php">{biticon ipackage="icons" iname="text-x-generic" iexplain="List Pages" ilocation=menu}</a></li>
	{/if}
	{if $gBitUser->hasPermission( 'p_wiki_create_page' )}
		<li><a class="item" href="{$smarty.const.WIKI_PKG_URL}edit.php">{biticon ipackage="icons" iname="text-x-generic" iexplain="Create Page" ilocation=menu}</a></li>
	{/if}
	{if $gBitUser->hasPermission( 'p_wiki_list_pages' ) && $gBitSystem->isFeatureActive( 'wiki_books' )}
		<li><a class="item" href="{$smarty.const.WIKI_PKG_URL}books.php">{biticon ipackage="icons" iname="help-browser" iexplain="`$smarty.const.WIKI_PKG_DIR|ucwords` Books" ilocation=menu}</a></li>
	{/if}
	{if $gBitSystem->isFeatureActive( 'wiki_books' ) && $gBitUser->hasPermission( 'p_wiki_create_book' )}
		<li><a class="item" href="{$smarty.const.WIKI_PKG_URL}edit_book.php">{biticon ipackage="icons" iname="help-browser" iexplain="Create Book" ilocation=menu}</a></li>
	{/if}
	{if $gBitSystem->isFeatureActive( 'wiki_list_orphans' ) && $gBitUser->hasPermission( 'p_wiki_update_page' )}
		<li><a class="item" href="{$smarty.const.WIKI_PKG_URL}orphan_pages.php">{biticon ipackage="icons" iname="edit-find" iexplain="Orphan Pages" ilocation=menu}</a></li>
	{/if}
	{if $gBitSystem->isFeatureActive( 'wiki_multiprint' ) && $gBitUser->hasPermission( 'p_wiki_view_page' )}
		<li><a class="item" href="{$smarty.const.WIKI_PKG_URL}print_pages.php">{biticon ipackage="icons" iname="document-print"   iexplain="Print" ilocation=menu}</a></li>
	{/if}
	{if $gBitUser->hasPermission( 'p_wiki_list_pages' )}
		<li><a class="item" href="{$smarty.const.WIKI_PKG_URL}rankings.php">{biticon ipackage="icons" iname="text-x-generic" iexplain="`$smarty.const.WIKI_PKG_DIR|ucwords` Rankings" ilocation=menu}</a></li>
	{/if}
	{if $gBitSystem->isPackageActive( 'rss' )}
	<li><a title="{tr}Wiki Update RSS Feed{/tr}" href="{$smarty.const.RSS_PKG_URL}index.php?pkg=wiki">{biticon ipackage="icons" iname="network-transmit" ipackage=rss iexplain="Changes Feed" ilocation=menu}</a></li>
	{/if}
</ul>
{/strip}
