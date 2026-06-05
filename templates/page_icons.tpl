{strip}
{if $gBitUser->hasPermission( 'p_users_view_icons_and_tools')}
	<div class="floaticon">
		{include file="bitpackage:liberty/services_inc.tpl" serviceLocation='icon' serviceHash=$gContent->mInfo}

		{if $gBitSystem->isFeatureActive( 'wiki_like_pages' )}
			<a href="{$smarty.const.WIKI_PKG_URL}like_pages.php?page_id={$gContent->mInfo.page_id}">{biticon ipackage="icons" iname="applications-accessories" iexplain="Similar Pages"}</a>
		{/if}

		{if $gContent->isLocked()}
			{if $gContent->hasAdminPermission() || ($gContent->isOwner() && $gContent->hasUserPermission( 'p_wiki_lock_page' ) && $gBitSystem->isFeatureActive( 'wiki_usrlock' ))}
				<a href="{$smarty.const.WIKI_PKG_URL}index.php?page_id={$gContent->mInfo.page_id}&amp;action=unlock">{biticon ipackage="icons" iname="lock" iexplain="Unlock this page"}</a>
			{else}
				{biticon ipackage="icons" iname="lock" iexplain="Locked"}
			{/if}
		{else}
			{assign var=format_guid value=$gContent->mInfo.format_guid}
			{if $gLibertySystem->mPlugins.$format_guid.is_active eq 'y' || $gContent->hasAdminPermission()}
				{if $gContent->hasUpdatePermission()}
					{if $gContent->hasAdminPermission() || ($gContent->isOwner() && $gContent->hasUserPermission( 'p_wiki_lock_page' ) && $gBitSystem->isFeatureActive( 'wiki_usrlock' ))}
						<a href="{$smarty.const.WIKI_PKG_URL}index.php?page_id={$gContent->mInfo.page_id}&amp;action=lock">{biticon ipackage="icons" iname="lock" iexplain="Lock this page"}</a>
					{/if}
					<a href="{$smarty.const.WIKI_PKG_URL}edit.php?page_id={$gContent->mInfo.page_id}">{biticon ipackage="icons" iname="document-properties" iexplain="Edit"}</a>
				{/if}
			{/if}

			{if $gBitSystem->isFeatureActive( 'wiki_undo' ) && $gContent->hasUserPermission('p_wiki_rollback')}
				<a href="{$smarty.const.WIKI_PKG_URL}index.php?page_id={$gContent->mInfo.page_id}&amp;undo=1">{biticon ipackage="icons" iname="edit-undo" iexplain="Undo last edit"}</a>
			{/if}

			{if $gBitSystem->isFeatureActive( 'wiki_history' ) && $gContent->hasUserPermission('p_wiki_view_history')}
				<a href="{$smarty.const.WIKI_PKG_URL}page_history.php?page_id={$gContent->mInfo.page_id}" rel="nofollow">{biticon ipackage="icons" iname="appointment" iexplain=History}</a>
			{/if}
		{/if}

		{if !empty($structureInfo.structure_id) && ($gStructure->mInfo.creator_user_id == $gBitUser->mUserId || $gContent->hasUserPermission( 'p_wiki_admin_book' ))}
			<a href="{$smarty.const.WIKI_PKG_URL}edit_book.php?structure_id={$structureInfo.structure_id}">{biticon ipackage="icons" iname="preferences-system" iexplain="Edit book"}</a>
		{elseif is_a($gContent,'BitBook') && $gContent->hasUpdatePermission()}
			<a href="{$smarty.const.WIKI_PKG_URL}edit_book.php?content_id={$gContent->mContentId}">{biticon ipackage="icons" iname="preferences-system" iexplain="Edit book"}</a>
		{/if}

		{if $gBitUser->isRegistered() && $gBitUser->mUserId && $gBitSystem->isFeatureActive( 'users_watches' ) }
			{if $user_watching_page eq 'y'}
				<a title="{tr}stop monitoring this page{/tr}" href="{$smarty.const.WIKI_PKG_URL}index.php?page_id={$gContent->mInfo.page_id}&amp;watch_event=wiki_page_changed&amp;watch_object={$gContent->mInfo.page_id}&amp;watch_action=remove">{biticon ipackage="icons" iname="emblem-readonly" iexplain="Stop monitoring"}</a>
			{else}
				<a title="{tr}monitor this page{/tr}" href="{$smarty.const.WIKI_PKG_URL}index.php?page_id={$gContent->mInfo.page_id}&amp;watch_event=wiki_page_changed&amp;watch_object={$gContent->mInfo.page_id}&amp;watch_action=add">{biticon ipackage="icons" iname="emblem-unreadable" iexplain="Monitor"}</a>
			{/if}
		{/if}

		{if $gBitSystem->isFeatureActive( 'users_watches' ) && $gContent->hasUserPermission('p_users_admin')}
			<a href="{$smarty.const.WIKI_PKG_URL}page_watches.php?page_id={$gContent->mInfo.page_id}">{biticon ipackage="icons" iname="user-desktop" iexplain="Watches"}</a>
		{/if}

{* seem to be broken
		{if $gBitUser->hasPermission( 'p_wiki_admin' )}
			<li><a href="{$smarty.const.WIKI_PKG_URL}export_wiki_pages.php?page_id={$gContent->mInfo.page_id}">{biticon ipackage="icons" iname="go-up" iexplain="Export"}</a></li>
		{/if}
*}

		{if $gBitSystem->isFeatureActive( 'wiki_uses_slides' )}
			{if $show_slideshow eq 'y'}
				<a href="{$smarty.const.WIKI_PKG_URL}slideshow.php?page_id={$gContent->mInfo.page_id}">{biticon ipackage="icons" iname="camera-video" iexplain="Slideshow"}</a>
			{elseif $structure eq 'y'}
				<a href="{$smarty.const.WIKI_PKG_URL}slideshow2.php?structure_id={$page_info.structure_id}">{biticon ipackage="icons" iname="camera-video" iexplain="Slideshow"}</a>
			{/if}
		{/if}

		{if $gContent->mInfo.title ne 'SandBox' && !$gContent->isLocked()}
			{if $gContent->isOwner() || $gContent->hasUserPermission( 'p_wiki_remove_page' )}
				<a title="{tr}Remove this page{/tr}" href="{$smarty.const.WIKI_PKG_URL}remove_page.php?page_id={$gContent->mInfo.page_id}&amp;version=last">{biticon ipackage="icons" iname="user-trash" iexplain="Delete"}</a>
			{/if}
		{/if}

		{if $gBitSystem->isFeatureActive( 'wiki_backlinks' ) && $backlinks}
			<div class="btn-group">
				<button class="btn btn-xs dropdown-toggle" data-toggle="dropdown">
				  {biticon ipackage="icons" iname="emblem-symbolic-link"}
				  <span class="caret"></span>
				</button>
				<ul class="dropdown-menu pull-right">
					{foreach item=backPage from=$backlinks}
						<li><a href="{$smarty.const.BIT_ROOT_URL}{$backPage.url}">{$backPage.title|escape|truncate:30:"&hellip;":true}</a></li>
					{/foreach}
				</ul>
			  </div>
		{/if}

		{if !empty($showstructs) && count($showstructs) gt 0}
			<select id="sel-structures" name="page" onchange="javascript:BitBase.go(this)">
				<option value="">{tr}Wiki Books{/tr} &hellip;</option>
				{section name=struct loop=$showstructs}
					<option value="{$smarty.const.WIKI_PKG_URL}index.php?structure_id={$showstructs[struct].structure_id}">
						{$showstructs[struct].root_title}
					</option>
				{/section}
			</select>
		{/if}
	</div>
{/if}
{/strip}
