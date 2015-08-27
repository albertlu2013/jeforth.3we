	
	\ ShellWindows object https://msdn.microsoft.com/en-us/library/windows/desktop/bb773974(v=vs.85).aspx
	\ Windows Internet Explorer object https://msdn.microsoft.com/library/aa752084(v=vs.85).aspx
	\ shell.application :> windows() 即 ShellWindows. ShellWindows 有可能是 File Explorer 或 Windows Internet Explorer,
	\ 也許還不只？用 ie :> application . 察看即知。
	
	s" ie.f"	source-code-header

	: see-ie 			( -- count ) \ List all IE processes and return the count
						s" where name = 'iexplore.exe'" see-process ;
						/// IE process 的個數不能用，它的意義不明，與 ShellWindows count 不符。
						/// 第一次 Run iexplore.exe 會跑出兩個 IE process 一主一副。
						
	: kill-ie 			( -- bodyCount ) \ Kill all IE processes return the count.
						<js> var f=confirm("Kill IEs are you sure? ShellWindows.count will not be reduced");f</jsV>
						if s" where name = 'iexplore.exe'" kill-them then ;
						/// 但是，當 (Win8) IE 被徹底用 processID 殺掉之後, ShellWindows :> count 
						/// 仍不會減去! Kill IE process 不是正常使用的動作。

	shell.application :> windows() constant ShellWindows // ( -- obj ) shell.application (IE) windows object.
						/// 這個 collection 就是所有的 IE windows. ShellWindows :> count 就是 IE 頁面
						/// 的總數。ShellWindows :> item(0,1,2,3...) 即 IE objects 與 DOM window 不同。
						/// ShellWindows 整合所有的 IE 頁面，但 ShellWindows 本身沒有開啟 IE 頁面的功
						/// 能。我本來以為 ShellWindows :> count >= 1 時 ShellWindows :> item(0) 可以
						/// 當作 defauult IE object 來操作。可是 item(0) 常常是 null! 
						
	\ IE run 起來有幾種方式
	\ 1. s" iexplore ibm.com" (fork) 當 ShellWindows.count==0 時要用這個，還不如都用這個。
	\ 2. ShellWindows.item(0).navigate("url") 當 ShellWindows.count==0 時不能用。
	\ 3. GetObject("","InternetExplorer.Application") 取得一個沒有 document 的 IE object
	\ 4. CreateObject("InternetExplorer.Application") 用不著，不必研究。
	\ 有了 ShellWindows 可以隨時 access 所有的 IE web 頁面, 後三者都用不著了。
	
	: ie(i)				( i -- ie|null ) \ Get IE object of the indexed window
						s" g.ShellWindows.item(_i_)" :> replace(/_i_/,pop()) jsEval ;
						/// IE run 起來之前是 null 即無 IE process。若照下面這樣把最後
						/// 一個 window 關掉: 0 ie() :> document.parentWindow :: close() 
						/// 也會把 IE process 關掉,當然 0 ie(i) 也是 null。
	
	0 value theIE // ( -- i ) Make ShellWindows.item(i) the default IE object
						
	: ie 				( -- ie|null ) \ Get the ShellWindows.item(theIE) IE object
						\ js> g.ShellWindows.item(g.theIE) [ ] 不能直接用變數,很奇怪,是個 bug 吧!
						theIE s" g.ShellWindows.item(_i_)" :> replace(/_i_/,pop()) jsEval ;
						/// IE run 起來之前是 null 即無 IE process。若照下面這樣把最後
						/// 一個 window 關掉: ie :> document.parentWindow :: close() 
						/// 也會把 IE process 關掉,當然 ie 也是 null。但 ie(0) 有時候是 null
						/// 即使 ie(1) 有東西，故需要用 theIE 來指定 active IE object。
						
	last alias available? // ( -- objIe|null ) Is the ShellWindows.item(0) IE object available?
						/// ie 可能是存在的, 但沒有 connect 任何網址, 此時 ReadyState 也是 4, 
						/// 也有 document, 但是 document 裡 innerHTML 是 undefined。 這樣就
						/// available 了, 可以 navigate() 了。如果不 available 則推薦用
						/// s" iexplore" (fork) 把 IE run 起來。
	
						
	: window(i)			( i -- window|null ) \ Get window object of the indexed ie tab
						ie(i) ?dup if ( ie ) 
							dup :> ReadyState if ( ie ) \ [ ] 不是 0 就有 document 是真的嗎? 直接 check document 不就好了?
								:> document.parentWindow exit
							then
						then drop null ;
						/// [ ] 疑問 ie.ReadyState 不是 0 就有 document 是真的嗎?
						/// ie(i).ReadyState == 0 就不會有 document。即使
						/// 有 document 也不一定有 innerHTML 的內容。

	: window			( -- window|null ) \ Get the ShellWindows.item(0) window object
						ie ?dup if ( ie ) 
							dup :> ReadyState if ( ie ) \ [ ] 不是 0 就有 document 是真的嗎? 直接 check document 不就好了?
								:> document.parentWindow exit
							then
						then drop null ;
						/// [ ] 疑問 ie.ReadyState 不是 0 就有 document 是真的嗎?
						/// ie(i).ReadyState == 0 就不會有 document。
						/// 有 document 也不一定有 innerHTML 的內容。
						
	: isIe?				( ie -- ie flag ) \ Is it an IE object?
						<js> typeof(tos())=="object"&&tos().name=="Windows Internet Explorer"</jsV> ;
						
	: check-ie			( ie -- ie ) \ Pass or abort
						isIe? if else drop abort" Error! Need an IE object (from ShellWindows)." then ;

	: list-ie-windows	( -- count ) \ List all IE windows' locationName and URL
		\ 0 begin dup ie(i) ( count IE ) dup while ( count IE ) 
		\ over . space dup :> LocationName . space :> LocationURL . cr ( count )
		\ 1+ repeat ( count IE ) drop ;
		ShellWindows :> count ?dup if dup for dup r@ - ( COUNT i )
		dup . space ( COUNT i ) ie(i) ?dup if dup :> LocationName . space :> LocationURL . else ." Null" then cr
		next drop then ;
		/// 有時候存在沒有內容的空 ie(i) 連 ie(0) 都有可能。
		last alias list

	\ 我不知道哪個 IE window 是 activated
	\ 以下命令固定用 ShellWindows.item(theIE) 來做 automation。
						
	: ready				( -- ) \ Wait ShellWindows.item(theIE) to become ready
						ie ?dup if 
							dup :> ReadyState if ( ie )
								begin dup :> ReadyState==4 if drop space exit else char . . then 200 nap again
							else
							drop abort" Error! The given IE object is empty, nothing to do with 'ready'."
							then
						else \ 還沒有實體
							drop abort" Error! The given IE object is NULL, nothing to do with 'ready'."
						then ;
						/// 因為是 Wait ready 所以出問題要 abort。要預防,用 available? 先查。
						
	: not-busy			( -- ) \ Wait ShellWindows.item(0) to become not-busy
						ie begin ( ie )
							dup :> busy if char * . else drop space exit then
						200 nap again ;
						/// Wait ready first it checks IE object existence.
						
	: document			( -- obj ) \ Get ShellWindows.item(theIE).document object
						ie :> document ;
	: locationName		( -- "name" ) \ Get ShellWindows.item(theIE).locationName string
						ie :> locationName ;
	: locationUrl		( -- obj ) \ Get ShellWindows.item(theIE).locatonUrl string
						ie :> locationUrl ;
	: visible			( -- ) \ Make ShellWindows.item(theIE) visible
						js: g.ShellWindows.item(theIE).visible=true ;
	: visible?			( -- flag ) \ Get ShellWindows.item(theIE).visible setting
						ie :> visible ;
	: (navigate)		( "url" flags -- ) \ Visit the URL
						ShellWindows :> count==0 ?abort" No connection to any IE web page."
						ie :: navigate(pop(1),pop()) ;
						/// Flags : A combined number of following bits:
						/// 	navOpenInNewWindow = 0x1,
						/// 	navNoHistory = 0x2,
						/// 	navNoReadFromCache = 0x4,
						/// 	navNoWriteToCache = 0x8,
						/// 	navAllowAutosearch = 0x10,
						/// 	navBrowserBar = 0x20,
						/// 	navHyperlink = 0x40,
						/// 	navEnforceRestricted = 0x80,
						/// 	navNewWindowsManaged = 0x0100,
						/// 	navUntrustedForDownload = 0x0200,
						/// 	navTrustedForActiveX = 0x0400,
						/// 	navOpenInNewTab = 0x0800, it works
						/// 	navOpenInBackgroundTab = 0x1000,
						/// 	navKeepWordWheelText = 0x2000,
						/// 	navVirtualTab = 0x4000,
						/// 	navBlockRedirectsXDomain = 0x8000,
						/// 	navOpenNewForegroundTab = 0x10000
						
	: navigate			( <url> -- ) \ ShellWindows.item(theIE) to visit the URL
						BL word 0 (navigate) ;
	: source 			( -- "HTML" ) \ Get source code of the ShellWindows.item(theIE) page
						ready not-busy document :> body.innerHTML ;
	
	<comment>	
		AddressBar
		/// Sets or gets a value indicating whether the address bar of the object is visible or hidden.
		Application
		/// Gets the automation object for the application that is hosting the WebBrowser Control. 就是 IE object 自己。
		Busy
		/// Gets a value that indicates whether the object is engaged in a navigation or downloading operation.
		Container
		/// Gets an object reference to a container. [ ] 不知是啥,讀出來是 NULL。
		Document
		/// Gets the automation object of the active document, if any. ==> [object Document] (object)
		FullName
		/// FullName may be altered or unavailable in subsequent versions of the operating system or product.
		/// Retrieves the fully qualified path of the Internet Explorer executable.
		FullScreen
		/// Sets or gets a value that indicates whether Internet Explorer is in full-screen mode or normal window mode.
		Left
		/// Sets or gets the coordinate of the left edge of the object.
		LocationName
		/// (ReadOnly) Retrieves the path or title of the resource that is currently displayed.
		LocationURL
		/// (ReadOnly) Gets the URL of the resource that is currently displayed.
		MenuBar
		/// Sets or gets a value that indicates whether the Internet Explorer menu bar is visible.
		Offline
		/// Sets or gets a value that indicates whether the object is operating in offline mode.
		Parent
		/// Gets the parent of the object.
		Path
		/// Path may be altered or unavailable in subsequent versions of the operating system or product. Retrieves the system folder of the Internet Explorer executable.
		ReadyState
		/// Gets the ready state of the object. READYSTATE_UNINITIALIZED = 0, READYSTATE_LOADING = 1, READYSTATE_LOADED = 2, READYSTATE_INTERACTIVE = 3, READYSTATE_COMPLETE = 4
		RegisterAsBrowser
		/// Sets or gets a value that indicates whether the object is registered as a top-level browser window.
		RegisterAsDropTarget
		/// Sets or gets a value that indicates whether the object is registered as a drop target for navigation.
		Silent
		/// Sets or gets a value that indicates whether the object can display dialog boxes.
		StatusBar
		/// Sets or gets a value that indicates whether the status bar for the object is visible.
		TheaterMode
		/// Sets or gets whether the object is in theater mode.
		ToolBar
		/// Sets or gets whether toolbars for the object are visible.
		TopLevelContainer
		/// Gets a value that indicates whether the object is a top-level container.
		Type
		/// Gets the user type name of the contained document object.
		Visible
		/// Sets or gets a value that indicates whether the object is visible or hidden.
	</comment>	
	<comment>	
	[ ] 在 ie.f theIE 網頁上加上程式先讓 click 打 alert 看看。
		--> 複習一下, 不久前才搞懂的 jQuery 2nd argument, the 'context'。
			document js> $("div",pop()) constant page.jq \ 取得 jQuery object, 只限 <DIV>
			document js> $("*",pop()) constant page.jq \ 取得 jQuery object, 整個網頁
			page.jq :> [0].outerHTML </o> \ 在 jeforth.3hta outputbox 上顯示
			page.jq :> length . \ ==> 1 看有沒有東西
			page.jq :> [0] ce! ce \ ==> 用 jeforth.3hta element.f 來直接操作這個 IE 上的網頁。
		--> 這樣真的可以為某 element 加紅框了,但不知如何去除?
			\ myh2 :: setAttribute('style',"background-color:white;border: 1px ridge")
			\ style="background-color:red;border: 1px ridge"
			\ clearAttributes() \ remove all attributes
			\ myh2 :: clearAttributes()
			myh2 <js> pop().setAttribute('style',"background-color:white;border: 2px ridge red")</js>	
		--> 給全部 <DIV> 加上紅框
			document js> $("div",pop())[0] <js> pop().setAttribute('style',"background-color:white;border: 2px ridge red")</js>	
			document <js> $("div",pop()).css("border","2px ridge red")</js>
		--> remove it : document <js> $("div",pop())[0].removeAttribute('style')</js>
	[ ] http://api.jquery.com/css/ 抄到這段 example 
		<script>
		$( "div" ).click(function() {
		  var html = [ "The clicked div has the following styles:" ];
		 
		  var styleProps = $( this ).css([
			"width", "height", "color", "background-color"
		  ]);
		  $.each( styleProps, function( prop, value ) {
			html.push( prop + ": " + value );
		  });
		 
		  $( "#result" ).html( html.join( "<br>" ) );
		});
		</script>
		改寫成 click 任何東西都把它 hide , <ESC> 或 Ctrl-Z toggle 回來。
		document <js> 
		$("*",pop()).click(function(){
			$(this)
			.css("border","2px ridge red")
			.addClass("_selected_");
		});
		</js>
		document <js> $("*",pop()).toArray() </jsV> constant a
		a :> length tib.
		a :> [0] a :> [9] js> $(pop(),pop()).first().click(function(){alert("abc")}) \ works
		a :> [0] a :> [9] js> $(pop(),pop()).removeAttr('style') \ it works
		a :> [0] a :> [9] js> $(pop(),pop()).css("background-color","yellow") \ works
		a :> [0] a :> [9] js> $(pop(),pop()).hide() \ JavaScript error : Unspecified error.
		document <js> $("*",pop()).css("background","yellow") </js>
		照這樣一 click 下去, 被 click 到的 element 以及它的 parents 全部都被一一執行到。
		document <js> 
		$("*",pop()).click(function(){
			if(g.flag) return;
			$(this)
			.css("border","2px ridge red")
			.addClass("_selected_");
			g.flag = true;
		});
		</js>
		除了紅框, 印出來看也證實。
		document <js> $("._selected_",pop()).each(function(){
			print("-------------------------\n");
			print($(this).html());
			print("\n");
		});
		</js>		
		調查整串都被 click 到的順序...由內而外。
		document <js> 
		$("*",pop()).click(function(){
			print(this.toString());
		});
		</js>
		[object HTMLParagraphElement] 由最內直接 click 到的 element 先 trigger。
		[object HTMLDivElement]
		[object HTMLBodyElement]
		[object HTMLHtmlElement] 最後一個 document 可以當作結尾。

		所以只要看到 flag 舉起來了就不執行即可。 ---> 成功!
		
		\ 過一會兒就把 flag 清掉, 以便連續選擇。
		document <js> 
		$("*",pop()).click(function(){
			if(kvm.flag) {
				g.setTimeout("kvm.flag=false",500);
				return;
			}
			kvm.flag = true;
			if($(this).hasClass("_selected_")){
				$(this)
				.removeClass("_selected_")
				.removeAttr('style');
				return;
			}
			$(this)
			.css("border","4px dashed red")
			.addClass("_selected_");
		});
		</js>
		
		\ 顯示選中的有幾個
		document js> $("._selected_",pop()).length .
		
		\ 把選中的都轉到 outputbox 來顯示。速度會很慢
		document <js> $("._selected_",pop()).each(function(){
			push($(this).html());
			execute("</o>");
		});
		</js>		
		
		\ 刪除所有選中的東西
		document <js> $("._selected_",pop()).each(function(){
			push(this);
			execute("removeElement");
		});
		</js>		
		
		\ 刪除所有【選中以外】的東西
		"" value selected 
		document <js> 
		var doc=pop();
		$("._selected_",doc).each(function(){
			g.selected += $(this)[0].outerHTML;
		});
		doc.body.innerHTML = g.selected;
		</js>		

		\ 想要把重複的 track item 都刪掉，但本程式會當，好像變成無窮迴路。
		<js>
			for (var i=0; i<g.track.length; i++){
				for (var j=i+1; i<g.track.length; j++) {
					if (g.track[i]==g.track[j]) g.track.splice(j,1);
				}
			}
		</js>
		
		\ 改用 mouseenter mouseleave 取代會冒泡的 click。有效,但 parent 沒有 leave 就不會消失。
		document <js> var doc=pop();
		$("*",doc).mouseenter(function(){
			$(this).css("border","4px dashed red");
		});
		$("*",doc).mouseleave(function(){
			$(this).removeAttr('style');
		});
		</js>
		
		\ 改用 mouseenter mouseleave 取代會冒泡的 click。有效,但 parent 沒有 leave 就不會消失。
		\ 用 lastThing 記住收到 event 的 this, mouseenter 時一律清除 lastThing
		0 value theElement // ( -- element ) The recent hovered DOM element.
		document <js> var doc=pop();
			$("*",doc).mouseenter(function(){
				print("mouse enter "+ this); execute("cr");
				$(g.theElement).removeAttr('style'); // 無須防呆
				$(this).css("border","4px dashed red");
				g.theElement = this;
			});
			$("*",doc).mouseleave(function(){
				print("mouse leave"+ this); execute("cr");
				$(this).removeAttr('style');
			});
		</js>
		
		\ 想讀取 attached 網頁的 css 失敗
		js> $("#inputbox").css("background-Color") .s 成功
		js> $("div",g.doc).css("background-Color") .s 失敗 JavaScript error : Unspecified error.
		js> $("div",g.doc)[0].getAttribute("style") . 成功 所以是 jQuery 的問題 "border: 4px dashed yellow; background-color: yellow;" 
		
		\ 如果快速把 mouse 移到某 div 收到的 event 順序如下, 不照順序! 所以利用 lastThing 或 theElement 
		\ 去清前一個也不靈。
		\	mouse enter [object HTMLBodyElement]
		\	mouse enter [object HTMLHtmlElement]
		\	mouse enter [object HTMLDivElement]
		\ [x] 如果忽略 Body 跟 Html 也許就好了
		
		\ Push the recent node to private track array.
		\ [f]reeze command (70) to stop receiving mouseenter mouseleave, toggle.
		\ [<] [>] command (188,190) to move around hovered nodes.
		$(doc).keydown(function(e){
			e = (e) ? e : event; var keycode = (e.keyCode) ? e.keyCode : (e.which) ? e.which : false;
			switch(keycode) {
				case 70: /* f */
					print('f ');
					return(false); 
				case 188: /* < ,*/
					print('< ');
					return(false); 
				case 190: /* > . */
					print('> ');
					return(false); 
			}
			return (true); // pass down to following handlers 
		})
		
		
		\ -------------------------------------
		[] value track // ( -- [node,..] ) The history track array of visited DOM nodes
		0 value itrack // ( -- int ) index of the track array
		document <js> var doc=pop();
			$(doc).keydown(function(e){
				e = (e) ? e : event; var keycode = (e.keyCode) ? e.keyCode : (e.which) ? e.which : false;
				switch(keycode) {
					case 70: /* [f]reeze */
						print('f ');
						return(false); 
					case 83: /* [s]elect */
						print('f ');
						return(false); 
					case 188: /* < ,*/
						print('< ');
						return(false); 
					case 190: /* > . */
						print('> ');
						return(false); 
				}
				return (true); // pass down to following handlers 
			})
			$("*",doc).mouseenter(function(){
				print("Enter " + this.nodeName + ". ");
				$(g.track[g.track.length-1]).removeAttr('style'); // 無須防呆
				$(this).css("border","4px dashed red");
				g.track.push(this);
				g.itrack = g.track.length-1;
			});
			$("*",doc).mouseleave(function(){
				print("Leave " + this.nodeName + ". ");
				$(this).removeAttr('style');
			});
		</js>
		
		\ -------------------------------------
		
		\ 完整功能 Hover 打紅框, Freeze, Select, Delete, Unselect, View, Clear
		\ 能用 [<][>] 倒退前進就不怕 event 順序不靈的問題。
		--- marker ---
		[] value track // ( -- [node,..] ) The history track array of visited DOM nodes
		0 value itrack // ( -- int ) index of the track array
		0 value freeze // ( -- boolean ) The freezing flag
		document <js> var doc=pop();
			var GoOn=false;
			$(doc).keydown(function(e){
				e = (e) ? e : event; var keycode = (e.keyCode) ? e.keyCode : (e.which) ? e.which : false;
				switch(keycode) {
					case 67: /* [c]lear */
						for(var i=0; i<g.track.length; i++){
							$(g.track[i])
							.removeAttr('style')
							.removeClass("_selected_");
						}
						return(!GoOn); 
					case 68: /* [d]elete the highlighted node */
						push(g.track[g.itrack]);
						execute("removeElement");
						return(!GoOn); 
					case 70: /* [f]reeze */
						g.freeze = !g.freeze;
						print("The freezing flag : " + g.freeze); execute("cr");
						return(!GoOn); 
					case 83: /* [s]elect */
						$(g.track[g.itrack])
						.removeAttr('style')
						.css("border","2px solid lime")
						.addClass("_selected_");
						return(!GoOn); 
					case 85: /* [u]nselect */
						$(g.track[g.itrack])
						.removeAttr('style')
						.removeClass("_selected_");
						return(!GoOn); 
					case 86: /* [v]iew selected nodes */
						for(var i=0; i<g.track.length; i++){
							$(g.track[i]).removeAttr('style');
							if($(g.track[i]).hasClass("_selected_"))
								$(g.track[i]).css("border","2px solid lime");
						}
						return(!GoOn); 
					case 188: /* < , */
						$(g.track[g.itrack]).removeAttr('style'); // 無須防呆
						g.itrack = Math.max(0,g.itrack-1);
						$(g.track[g.itrack]).css("border","4px dashed red");						
						return(!GoOn); 
					case 190: /* > . */
						$(g.track[g.itrack]).removeAttr('style'); // 無須防呆
						g.itrack = Math.min(g.track.length-1,g.itrack+1);
						$(g.track[g.itrack]).css("border","4px dashed red");						
						return(!GoOn); 
				}
				return (!GoOn);
			});
			$("*",doc).mouseenter(function(){
				print("Enter " + this.nodeName + ". ");
				if (g.freeze) return;
				$(g.track[g.itrack]).removeAttr('style'); // 無須防呆
				if (g.track[g.track.length-1]!=this) g.track.push(this);
				g.itrack = g.track.length-1;
				$(g.track[g.itrack]).css("border","4px dashed red");						
			});
			$("*",doc).mouseleave(function(){
				print("Leave " + this.nodeName + ". ");
				if (g.freeze) return;
				$(this).removeAttr('style'); // 無須防呆
			});
		</js>
	
	</comment>	
		
		
		
		
	
	