<?php
/**
 * @version  $Revision: 1.6 $
 * @package  liberty
 * @subpackage plugins_data
 */
/**
 * definitions
 */
namespace Bitweaver\Liberty;

use Bitweaver\KernelTools;
global $gBitSystem, $gLibertySystem;

// only include this plugin if wiki is active and we have GraphViz
if( @include_once 'Image/GraphViz.php' ) {

define( 'PLUGIN_GUID_DATAWIKIGRAPH', 'datawikigraph' );
$pluginParams = [
	'tag'           => 'wikigraph',
	'auto_activate' => false,
	'requires_pair' => true,
	'load_function' => 'data_wikigraph',
	'title'         => 'WikiGraph',
	'help_page'     => 'DataPluginWikiGraph',
	'description'   => KernelTools::tra( "Inserts a graph for visual navigation. The graph shows the page and every page that can be reached from that page. It requies the Image_GraphViz pear plugin and graphviz to be installed: <strong>pear install Image_GraphViz</strong>" ),
	'help_function' => 'data_wikigraph_help',
	'syntax'        => "{wikigraph level= title= }".KernelTools::tra( "Wiki page name" )."{/wikigraph}",
	'plugin_type'   => DATA_PLUGIN
];
$gLibertySystem->registerPlugin( PLUGIN_GUID_DATAWIKIGRAPH, $pluginParams );
$gLibertySystem->registerDataTag( $pluginParams['tag'], PLUGIN_GUID_DATAWIKIGRAPH );

function data_wikigraph_help() {
	$help =
		'<table class="data help">'
			.'<tr>'
				.'<th>'.KernelTools::tra( "Key" ).'</th>'
				.'<th>'.KernelTools::tra( "Type" ).'</th>'
				.'<th>'.KernelTools::tra( "Comments" ).'</th>'
			.'</tr>'
			.'<tr class="odd">'
				.'<td>level</td>'
				.'<td>'.KernelTools::tra( "numeric").'<br />'.KernelTools::tra( "(optional)" ).'</td>'
				.'<td>'.KernelTools::tra( "The number of levels that will be followed from the starting page." ).' '.KernelTools::tra( "Default").': 0</td>'
			.'</tr>'
			.'<tr class="even">'
				.'<td>title</td>'
				.'<td>'.KernelTools::tra( "string").'<br />'.KernelTools::tra( "(optional)" ).'</td>'
				.'<td>'.KernelTools::tra( "Title of the graph.").' '.KernelTools::tra( "Default ").': Wiki-Graph</td>'
			.'</tr>'
			.'<tr class="odd">'
				.'<td>nodesep</td>'
				.'<td>'.KernelTools::tra( "numeric").'<br />'.KernelTools::tra( "(optional)" ).'</td>'
				.'<td>'.KernelTools::tra( "Distance between nodes in inches.").' '.KernelTools::tra( "Default").': 1.2</td>'
			.'</tr>'
			.'<tr class="even">'
				.'<td>rankdir</td>'
				.'<td>'.KernelTools::tra( "string").'<br />'.KernelTools::tra( "(optional)" ).'</td>'
				.'<td>'.KernelTools::tra( "Direction of graph layout - can be Left to Right (LR), Right to Left (RL), Top to Bottom (TB), Bottom to Top (BT).").' '.KernelTools::tra( "Default").': TB</td>'
			.'</tr>'
			.'<tr class="odd">'
				.'<td>bgcolor</td>'
				.'<td>'.KernelTools::tra( "html colour").'<br />'.KernelTools::tra( "(optional)" ).'</td>'
				.'<td>'.KernelTools::tra( "Background colour of the graph.").' '.KernelTools::tra( "Default").': KernelTools::transparent</td>'
			.'</tr>'
			.'</table>'
		.KernelTools::tra( "Example: " )."{wikigraph level=1}Welcome{/wikigraph}";
	return $help;
}

function data_wikigraph( $pData, $pParams ) {
	global $gContent, $gBitThemes;
	$ret = " ";

	// check to see if we have pear available.
//	if( $error = pear_check( "Image/GraphViz.php" )) {
//		return $error;
//	}

	if( !empty( $gContent ) && is_object( $gContent )) {
		$querystring = "";

		$title = !empty( $pParams['title'] ) ? $pParams['title'] : 'Wiki-Graph';
		unset( $pParams['title'] );

		foreach( $pParams as $param => $value ) {
			$querystring .= "&amp;{$param}={$value}";
		}

		if( empty( $pData ) ) {
			$pData = ( is_object( $gContent ) || !empty( $gContent->mPageName )) ? $gContent->mPageName : null;
		}

		if( !empty( $pData ) ) {
			$params = array(
				'graph' => $gBitThemes->getGraphvizGraphAttributes( $pParams ),
				'node'  => $gBitThemes->getGraphvizNodeAttributes( $pParams ),
				'edge'  => $gBitThemes->getGraphvizEdgeAttributes( $pParams ),
			);

			$mapname = md5( microtime() );
			$mapdata = $gContent->linkStructureMap( $pData, isset( $pParams['level'] ) ? $pParams['level'] : 0, $params );

			$ret = "
				<div style='text-align:center'>
				<img src=\"".WIKI_PKG_URL."wiki_graph.php?page=".urlencode( $pData )."{$querystring}\" alt='{$title}' usemap='#$mapname' />
				<map name='$mapname'>$mapdata</map>
				</div>";
			$ret = preg_replace( "/\n|\r/", '', $ret );
		}
	}
	return $ret;
}

} // graphviz check
