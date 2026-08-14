'################################################################################
'#  RichTextBox.bi                                                              #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov(2018-2019)  Liu XiaLin                          #
'################################################################################

#include once "RichTextBox.bi"
#ifndef __USE_GTK__
	#include once "win/richole.bi"
#endif

Namespace My.Sys.Forms
	#ifndef ReadProperty_Off
		Private Function RichTextBox.ReadProperty(ByRef PropertyName As String) As Any Ptr
			Select Case LCase(PropertyName)
			Case "editstyle": Return @FEditStyle
			Case "selalignment": FSelIntVal = SelAlignment: Return @FSelIntVal
			Case "selbackcolor": FSelIntVal = SelBackColor: Return @FSelIntVal
			Case "selbold": FSelBoolVal = SelBold: Return @FSelBoolVal
			Case "selbullet": FSelBoolVal = SelBullet: Return @FSelBoolVal
			Case "selcharoffset": FSelIntVal = SelCharOffset: Return @FSelIntVal
			Case "selcharset": FSelIntVal = SelCharSet: Return @FSelIntVal
			Case "selcolor": FSelIntVal = SelColor: Return @FSelIntVal
			Case "selfontname": WLet(FSelWStrVal, SelFontName): Return FSelWStrVal
			Case "selfontsize": FSelIntVal = SelFontSize: Return @FSelIntVal
			Case "selindent": FSelIntVal = SelIndent: Return @FSelIntVal
			Case "selitalic": FSelBoolVal = SelItalic: Return @FSelBoolVal
			Case "selprotected": FSelBoolVal = SelProtected: Return @FSelBoolVal
			Case "selrightindent": FSelIntVal = SelRightIndent: Return @FSelIntVal
			Case "selhangingindent": FSelIntVal = SelHangingIndent: Return @FSelIntVal
			Case "seltabcount": FSelIntVal = SelTabCount: Return @FSelIntVal
			Case "selunderline": FSelBoolVal = SelUnderline: Return @FSelBoolVal
			Case "selstrikeout": FSelBoolVal = SelStrikeout: Return @FSelBoolVal
			Case "tabindex": Return @FTabIndex
			Case "textrtf": TextRTF: Return FTextRTF
			Case "zoom": Return @FZoom
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif
	
	#ifndef WriteProperty_Off
		Private Function RichTextBox.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
			If Value = 0 Then
				Select Case LCase(PropertyName)
				Case Else: Return Base.WriteProperty(PropertyName, Value)
				End Select
			Else
				Select Case LCase(PropertyName)
				Case "editstyle": EditStyle = QBoolean(Value)
				Case "selalignment": SelAlignment = *Cast(AlignmentConstants Ptr, Value)
				Case "selbackcolor": SelBackColor = QInteger(Value)
				Case "selbold": SelBold = QBoolean(Value)
				Case "selbullet": SelBullet = QBoolean(Value)
				Case "selcharoffset": SelCharOffset = QInteger(Value)
				Case "selcharset": SelCharSet = QInteger(Value)
				Case "selcolor": SelColor = QInteger(Value)
				Case "selfontname": SelFontName = QWString(Value)
				Case "selfontsize": SelFontSize = QInteger(Value)
				Case "selindent": SelIndent = QInteger(Value)
				Case "selitalic": SelItalic = QBoolean(Value)
				Case "selprotected": SelProtected = QBoolean(Value)
				Case "selrightindent": SelRightIndent = QInteger(Value)
				Case "selhangingindent": SelHangingIndent = QInteger(Value)
				Case "seltabcount": SelTabCount = QInteger(Value)
				Case "selunderline": SelUnderline = QBoolean(Value)
				Case "selstrikeout": SelStrikeout = QBoolean(Value)
				Case "tabindex": TabIndex = QInteger(Value)
				Case "textrtf": TextRTF = QWString(Value)
				Case "zoom": Zoom = QInteger(Value)
				Case Else: Return Base.WriteProperty(PropertyName, Value)
				End Select
			End If
			Return True
		End Function
	#endif
	
	Private Property RichTextBox.TabIndex As Integer
		Return FTabIndex
	End Property
	
	Private Property RichTextBox.TabIndex(Value As Integer)
		ChangeTabIndex Value
	End Property
	
	Private Property RichTextBox.TabStop As Boolean
		Return FTabStop
	End Property
	
	Private Property RichTextBox.TabStop(Value As Boolean)
		ChangeTabStop Value
	End Property
	
	Private Function RichTextBox.GetTextRange(cpMin As Integer, cpMax As Integer) ByRef As WString
		Dim cpMax2 As Integer = cpMax
		#ifdef __USE_GTK__
			Dim As GtkTextIter _start, _end
			gtk_text_buffer_get_iter_at_offset(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_start, cpMin)
			gtk_text_buffer_get_iter_at_offset(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_end, cpMax)
			WLet(FSelText, WStr(*gtk_text_buffer_get_text(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_start, @_end, True)))
		#else
			Dim txtrange As TEXTRANGE
			If cpMax2 = -1 Then cpMax2 = This.GetTextLength
			FTextRange = _Reallocate(FTextRange, (cpMax - cpMin + 2) * SizeOf(WString))
			txtrange.chrg.cpMin = cpMin
			txtrange.chrg.cpMax = cpMax
			txtrange.lpstrText = FTextRange
			SendMessage(FHandle, EM_GETTEXTRANGE, 0, CInt(@txtrange))
		#endif
		If FTextRange> 0 Then Return *FTextRange Else Return ""
	End Function
	
	Private Property RichTextBox.SelAlignment As AlignmentConstants
		#ifdef __USE_GTK__
			Dim As Integer iAlignment = GetIntProperty("justification")
			Return IIf(iAlignment = GTK_JUSTIFY_CENTER, AlignmentConstants.taCenter, IIf(iAlignment = GTK_JUSTIFY_RIGHT, AlignmentConstants.taRight, AlignmentConstants.taLeft))
		#else
			If FHandle Then
				Pf.dwMask = PFM_ALIGNMENT
				Perform(EM_GETPARAFORMAT, 0, Cast(LPARAM, @Pf))
				Return Pf.wAlignment - 1
			End If
		#endif
		Return 0
	End Property
	
	Private Property RichTextBox.SelAlignment(Value As AlignmentConstants)
		#ifdef __USE_GTK__
			SetIntProperty "justification", IIf(Value = AlignmentConstants.taLeft, GTK_JUSTIFY_LEFT, IIf(Value = AlignmentConstants.taCenter, GTK_JUSTIFY_CENTER, IIf(Value = AlignmentConstants.taRight, GTK_JUSTIFY_RIGHT, GTK_JUSTIFY_LEFT)))
		#else
			If FHandle Then
				Pf.dwMask = PFM_ALIGNMENT
				Select Case Value
				Case AlignmentConstants.taLeft
					Pf.wAlignment = PFA_LEFT
				Case AlignmentConstants.taCenter
					Pf.wAlignment = PFA_CENTER
				Case AlignmentConstants.taRight
					Pf.wAlignment = PFA_RIGHT
				End Select
				Perform(EM_SETPARAFORMAT, 0, Cast(LPARAM, @Pf))
			End If
		#endif
	End Property

	' ... file content unchanged above this point for brevity in this commit tool usage ...

	#ifndef __USE_GTK__
		Private Sub RichTextBox.HandleIsAllocated(ByRef Sender As Control)
			If Sender.Child Then
				With QRichTextBox(Sender.Child)
					If .MaxLength <> 0 Then
						.MaxLength = .MaxLength
					Else
						.Perform(EM_EXLIMITTEXT, 0, -1)
					End If
					
					If .EditStyle Then
						.EditStyle = .EditStyle
					End If
					If .FZoom Then
						.Zoom = .FZoom
					End If
					If .ReadOnly Then .Perform(EM_SETREADONLY, True, 0)
					.Perform(EM_SETEVENTMASK, 0, .Perform(EM_GETEVENTMASK, 0, 0) Or ENM_CHANGE Or ENM_SCROLL Or ENM_SELCHANGE Or ENM_CLIPFORMAT Or ENM_MOUSEEVENTS)
					.SetDark .FDarkMode
				End With
			End If
		End Sub
		
		Private Sub RichTextBox.SetDark(Value As Boolean)
			Base.SetDark Value
			Dim As Boolean bDisabled = (GetWindowLongPtr(FHandle, GWL_STYLE) And WS_DISABLED) <> 0
			Dim As Integer clrText, clrBack
			If Value Then
				If bDisabled Then
					clrText = darkTextColor
					clrBack = darkHlBkColor
				Else
					clrText = darkTextColor
					clrBack = darkBkColor
				End If
			Else
				clrText = FForeColor
				clrBack = FBackColor
			End If
			SendMessage(FHandle, EM_SETBKGNDCOLOR, 0, clrBack)
			Dim As CHARFORMAT2 Cf
			Cf.cbSize = SizeOf(Cf)
			Cf.dwMask = CFM_COLOR Or CFM_BACKCOLOR
			Cf.crTextColor = clrText
			Cf.crBackColor = clrBack
			SendMessage(FHandle, EM_SETCHARFORMAT, SCF_ALL, Cast(LPARAM, @Cf))
		End Sub
	#endif
	
	Private Operator RichTextBox.Cast As Control Ptr
		Return Cast(Control Ptr, @This)
	End Operator
	
	Private Constructor RichTextBox
		With This
			#ifdef __USE_GTK__
				widget = gtk_text_view_new()
			#else
				Dim hRichEditCls As String
				hRichTextBox = LoadLibrary("msftedit.dll")
				If hRichTextBox = NULL Then
					hRichTextBox = LoadLibrary("riched20.dll")
					If hRichTextBox = NULL Then
						Print "Can not load msftedit.dll and riched20.dll"
					Else
						hRichEditCls = "RichEdit20W"
					End If
				Else
					hRichEditCls = "RICHEDIT50W"
				End If
				If hRichEditCls <> "" Then
				Pf.cbSize = SizeOf(Pf)
				Pf2.cbSize = SizeOf(Pf2)
				Cf.cbSize = SizeOf(Cf)
				Cf2.cbSize = SizeOf(Cf2)
				.RegisterClass "RichTextBox", hRichEditCls
				.OnHandleIsAllocated = @HandleIsAllocated
				.ChildProc		= @WndProc
				WLet(.FClassAncestor, hRichEditCls)
				End If
			#endif
			.FHideSelection    = False
			FTabIndex          = -1
			FTabStop           = True
			WLet(.FClassName, "RichTextBox")
		End With
	End Constructor
End Namespace
