/*BEGIN TreeView */
		
	.TreeView{
		background-color:#F3F3EC;
		padding: 0.80em;
		font-size: 109%;
		text-align: left;
	}
	
	.TreeView .folderNodeSpan{
		white-space:nowrap;
	}
	
	.TreeView .helpTreeHeading{
		font-weight:bold;
	}
	
	.TreeView .treeLine {
		background-color:#333;
		height:1px;
		margin-top: 0.33em;
		margin-bottom: 0.69em;
		font-size:0%;
	
	}
	
	.TreeView h2 {
		display:block;
		margin-top:15px;
		font-weight:bold;
		padding:0.33em 0.33em 0.33em 0.00em;
		border-bottom: 2px solid #ccc;
	}
	
	.helpTree {
		font-size: 88%;
	}
	
	.helpTree .TreeView .treeLeaf,
	.helpTree .TreeView .treeHighlightLeaf{
		padding-bottom:2px;
	
	}
	.TreeView .treeHighlightLeaf {
		background-color:#fff;
		margin-left:1.27em;
		padding-bottom:0.15em;
		margin-right:-0.5em;
	}
	
	
	.newFlag {
		margin-left:0.5em;
		color: #f00;
		font-size:0.8em;
	}
	
	.TreeView .treeHighlightLeaf a {
		text-decoration:none;
	}
	
	.TreeView .treeLeaf{
		margin-left:1.27em;
		padding-top: 2px;
		padding-bottom: 2px;
	}
	
	.TreeView  a:hover  {
	   text-decoration: underline;
	}
	
	.TreeView a.treeHighlightFolder{
		text-decoration:none;
		background-color:#fff;
	}
	
	.TreeView .parent {
		padding-bottom: 1px;
		padding-top: 1px;
	}
	
	.treeFolder {
		text-decoration: none;
	}
	
	.childContainer{
			margin-left: 1.00em;
	}
	
	.treeLeaf a {
		text-decoration: none;
	}
	
	.treeSection {
	   font-weight:bold;
	   text-decoration: none;
	   padding:0.33em;
	}
	
	.treeLink {
	   font-weight:bold;
	   text-decoration: underline;
	   padding:0.33em;
	}
	
	.treeImage {
		padding: 0.33em 0.33em 0.07em 0.33em;
		cursor:pointer;
	}				
	
	/* Text in headers of Get Info boxes in Setup should be bold white,
	   but DON'T USE IT! */
	.bodyBoldWhite {
		color: #FFF;
		font-weight: bold;
	}		

/*END TreeView */