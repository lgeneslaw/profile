$(document).ready(function(){
	
	var tips = $('<p>still not working?</p><aside><h2>Tips</h2><ul><li><h4>Processing.js implements Processing, but not all of Java</h4><p>If your sketch uses functions or classes not defined as part of Processing, they are unlikely to work with Processing.js. Similarly, libraries that are written for Processing, which are written in Java instead of Processing, will most likely not work.</p></li><li><h4>Be careful with variable and function names</h4><p>Because your Processing code is interpreted by Processing.js, there will be some inconsistencies. Don&#39;t have variable names that are the same as Processing functions (i.e. a variable named <em>line</em> would cause issues because of the Processing function <em>line()</em>. Another important tip is to not have variables of different types with the same name (because JavaScript, unlike Java, is typeless) or have variables with the same name as functions.</p></li><li><h4>Check the Javascript console for error messages</h4><p>If you are using Chrome, you can go to View > Developer > Javascript console. All major browsers will let you view the console if you can find it in the menu bar.</p></li><li><h4>Get Help</h4><p><a href="http://www.cs.tufts.edu/comp/150VIZ/" target="_blank">Email a TA</a> or check out the <a href="http://processingjs.org/articles/p5QuickStart.html" target="_blank">processing.js FAQ</a></li></ul></aside>');

	tips.insertAfter('canvas');	
	
	var opened = false;
	
	$('section > p').click(function () {
		if(opened) {
			$('aside').slideUp();
			$(this).text('still not working?');	
			opened = false;		
		} else {
			$('aside').slideDown();
			$(this).text('hide');		
			opened = true;	
		}
	});
});