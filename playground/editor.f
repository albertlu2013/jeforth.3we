
	\ editor.f 
	\ Editor commands for 3hta and 3nw to edit HTML documents directly
	\ in jeforth window.
	
	include unindent.f
	
	s" editor.f" source-code-header
	
	char %HOMEDRIVE%%HOMEPATH%\Documents\GitHub\jeforth.3we\playground\ env@
	value working-directory // ( -- "path" ) 

	char c:\Users\hcche\Documents\GitHub\jeforth.3we\playground\editor-study.html 
	value pathname // ( -- "pathname" ) Path/Filename of the working document

	null value article // ( -- objArticle ) The DIV world of the file to be edited.

	: save ( -- ) \ Save the editing document
		js> mystyle.outerHTML+myarticle.outerHTML pathname writeTextFile ;

	: save-as ( "path-name" -- ) \ Save the editing document to the specified pathname
		cr ." Sorry, under constructing " cr ;

	: open ( "path-name" -- ) \ Read the file to edit
		article if article :: innerHTML="" ( 清除現有頁面 ) 
		else s" body" <e> <div></div></e> to article then 
		pathname readTextFile article :: innerHTML=pop() ;
	
	null value div-editbox // ( -- element ) The entire DIV node of the editbox.
	
	: editbox  ( -- element ) \ Create an editbox at outputbox
		char editbox-close execute \ editbox 只能有一個，因為其中的 editboxtextarea id 必須唯一。
		<text> <div>
			<textarea id=editboxtextarea rows=8></textarea>
			<input type=button value=Save  onclick="kvm.execute('editbox-save')" />
			<input type=button value=Bigger onclick="kvm.execute('editbox-bigger')" />
			<input type=button value=Smaller onclick="kvm.execute('editbox-smaller')" />
			<input type=button value='<' onclick="kvm.execute('editbox-before')" />
			<input type=button value=Parent onclick="kvm.execute('editbox-parent')" />
			<input type=button value=Back onclick="kvm.execute('editbox-pop')" />
			<input type=button value='>' onclick="kvm.execute('editbox-after')" />
			<input type=button value='Refresh>' onclick="kvm.execute('editbox-refresh')" />
			<input type=button value='Example>' onclick="kvm.execute('editbox-example')" />
			<input type=button value=Close onclick="kvm.execute('editbox-close')" />
		</div></text> </o> ;
	
	: 	editbox-save ( -- ) \ ce@ is the target element.
		js> editboxtextarea.value /*remove*/ <code>escape 
		ce@ :: outerHTML=pop() ;
		
	: 	editbox-close ( -- ) \ ce@ is the target element.
		begin 
			js> document.getElementById("editboxtextarea") if 
				\ 這個 id 必須唯一，還看得見就是有例外狀況了，可能是之前的還沒有 close。
				js> editboxtextarea dup :: removeAttribute("id") removeElement 
				false 
			else true then 
		until
		div-editbox js> tos()&&tos().parentNode 
		if removeElement then null to div-editbox ;

	: node-source ( node -- "source" ) \ Get outerHTML or node.toString()
		dup :> outerHTML ?dup if ( node outerHTML ) nip 
		else ( node ) dup :> toString() char /* swap + js> "*/\n" + 
		( node ) :> nodeValue ?dup if + then then ;
		
	: 	editbox-parent ( -- ) \ Change element to ce's parent
		char .. (ce) node-source js: editboxtextarea.value=pop() ;

	: 	editbox-before ( -- ) \ Change element to ce's sibling
		char < (ce) node-source js: editboxtextarea.value=pop() ;

	: 	editbox-after ( -- ) \ Change element to ce's sibling
		char > (ce) node-source js: editboxtextarea.value=pop() ;

	: 	editbox-pop ( -- ) \ Change element to the previous ce
		char pop (ce) node-source js: editboxtextarea.value=pop() ;

	: editbox-refresh ( -- ) \ Recall current element
		ce@ node-source js: editboxtextarea.value=pop() ;

	: editbox-example ( -- ) \ Show example
		<text> /* <table class=commandline><td><pre><code class=source>...</code></pre></td></table> */</text>
		js> '\n' + ce@ node-source + js: editboxtextarea.value=pop() ;

	code editbox-smaller ( -- ) \ Smaller editbox
		var r = editboxtextarea.rows;
		if(r<=4) r-=1; else if(r>8) r-=4; else r-=2;
		editboxtextarea.rows = Math.max(r,1); end-code

	code editbox-bigger ( -- ) \ Bigger editbox
		var r = editboxtextarea.rows;
		if(r<4) r+=1; else if(r>8) r+=4; else r+=2;
		editboxtextarea.rows = Math.max(r,1); end-code

	: edit ( -- ) \ Edit the ce (current element) outerHTML.
		editbox to div-editbox
		ce@ node-source js: editboxtextarea.value=pop() ;
		/// [ ] [save] 過後 ce 就斷鏈了，因此不能重複實驗。有待改良。
		/// 可以在 editbox-save 處加強
\ -- End --