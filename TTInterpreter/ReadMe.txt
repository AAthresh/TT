﻿Pre-requisites


1. Please make sure you have java 6 or higher installed on your machine and present in your PATH variable.


2.  Please make sure Apache-Ant latest version(1.8.2) installed on your machine. You can find the installation details here


http://ant.apache.org/manual/install.html 

If you are running this on ubuntu, you can execute the following command :

sudo apt-get install ant


Deployment


1.  Download the source the remote repository : https://github.com/mymichellle/TT.git .

2. Navigate to the project root directory ‘ TTInterpreter’. If you have downloaded the code from the remote repository, you will find the following directory structure 

TT-Master
	|	
	|
	|
	|	
TTInterpreter
	src
	lib
	ExampleCode (you can ignore this for now)
	build.xml
	TT.sh
	Read Me.txt
	
	
cd TTMaster/TTInterpreter. 

TTInterpreter is the project root directory. You should find a build.xml file, the ReadMe.txt file and a TT.sh file
Once you are in TTInterpreter execute the following:

ant compile-interpreter 

This should generate the ‘classes’ folder that has all the class files required for the interpreter to run.


3.  Execute the following command 

./TT.sh  <path-to-tt-source-code>


For example, if you have helloworld.tt under the following directory , /home/athresh/Code/helloworld.tt , then the command will be

./TT.sh /home/athresh/Code/helloworld.tt     

You can find sample programs in  TTInterpreter/src/columbia/plt/tt/programs

If you receive permission denied error on TT.sh , please enable the execute permission on the TT.sh file. Command for the same will be

chmod +x  TT.sh
