
<o>
<div class="column half">
	<h1>交談式操作 Autio element</h1>
	<p>
		Forth language 的好處就是 interactive 的操作方式。<br>
		這個範例讓你嘗試 HTML5 audio element 的各種 properties 以及 methods.<br>
		利用 HTML5 新的 audio element 夾帶一首曲子讓您嘗試透過 Forth 交談介面來把玩。
	</p>
	<p>請輸入下列命令播放、暫停音樂。</p>
		<blockquote>music.mp3 :: play()<br />
		music.mp3 :: pause()</blockquote>
	<p>查看以及設定音量：</p>
		<blockquote>music.mp3 :&gt; volume .<br />
		music.mp3 :: volume=0.5</span></blockquote>
	<p>看看曲子的長度（秒），跳著播放。</p>
		<blockquote>music.mp3 :> duration .<br>	
		music.mp3 :: currentTime=22<br>	
		music.mp3 :: currentTime=67<br>
		music.mp3 :: currentTime=100</blockquote>
	<p>查看播放速度，惡搞播放速度。</p>
		<blockquote>music.mp3 :> playbackRate .<br>	
		music.mp3 :: playbackRate=0.8<br>	
		music.mp3 :: playbackRate=1.2<br>
		music.mp3 :: playbackRate=0.3</blockquote>
	<p>看看還有哪些 properties &amp; methods 或進一步列出所有的 members。</p>
		<blockquote>help music.mp3<br />
		music.mp3 obj&gt;keys .</blockquote>
	<p>交談過程蕪雜，可敲 BackSpace 倒著清除（小心！要 focus 在命令區裡，以免變成瀏覽<br>
	   器的跳頁）； Alt-BackSpace 從上面清下來。加上 Shift 鍵可以加速清除。以上只清除<br>
	   非 element 的東西，再加上 Ctrl 鍵，則什麼都清除； cls 命令可以清整個交談畫面。要<br>
	   copy 以上範例進命令區，可先 mark （要順著 mark）然後按 F4。help 命令之後沒有東西<br>
	   時，列出操作用法指引。
	</p>
</div>
<audio controls>
  <source src="data:audio/mpeg;base64,
	SUQzAwAAAAAgP1RJVDIAAAABAAAAVFlFUgAAAAEAAABDT01NAAAABQAAAGVuZwBUQUxCAAAA
	... snip ...
	ICAgICAgICAgICAgICAgIAw=" type="audio/mpeg">
	Your browser does not support the audio element.
</audio>
</o> constant music.mp3 // ( -- [object HTMLAudioElement] ) HTML5 audio element
	/// Useful properties and methods: 
	///   autobuffer,autoplay,buffered,controls,currentSrc,currentTime,defaultPlaybackRate,duration,ended,
	///   error,initialTime,loop,muted,networkState,paused,playbackRate,played,preload,readyState,seekable,
	///   seeking,src,volume,canPlayType,load,pause,play
	/// "music.mp3 obj>keys ." to see all object members.

<comment>
	OK music.mp3 obj>keys .
	autobuffer,autoplay,buffered,controls,currentSrc,currentTime,defaultPlaybackRate,duration,ended,
	error,initialTime,loop,muted,networkState,paused,playbackRate,played,preload,readyState,seekable,
	seeking,src,volume,canPlayType,load,pause,play,HAVE_CURRENT_DATA,HAVE_ENOUGH_DATA,HAVE_FUTURE_DATA,
	HAVE_METADATA,HAVE_NOTHING,NETWORK_EMPTY,NETWORK_IDLE,NETWORK_LOADING,NETWORK_NO_SOURCE,currentStyle,
	runtimeStyle,accessKey,className,contentEditable,dir,disabled,id,innerHTML,isContentEditable,lang,
	offsetHeight,offsetLeft,offsetParent,offsetTop,offsetWidth,onabort,onblur,oncanplay,oncanplaythrough,
	onchange,onclick,oncontextmenu,ondblclick,ondrag,ondragend,ondragenter,ondragleave,ondragover,ondragstart,
	ondrop,ondurationchange,onemptied,onended,onerror,onfocus,oninput,onkeydown,onkeypress,onkeyup,onload,
	onloadeddata,onloadedmetadata,onloadstart,onmousedown,onmousemove,onmouseout,onmouseover,onmouseup,
	onmousewheel,onpause,onplay,onplaying,onprogress,onratechange,onreadystatechange,onreset,onscroll,
	onseeked,onseeking,onselect,onstalled,onsubmit,onsuspend,ontimeupdate,onvolumechange,onwaiting,outerHTML,
	style,tabIndex,title,all,behaviorUrns,canHaveChildren,canHaveHTML,children,document,filters,hideFocus,
	innerText,isDisabled,isMultiLine,isTextEdit,language,onactivate,onafterupdate,onbeforeactivate,onbeforecopy,
	onbeforecut,onbeforedeactivate,onbeforeeditfocus,onbeforepaste,onbeforeupdate,oncellchange,oncontrolselect,
	oncopy,oncut,ondataavailable,ondatasetchanged,ondatasetcomplete,ondeactivate,onerrorupdate,onfilterchange,
	onfocusin,onfocusout,onhelp,onlayoutcomplete,onlosecapture,onmouseenter,onmouseleave,onmove,onmoveend,
	onmovestart,onpaste,onpropertychange,onresize,onresizeend,onresizestart,onrowenter,onrowexit,onrowsdelete,
	onrowsinserted,onselectstart,outerText,parentElement,parentTextEdit,recordNumber,scopeName,sourceIndex,
	tagUrn,uniqueID,uniqueNumber,blur,click,focus,getElementsByClassName,insertAdjacentHTML,scrollIntoView,
	componentFromPoint,doScroll,attachEvent,detachEvent,addBehavior,addFilter,applyElement,clearAttributes,
	contains,dragDrop,getAdjacentText,insertAdjacentElement,insertAdjacentText,mergeAttributes,releaseCapture,
	removeBehavior,removeFilter,replaceAdjacentText,setActive,setCapture,createControlRange,removeNode,replaceNode,
	swapNode,clientHeight,clientLeft,clientTop,clientWidth,scrollHeight,scrollLeft,scrollTop,scrollWidth,tagName,
	childElementCount,firstElementChild,lastElementChild,nextElementSibling,previousElementSibling,getAttribute,
	getAttributeNS,getAttributeNode,getAttributeNodeNS,getBoundingClientRect,getClientRects,getElementsByTagName,
	getElementsByTagNameNS,hasAttribute,hasAttributeNS,removeAttribute,removeAttributeNS,removeAttributeNode,
	setAttribute,setAttributeNS,setAttributeNode,setAttributeNodeNS,fireEvent,msMatchesSelector,querySelector,
	querySelectorAll,attributes,childNodes,firstChild,lastChild,localName,namespaceURI,nextSibling,nodeName,nodeType,
	nodeValue,ownerDocument,parentNode,prefix,previousSibling,textContent,addEventListener,dispatchEvent,
	removeEventListener,appendChild,cloneNode,compareDocumentPosition,hasAttributes,hasChildNodes,insertBefore,
	isDefaultNamespace,isEqualNode,isSameNode,isSupported,lookupNamespaceURI,lookupPrefix,normalize,removeChild,
	replaceChild,ATTRIBUTE_NODE,CDATA_SECTION_NODE,COMMENT_NODE,DOCUMENT_FRAGMENT_NODE,DOCUMENT_NODE,
	DOCUMENT_POSITION_CONTAINED_BY,DOCUMENT_POSITION_CONTAINS,DOCUMENT_POSITION_DISCONNECTED,DOCUMENT_POSITION_FOLLOWING,
	DOCUMENT_POSITION_IMPLEMENTATION_SPECIFIC,DOCUMENT_POSITION_PRECEDING,DOCUMENT_TYPE_NODE,ELEMENT_NODE,
	ENTITY_NODE,ENTITY_REFERENCE_NODE,NOTATION_NODE,PROCESSING_INSTRUCTION_NODE,TEXT_NODE OK 
	OK music.mp3 :: play()
	OK music.mp3 :> volume .
	0.23 OK music.mp3 :: volume=0.1
	OK music.mp3 :: volume=0.01
	OK music.mp3 :: volume=0.1
	OK music.mp3 :: volume=0.05
</comment>


