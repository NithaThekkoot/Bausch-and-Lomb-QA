var ITBTreeNode=function(){};
var treeInfo;

function setTreeInformation(info){
	treeInfo = info;
}
		
ITBTreeNode.prototype.toggleHTMLTree=function(topic){
	var obj=ITBTreeNode.prototype.getNodeChild(topic);
	if(obj!=null){
		var visible=ITBTreeNode.prototype.isVisible(obj);
		if(visible){
			ITBTreeNode.prototype.close(obj,topic);
			SetupTreeNode.prototype.removeFromOpenSetup(topic);
		} else{
			ITBTreeNode.prototype.open(obj,topic);
		}
	}
};
		
ITBTreeNode.prototype.isVisible=function(obj){
	return obj.style.display!="none";
};
	
ITBTreeNode.prototype.setVisible=function(obj,visible){
	if(obj){
		if(visible){
			obj.style.display="";
		} else{
			obj.style.display="none";
		}
	}
};
		
ITBTreeNode.prototype.getNode=function(topic){
	var informationDiv=document.getElementById(treeInfo);
	if(informationDiv==null){
		return;
	}
	return document.getElementById(topic);
};
		
ITBTreeNode.prototype.getNodeChild=function(topic){
	var informationDiv=document.getElementById(treeInfo);
	if(informationDiv==null){
		return;
	}
	var id=topic+informationDiv.getAttribute("child");
	return document.getElementById(id);
};
		
ITBTreeNode.prototype.open=function(obj,topic){
	var informationDiv=document.getElementById(treeInfo);
	if(informationDiv==null){
		return;
	}
	obj.style.display="block";
	//var key=document.getElementById(topic+informationDiv.getAttribute("icon"));
	var key = document.getElementById(topic);
	if(key!=null){
		var currentTitle=key.getElementsByTagName("img")[0].title;
		var image=key.getElementsByTagName("img")[0];
		image.src=informationDiv.getAttribute("minusSrc");
		image.title=ITBTreeNode.prototype.changePreTitle(currentTitle,informationDiv.getAttribute("collapse"));
		image.alt=ITBTreeNode.prototype.changePreTitle(currentTitle,informationDiv.getAttribute("collapse"));
	}
};
		
ITBTreeNode.prototype.close=function(obj,topic){
	var informationDiv=document.getElementById(treeInfo);
	if(informationDiv==null){
		return;
	}
	obj.style.display="none";
	//var key=document.getElementById(topic+informationDiv.getAttribute("icon"));
	var key = document.getElementById(topic);
	if(key!=null){
		var currentTitle=key.getElementsByTagName("img")[0].title;
		var image=key.getElementsByTagName("img")[0];
		image.src=informationDiv.getAttribute("plusSrc");
		image.title=ITBTreeNode.prototype.changePreTitle(currentTitle,informationDiv.getAttribute("expand"));
		image.alt=ITBTreeNode.prototype.changePreTitle(currentTitle,informationDiv.getAttribute("expand"));
	}
};
		
ITBTreeNode.prototype.changePreTitle=function(currentTitle,preTitle){
	return preTitle+" "+currentTitle.substr(currentTitle.indexOf("-"));
};
	
ITBTreeNode.prototype.openHTMLTree=function(sectionEsc,topicEsc){
	var section=(sectionEsc)?unescapeJsInHtml(sectionEsc):null;
	var topic=(topicEsc)?unescapeJsInHtml(topicEsc):null;
	var informationDiv=document.getElementById(treeInfo);
	if(informationDiv==null){
		return;
	}
	if(topic!=null){
		ITBTreeNode.prototype.unHighlightAll();
		var leaf=document.getElementById(topic+informationDiv.getAttribute("leaf"));
		if(leaf&&leaf.className){
			leaf.className="treeHighlightLeaf";
			informationDiv.setAttribute("lastHighlight",topic+informationDiv.getAttribute("leaf"));
		}
	}
	var obj=document.getElementById(section+informationDiv.getAttribute("child"));
	if(obj==null&&topic!=null){
		var leaf=document.getElementById(topic+informationDiv.getAttribute("leaf"));
		if(leaf!=null){
			var divParent=leaf.parentNode;
			if(divParent!=null&&divParent.id.indexOf(informationDiv.getAttribute("child"))>0){
				section=divParent.id.substr(0,divParent.id.indexOf(informationDiv.getAttribute("child")));
				obj=divParent;
			}
		}
	}
	if(obj!=null){
		var key=document.getElementById(section+informationDiv.getAttribute("icon"));
		var currentTitle=key.getElementsByTagName("img")[0].title;
		obj.style.display="block";
		var image=key.getElementsByTagName("img")[0];
		image.src=informationDiv.getAttribute("minusSrc");
		image.title=ITBTreeNode.prototype.changePreTitle(currentTitle,informationDiv.getAttribute("collapse"));
		image.alt=ITBTreeNode.prototype.changePreTitle(currentTitle,informationDiv.getAttribute("collapse"));
		var divParent=obj.parentNode;
		if(divParent!=null){
			divParent=divParent.parentNode;
			if(divParent!=null&&divParent.id.indexOf(informationDiv.getAttribute("child"))>0){
				var section=divParent.id.substr(0,divParent.id.indexOf(informationDiv.getAttribute("child")));
				ITBTreeNode.prototype.openHTMLTree(section,null);
			}
		}
		if(topic!=null){
			window.scrollTo(0,key.offsetTop);
		}
	} else{
		if(topic!=null){
			var leaf=document.getElementById(topic+informationDiv.getAttribute("leaf"));
			if(leaf!=null){
				window.scrollTo(0,leaf.offsetTop);
			}
		}
	}
};
		
ITBTreeNode.prototype.unHighlightAll=function(){
	var informationDiv=document.getElementById(treeInfo);
	if(informationDiv==null){
		return;
	}
	var lastHighlight=informationDiv.getAttribute("lastHighlight");
	if(lastHighlight==null){
		return;
	}
	var elementH=document.getElementById(lastHighlight);
	if(elementH!=null&&elementH.className==informationDiv.getAttribute("highlightClass")){
		elementH.className=informationDiv.getAttribute("leafClass");
	}
};
		
ITBTreeNode.prototype.populateTheTreeInformation=function(infoelement,font,child,icon,leaf,expand,collapse,plusSrc,minusSrc,highlightClass,leafClass){
	var informationDiv=document.getElementById(infoelement);
	if(informationDiv==null){
		return;
	}
	setTreeInformation(infoelement);
	informationDiv.setAttribute("font",font);
	informationDiv.setAttribute("child",child);
	informationDiv.setAttribute("icon",icon);
	informationDiv.setAttribute("leaf",leaf);
	informationDiv.setAttribute("expand",expand);
	informationDiv.setAttribute("collapse",collapse);
	informationDiv.setAttribute("plusSrc",plusSrc);
	informationDiv.setAttribute("minusSrc",minusSrc);
	informationDiv.setAttribute("highlightClass",highlightClass);
	informationDiv.setAttribute("leafClass",leafClass);
	informationDiv.setAttribute("lastHighlight","none");
};