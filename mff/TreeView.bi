﻿'################################################################################
'#  TreeView.bi                                                                 #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov(2018-2019)  Liu XiaLin                          #
'################################################################################

#include once "Control.bi"

Namespace My.Sys.Forms
	#define QTreeView(__Ptr__) (*Cast(TreeView Ptr, __Ptr__))
	#define QTreeNode(__Ptr__) (*Cast(TreeNode Ptr, __Ptr__))
	
	Private Type PTreeNode As TreeNode Ptr
	
	Private Type TreeNodeCollection Extends My.Sys.Object
	Private:
		FNodes As List
		FParentNode As PTreeNode
		PNode As PTreeNode
	Public:
		Parent   As Control Ptr
		Declare Property Count As Integer
		Declare Property Count(Value As Integer)
		Declare Property Item(Index As Integer) As PTreeNode
		Declare Property Item(Index As Integer, Value As PTreeNode)
		Declare Function Add(ByRef iText As WString = "", ByRef iKey As WString = "", ByRef iHint As WString = "", iImageIndex As Integer = -1, iSelectedImageIndex As Integer = -1, bSorted As Boolean = False) As PTreeNode
		Declare Function Add(ByRef iText As WString = "", ByRef iKey As WString = "", ByRef iHint As WString = "", ByRef iImageKey As WString, ByRef iSelectedImageKey As WString, bSorted As Boolean = False) As PTreeNode
		Declare Function Insert(Index As Integer, ByRef iText As WString = "", ByRef iKey As WString = "", ByRef iHint As WString = "", iImageIndex As Integer = -1, iSelectedImageIndex As Integer = -1) As PTreeNode
		Declare Function Insert(Index As Integer, ByRef iText As WString = "", ByRef iKey As WString = "", ByRef iHint As WString = "", ByRef iImageKey As WString, ByRef iSelectedImageKey As WString) As PTreeNode
		Declare Property ParentNode As PTreeNode
		Declare Property ParentNode(Value As PTreeNode)
		Declare Sub Remove(Index As Integer)
		Declare Function IndexOf(ByRef FNode As PTreeNode) As Integer
		Declare Function IndexOf(ByRef Text As WString) As Integer
		Declare Function IndexOfKey(ByRef Key As WString) As Integer
		Declare Function Contains(ByRef FNode As PTreeNode) As Boolean
		Declare Function Contains(ByRef Text As WString) As Boolean
		Declare Function ContainsKey(ByRef Key As WString) As Boolean
		#ifdef __USE_GTK__
			Declare Function FindByIterUser_Data(User_Data As Any Ptr) As PTreeNode
		#elseif defined(__USE_WINAPI__)
			Declare Function FindByHandle(hti As HTREEITEM) As PTreeNode
		#endif
		Declare Sub Clear
		Declare Sub Sort
		Declare Constructor
		Declare Destructor
	End Type
	
	Private Type TreeNode Extends My.Sys.Object
	Private:
		FName               As WString Ptr
		FText               As WString Ptr
		FHint               As WString Ptr
		FImageIndex         As Integer
		FImageKey           As WString Ptr
		FSelectedImageIndex As Integer
		FSelectedImageKey   As WString Ptr
		FParentNode         As PTreeNode
		FVisible            As Boolean
		FIsUpdated          As Boolean
		FIsDisposed         As Boolean
		FChecked            As Boolean
		FBold               As Boolean
	Protected:
		Declare Static Sub AddItems(Node As TreeNode Ptr)
	Public:
		Tag As Any Ptr
		Parent   As Control Ptr
		Nodes As TreeNodeCollection
		#ifdef __USE_GTK__
			TreeIter As GtkTreeIter
		#elseif defined(__USE_WINAPI__)
			Handle As HTREEITEM
		#endif
		Declare Sub SelectItem
		Declare Sub Collapse
		Declare Sub Expand
		Declare Sub EditLabel
		Declare Function IsExpanded As Boolean
		Declare Property Bold As Boolean
		Declare Property Bold(Value As Boolean)
		Declare Function Index As Integer
		Declare Virtual Function ToString ByRef As WString
		Declare Property Name ByRef As WString
		Declare Property Name(ByRef Value As WString)
		Declare Property Text ByRef As WString
		Declare Property Text(ByRef Value As WString)
		Declare Property Hint ByRef As WString
		Declare Property Hint(ByRef Value As WString)
		Declare Property IsUpdated As Boolean
		Declare Property IsUpdated(Value As Boolean)
		Declare Property Checked As Boolean
		Declare Property Checked(Value As Boolean)
		Declare Property ImageIndex As Integer
		Declare Property ImageIndex(Value As Integer)
		Declare Property SelectedImageIndex As Integer
		Declare Property SelectedImageIndex(Value As Integer)
		Declare Property ImageKey ByRef As WString
		Declare Property ImageKey(ByRef Value As WString)
		Declare Property SelectedImageKey ByRef As WString
		Declare Property SelectedImageKey(ByRef Value As WString)
		Declare Property ParentNode As TreeNode Ptr
		Declare Property ParentNode(Value As TreeNode Ptr)
		Declare Property Visible As Boolean
		Declare Property Visible(Value As Boolean)
		Declare Function IsDisposed As Boolean
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
		OnClick As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As My.Sys.Object)
		OnDblClick As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As My.Sys.Object)
	End Type
	
	'`TreeView` is a Control within the MyFbFramework, part of the freeBasic framework.
	'`TreeView` - Represents a control that displays hierarchical data in a tree structure that has items that can expand and collapse.
	Private Type TreeView Extends Control
	Private:
		'FNodes        As List
		FSorted As Boolean
		FHideSelection As Boolean
		FEditLabels As Boolean
	Protected:
		#ifdef __USE_GTK__
			Dim As GtkCellRenderer Ptr rendertext
			Dim As TreeNode Ptr PrevNode
			TreeStore As GtkTreeStore Ptr
			TreeSelection As GtkTreeSelection Ptr
			Declare Static Sub TreeView_RowActivated(tree_view As GtkTreeView Ptr, path As GtkTreePath Ptr, column As GtkTreeViewColumn Ptr, user_data As Any Ptr)
			Declare Static Sub TreeView_SelectionChanged(selection As GtkTreeSelection Ptr, user_data As Any Ptr)
			Declare Static Function TreeView_ButtonRelease(widget As GtkWidget Ptr, e As GdkEvent Ptr, user_data As Any Ptr) As Boolean
			Declare Static Function TreeView_QueryTooltip(widget As GtkWidget Ptr, x As gint, y As gint, keyboard_mode As Boolean, tooltip As GtkTooltip Ptr, user_data As Any Ptr) As Boolean
			Declare Static Sub Cell_Editing(cell As GtkCellRenderer Ptr, editable As GtkCellEditable Ptr, path As Const gchar Ptr, user_data As Any Ptr)
			Declare Static Sub Cell_Edited(renderer As GtkCellRendererText Ptr, path As gchar Ptr, new_text As gchar Ptr, user_data As Any Ptr)
			Declare Static Function TestCollapseRow(tree_view As GtkTreeView Ptr, iter As GtkTreeIter Ptr, path As GtkTreePath Ptr, user_data As Any Ptr) As Boolean
			Declare Static Function TestExpandRow(tree_view As GtkTreeView Ptr, iter As GtkTreeIter Ptr, path As GtkTreePath Ptr, user_data As Any Ptr) As Boolean
			Declare Static Function RowCollapsed(tree_view As GtkTreeView Ptr, iter As GtkTreeIter Ptr, path As GtkTreePath Ptr, user_data As Any Ptr) As Boolean
			Declare Static Function RowExpanded(tree_view As GtkTreeView Ptr, iter As GtkTreeIter Ptr, path As GtkTreePath Ptr, user_data As Any Ptr) As Boolean
		#elseif defined(__USE_WINAPI__)
			Declare Static Sub WndProc(ByRef Message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
			Declare Static Sub HandleIsDestroyed(ByRef Sender As Control)
			Declare Sub SendToAllChildItems(ByVal hNode As HTREEITEM, tvMessage As Long)
			Declare Sub CreateNodes(PNode As TreeNode Ptr)
		#elseif defined(__USE_WASM__)
			Declare Virtual Function GetContent() As UString
			Declare Function CreateNodes(PNodes As TreeNode Ptr) As UString
		#endif
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
	Public:
		#ifndef ReadProperty_Off
			'Loads persisted tree structure
			Declare Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			'Saves tree configuration
			Declare Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		'Image list for normal node icons
		Images          As ImageList Ptr
		'Image list for selected node icons
		SelectedImages  As ImageList Ptr
		'Root node collection of the tree
		Nodes           As TreeNodeCollection
		Declare Property TabIndex As Integer
		'Tab navigation order index
		Declare Property TabIndex(Value As Integer)
		Declare Property TabStop As Boolean
		'Enables Tab key navigation
		Declare Property TabStop(Value As Boolean)
		'Collapses all expanded nodes
		Declare Sub CollapseAll
		'Expands all collapsible nodes
		Declare Sub ExpandAll
		Declare Property EditLabels As Boolean
		'Enables in-place editing of node text
		Declare Property EditLabels(Value As Boolean)
		Declare Property HideSelection As Boolean
		'Hides selection highlight when control loses focus
		Declare Property HideSelection(Value As Boolean)
		Declare Property Sorted As Boolean
		'Auto-sorts sibling nodes alphabetically
		Declare Property Sorted(Value As Boolean)
		Declare Property ShowHint As Boolean
		'Displays tooltips for truncated node text
		Declare Property ShowHint(Value As Boolean)
		Declare Property SelectedNode As TreeNode Ptr
		'Currently highlighted tree node
		Declare Property SelectedNode(Value As TreeNode Ptr)
		'Returns node being dragged during OLE operations
		Declare Function DraggedNode As TreeNode Ptr
		Declare Operator Cast As Control Ptr
		Declare Constructor
		Declare Destructor
		'Raised when node is activated via keyboard
		OnNodeActivate    As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TreeView, ByRef Item As TreeNode)
		'Triggered on mouse click node selection
		OnNodeClick       As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TreeView, ByRef Item As TreeNode)
		'Double-click node detection
		OnNodeDblClick    As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TreeView, ByRef Item As TreeNode)
		'Before node collapse occurs
		OnNodeCollapsing  As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TreeView, ByRef Item As TreeNode, ByRef Cancel As Boolean)
		'After node collapse completes
		OnNodeCollapsed   As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TreeView, ByRef Item As TreeNode)
		'Before node expansion occurs
		OnNodeExpanding   As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TreeView, ByRef Item As TreeNode, ByRef Cancel As Boolean)
		'After node expansion completes
		OnNodeExpanded    As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TreeView, ByRef Item As TreeNode)
		'Before selection changes
		OnSelChanging     As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TreeView, ByRef Item As TreeNode, ByRef Cancel As Boolean)
		'After selection changes
		OnSelChanged      As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TreeView, ByRef Item As TreeNode)
		'Triggered before node text editing begins
		OnBeforeLabelEdit As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TreeView, ByRef Item As TreeNode, ByRef NodeLabel As WString, ByRef Cancel As Boolean)
		'Raised after node text editing completes
		OnAfterLabelEdit  As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TreeView, ByRef Item As TreeNode, ByRef NodeLabel As WString, ByRef Cancel As Boolean)
	End Type
End Namespace

'TODO:
'const TVS_HASBUTTONS = &h1
'const TVS_HASLINES = &h2
'const TVS_LINESATROOT = &h4
'const TVS_EDITLABELS = &h8
'const TVS_DISABLEDRAGDROP = &h10
'const TVS_SHOWSELALWAYS = &h20
'const TVS_RTLREADING = &h40
'const TVS_NOTOOLTIPS = &h80
'const TVS_CHECKBOXES = &h100
'const TVS_TRACKSELECT = &h200
'const TVS_SINGLEEXPAND = &h400
'const TVS_INFOTIP = &h800
'const TVS_FULLROWSELECT = &h1000
'const TVS_NOSCROLL = &h2000
'const TVS_NONEVENHEIGHT = &h4000
'const TVS_NOHSCROLL = &h8000
'const TVS_EX_NOSINGLECOLLAPSE = &h1
'
#ifdef __USE_WINAPI__ '_WIN32_WINNT = &h0602
	Const TVS_EX_MULTISELECT = &h2
	Const TVS_EX_DOUBLEBUFFER = &h4
	Const TVS_EX_NOINDENTSTATE = &h8
	Const TVS_EX_RICHTOOLTIP = &h10
	Const TVS_EX_AUTOHSCROLL = &h20
	Const TVS_EX_FADEINOUTEXPANDOS = &h40
	Const TVS_EX_PARTIALCHECKBOXES = &h80
	Const TVS_EX_EXCLUSIONCHECKBOXES = &h100
	Const TVS_EX_DIMMEDCHECKBOXES = &h200
	Const TVS_EX_DRAWIMAGEASYNC = &h400
#endif

#ifndef __USE_MAKE__
	#include once "TreeView.bas"
#endif
