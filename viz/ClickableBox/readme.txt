CS150 - Data Visualization

Putting your Processing Project up on the Web

	1. In order to add your files to your personal Tufts CS web directory, they must be 
	   located in a folder in your "public_html" folder. For example, for user John
	   Smith, the files in "public_html/example" can be seen at:
	   
	   				www.cs.tufts.edu/~jsmith01/example
	   				
	   To transfer files from your personal computer to your web directory, you'll need 
	   an SFTP client. For Macs, CyberDuck is free and easy to use and for PCs, use
	   WinSCP. Make sure that you are using SFTP, not FTP. The server name will be 
	   linux.cs.tufts.edu, and your username and password are the same as you use to
	   SSH into the linux machines.
	   
    	2. Once your files are in the appropriate directory, you'll need to make sure that the
       	   proper permissions are set on *all* files and directories. This includes the internal 
           "js" directory and its contents. You can do this either in your SFTP client by right 
           clicking on the file/directory and setting them in the info/permissions/whatever section
           or you can do it in the command line via SSH with the "chmod" command. Directories 
           require permissions set to 755, and files require 644. Example:
       
	   				chmod 755 example
	   				chmod 644 example/index.html          				
	   				
	3. To get your Processing project running, you'll need to modify the index.html file to
	   link in your .pde files in the "data-processing-sources" section. Example:
	   
	   <canvas id="processing" data-processing-sources="File1.pde File2.pde File3.pde"></canvas>
	   
	   The sample Main.pde should not be included, obviously. Your .pde and any .csv 
           (or any other data) files must be in the *same* directory as index.html.
	   
	   Additionally, you'll need to set the "width" of the <section> container in the html to
	   correspond to the width of your visualization.
	   
	4. Email a TA or go to processingjs.org for more help.