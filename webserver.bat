
@rem We need a WEB server to run jeforth.3htm from local or remote, http://localhost:8888 
@rem You'll need to make proper 'path' for your computer.

if a%COMPUTERNAME%==aWKS-38EN3476     path=c:\Program Files (x86)\OpenOffice 4\program;
if a%COMPUTERNAME%==aDP-20121028UGNO  path=c:\Python33;
if a%COMPUTERNAME%==aWKS-38EN3477     path=c:\Program Files (x86)\OpenOffice 4\program;

if a%COMPUTERNAME%==aWKS-38EN3476     path=%path%;c:\Users\8304018\Dropbox\learnings\JavaScript\node.js
if a%COMPUTERNAME%==aDP-20121028UGNO  path=%path%;d:\hcchen\Dropbox\learnings\JavaScript\node.js
if a%COMPUTERNAME%==aWKS-38EN3477     path=%path%;c:\Users\8304018.WKSCN\Dropbox\learnings\JavaScript\node.js

chcp 950

if a%COMPUTERNAME%==aWKS-38EN3476     node64 jeforth.3nd.js include webserver.f
if a%COMPUTERNAME%==aDP-20121028UGNO  node32 jeforth.3nd.js include webserver.f
if a%COMPUTERNAME%==aWKS-38EN3477     node64 jeforth.3nd.js include webserver.f

@rem Python is a good Web server oneliner, but something wrong with iframe so I drop it.
@rem if a%COMPUTERNAME%==aWKS-38EN3476    python -m SimpleHTTPServer 8888
@rem if a%COMPUTERNAME%==aWKS-38EN3477    python -m SimpleHTTPServer 8888
@rem if a%COMPUTERNAME%==aDP-20121028UGNO python -m http.server 8888
