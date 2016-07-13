//
// bogtrain.js  -- scripts used by the boggle trainer page
//
// version: 2013-11-21 -- moved to modperl 
// version: 2013-04-25 -- added Qu handling (10Q SusiKP)
// version: 2013-04-11
//

	var sols ;			// map wordID -> HBF string
	var vals ;			// map cellID -> letter stored there
	var num_words = 0;		// issue wordIDs
	var prev_hilite = "";
	var board_gen = "bogbrd.pl";
	var solver    = "bogsolve.pl";
	var checker   = "bogcheck.pl";
	var timeleft  = 0;
	var gametime  = 180;		// seconds
	var timer_obj = null;

// ---------- data structure notes -------------------------------------
//
// Some people return the same word multiple times if it can be found
// with different paths.  This is not 'legal' boggle, but it is fun to
// see where the word appears.  Therefore, we cannot, as originally
// planned to map a word to an HBF string.
// Instead, we just make up unique wordIDs and map each one to its
// HBF string.  The links on the solution window use those IDs instead
// of the word.
//

// ---------- board management functions -------------------------------
// 
//    make_new_board       -- load a new board 
//    set_board_vertical   -- show letters all oriented normally
//    set_board_random     -- show letters oriented randomly
//
	function make_new_board(s)
	{
		prev_hilite = "";
		set_human_input("");
		set_computer_solution("");
		set_input_readonly(false);
		start_timer();
		document.getElementById('human_input').focus();
		ajax_set( board_gen + "?rh" + s, 'boardcell' );
	}

	function set_board_vertical()
	{
		var	seed = document.getElementById('bbseed').value;
		var	dims = document.getElementById('bbsize').value;
		set_input_readonly(false);

		ajax_set( board_gen + "?h" + seed + dims, 'boardcell' );
	}

	function set_board_random()
	{
		var	seed = document.getElementById('bbseed').value;
		var	dims = document.getElementById('bbsize').value;
		set_input_readonly(true);

		ajax_set( board_gen + "?rh" + seed + dims, 'boardcell' );
	}

//
// ---------- word display region management ----------------------
//
//   set_input_readonly    -- make the user input area readonly or not
//   set_human_input       -- load text into user input area
//   enable_check_button   -- set check button to on or off
//
	function set_input_readonly( how )
	{
		var o = document.getElementById('human_input');
		o.readOnly = how;
		if ( how == true )
			o.style.backgroundColor = '#FFFFCC';
		else 
			o.style.backgroundColor = '#E1EDF2';
	}

	function set_human_input(s)
	{
		var spot = document.getElementById('human_input');
		spot.value = s;
	}

	function enable_buttons()
	{
		document.getElementById('checkbtn').disabled = false ;
		document.getElementById('solvebtn').disabled = false ;
	}
	function disable_buttons()
	{
		document.getElementById('checkbtn').disabled = true ;
		document.getElementById('solvebtn').disabled = true ;
	}
		

// ---------- word highlight --------------------------------------

	//
	// highlight a string in the board
	// ARGS: a wordID, a color for the letters
	//       a space-sep sequence of char row col
	// DOES: parses the string on whitespace
	//	 then traverses the array setting style for the letters
	//
	function show_word( word , color )
	{
		var rv;
		if ( word == "" )
			return true;

		var str = sols[word];
		if ( !str || str == "" ){
			return false;
		}
		if ( prev_hilite != "" ){
			var save = prev_hilite;
			prev_hilite = "";
			show_word( save, "black" );
		}

		// alert("show_word for " + word );
		// alert("the string is " + str );

		var tokens = str.split( /  */ );
		rv = set_cells( tokens, color );
		prev_hilite = word;
		return rv;
	}

	//
	// set_cells -- set the sequence of cells to the given color
	//	
	// args: array of HBF data, color
	// rets: true if ok, false if bad cell ID
	//
	function set_cells( tokens, color )
	{
		var i = 0, len;
		var c, row, col, id;
		var obj;
		len = tokens.length-1;
		// alert("len is " + len );
		var val;
		var let = 0;
		var wsf = "";
		var reused = "";

		while( i<len ){
			c   = tokens[i++];
			if ( c < "A" || c > "Z" ) {
				continue;
			}
			let++;
			wsf += c;
			row = tokens[i++];
			col = tokens[i++];
			id = "C" + row + "_" + col;
			obj = document.getElementById( id );
			if ( !obj ){
				alert("bad location: " + row + ", " + col );
				return false;
			}
			// val = vals[id];
			val = obj.getAttribute("value");
			var msg = "looking at object at " + id 
				+ " val is " + val
				+ "\nand c is " + c;
			// alert( msg );
			// note: a U in the word matches a Q cube face
			if ( val == c || c == 'U' && val == 'Q' ){
				if ( obj.style.color == color ){
					reused += ( " " + let + ":" + c );
				}
				obj.style.color = color;
			}
			else {
				var msg = "wrong letter at: " 
					+ row + "," + col + "\n"
					+ "let = " + let + " chr = " + c 
					+ " brd = " + val ;
				alert( msg );
				return false;
			}
		}
		if ( reused != "" && color != "black" ){
			alert("Reused letters in " + wsf + reused );
		}
		return true;
	}

//
// ---------- send requests to solver and validator --------------------
//
//  show_solution     -- call the solver for the solution
//  parse_HBF_list    -- receive and store the solution
//
	//
	// handler for the solve button
	// 
	//
	function show_solution()
	{
		if ( timeleft > 0 )
			return;
		var	seed = document.getElementById('bbseed').value;
		var	dims = document.getElementById('bbsize').value;

		say_solving();
		ajax_get( solver + "?" + seed + dims, parse_HBF_list );
	}

	function say_solving()
	{
		var msg = "<div class='announce'>Solving<blink>...</blink>"
			+ "</div>";
		set_computer_solution( msg );
	}
	function set_computer_solution( s )
	{
		document.getElementById('solution_cell').innerHTML = s;
	}

	//
	// parse a set of words sent as a string in Hescott Boggle Format
	// For each, add it to the array of words and sequences
	//	AND make a link to put on the page
	//	set the list of those links to the contents of
	//	the div called solution_cell
	//
	//  If string has no < or > then just print the message and
	//  be done with it
	//
	//  store the answer in bbsols for debugging purposes
	//
	function parse_HBF_list( str )
	{
		sols = new Array();		// allocate new array for sols
		vals = new Array();		// this maps id to value
		var s = str.split( /[<>]/ );	// split into words
		var numwords = s.length;	// count them
		var i;
		var solution = "";

		if ( numwords < 3 ){
			solution = str;
		}
		else {
			for(i=1; i<numwords; i += 2) {
				solution += parse_HBF_word(s[i]);
			}
		}
		set_computer_solution( solution );
		record_sol_data( str );
	}

	//
	// this is a sequence of triples: Char row col
	// figure out the word embedded therein and assign the 
	// sequence to that item in the array
	//
	// ALSO return the link for the word
	//
	function parse_HBF_word( w )
	{
		var word = "";
		var tokens = w.split( /  */ );
		var len = tokens.length;
		var i = 0;
		var link;
		var chr;
		var r,c;
		var cellID;

		if ( len == 0 ){
			return "";
		}
		//
		// this array has LET ROW COL LET ROW COL LET ROW COL ...
		// so grab the LET adn add it to word
		// then build a cellID of the form C#_# 
		// and store that char in vals[cellID]
		// finally, store the entire string in sols[wordID]
		// and make the word be a link to show_word(wordID)
		//
		while( i < len ){
			chr = tokens[i++].toUpperCase();
			if( chr < "A" || chr > "Z" ){
				continue;
			}
			word += chr;
			r = tokens[i++];
			c = tokens[i++];
			cellID = "C" + r + "_" + c ;
			vals[ cellID ] = chr ;
		}
		sols[num_words] = w;
		link = "<span onmouseover='show_word(" + '"' + num_words + '"'
			+ ', "red")' + "'>" + word + "</span><br/>\n";
		num_words++;
		return link;
	}

	//
	// post the user input to the validator
	// results are sent back to the same window
	// but the readOnly flag is still on
	//
	function validate_user_input()
	{
		if ( timeleft > 0 )
			return;

		var ans  = document.getElementById('human_input').value ;
		var dims = document.getElementById('bbsize').value;
		var seed = document.getElementById('bbseed').value;
		var prog = checker + '?' + seed + dims;

		set_input_readonly( true );
		enable_buttons();		// 
		ajax_put( prog, ans, display_validation_results );
	}

	//
	// display results of validation
	//  arg is just a big string with newlines in it
	//
	function display_validation_results(s)
	{
		set_human_input(s);
	}

//
// ---------- timer functions ------------------------------------------
//
//    start_time      -- start the game
//    toggle_timer    -- stop or start depending
//    ticker          -- called every second to update time
//    show_timeleft   -- display remaining time on page
//
	function start_timer()
	{
		set_input_readonly( false );		// allow user input
		disable_buttons();			// no checking now
		set_human_input( "" );			// on a blank textarea
		timeleft = gametime;			// start time
		show_timeleft(timeleft);		// show it
		if ( timer_obj != null )		// restart timer
			clearInterval( timer_obj );
		timer_obj = setInterval(ticker, 1000 );
	}
		
	function toggle_timer()
	{
		if ( timer_obj )
			stop_timer();
		else 
			start_timer();
	}
	//
	// called every 5 seconds
	// does: counts down the timer
	// when: timer gets to 0, disable the user input window
	//
	function ticker()
	{
		if ( timeleft > 1 ){
			timeleft -= 1;
			show_timeleft(timeleft);
			return;
		}
		stop_timer();
		set_input_readonly( true );
		enable_buttons();
	}

	function stop_timer()
	{
		if ( timer_obj != null )
			clearInterval( timer_obj );
		timeleft = 0;
		timer_obj = null;
		show_timeleft(0);
		enable_buttons();
	}
	function show_timeleft( amt )
	{
		var msg = "Time Left " + amt ;
		if ( amt > 0 )
			msg = msg + "<br> click to stop";

		document.getElementById("timeleft").innerHTML = msg;
	}
//
// ---------- debugging/tracing functions ------------------------------
//

	//
	// store the string in bbsols for later viewing
	//
	function record_sol_data( str )
	{
		if ( document.getElementById('bbsols') ){
			document.getElementById('bbsols').value = str;
		}
	}

	function show_internal_data()
	{
		var content = '';
		var seed = document.getElementById('bbseed').value;
		var sols = document.getElementById('bbsols').value;

		content = 'seed = ' + seed + '\n';
		content += 'sols = ' + sols + '\n';

		var w = window.open("", "_blank",  "");
		w.document.writeln('<html><body><pre>');
		w.document.writeln( content );
		w.document.writeln('</pre></body></html>');
		w.document.close();
	}
