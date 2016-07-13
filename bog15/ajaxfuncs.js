//
// ajax functions for basic getting info and sending info
//
// ajax_get(url, fcn to call with response string)
// ajax_put(url, post_string, fcn to call with response string)
//
// version 2012-11-17 -- added ajax_set and ajax_do
//

	//
	// ajax_set( resource, objID )
	//  purpose: objID.innerHTML = resource()
	//     i.e.: call a remote function and display result on page
	//     args: addr, objID
	//     rets: nothing, this is an async call
	//
	function ajax_set( addr, objID )
	{
		ajax_get( addr, function(x)
				{
					var o = document.getElementById(objID);
					o.innerHTML = x;
				}
		);
	}

	//
	//  ajax_do( resource )
	//  purpose: eval(resource())
	//     i.e.: call a remote function and eval the result 
	//     args: addr
	//     rets: nothing, this is an async call
	//
	function ajax_do( addr )
	{
		ajax_get( addr, function(x) 
				{
					eval(x);
				}
		);
	}

	//
	// use GET to talk to a backend server and
	// then pass the reply to a function for processing
	//
	function ajax_get( addr, handler )
	{
		var xmlhttp;
		if ( window.XMLHttpRequest )	// IE7+, Firefox, ...
		{
			xmlhttp = new XMLHttpRequest();
		}
		else	// IE5, IE6
		{
			xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
		}
		xmlhttp.onreadystatechange = 
			function()
			{
				if ( xmlhttp.readyState == 4 &&
				     xmlhttp.status     == 200 )
				{
					// alert(xmlhttp.responseText);
					handler(xmlhttp.responseText);
				}
			};

		//alert("setting " + addr );
		xmlhttp.open("GET", addr, true);
		xmlhttp.send();
	}
			
	//
	// post a string to a URL
	// and send the reply to the handler
	//
	function ajax_put( addr, str, handler )
	{
		var xmlhttp;
		if ( window.XMLHttpRequest )	// IE7+, Firefox, ...
		{
			xmlhttp = new XMLHttpRequest();
		}
		else	// IE5, IE6
		{
			xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
		}
		xmlhttp.onreadystatechange = 
			function()
			{
				if ( xmlhttp.readyState == 4 &&
				     xmlhttp.status     == 200 )
				{
					// alert(xmlhttp.responseText);
					handler(xmlhttp.responseText);
				}
			};

		xmlhttp.open("POST", addr, true);
		xmlhttp.send( str );
	}
