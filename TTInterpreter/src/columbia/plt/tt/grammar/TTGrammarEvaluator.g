tree grammar TTGrammarEvaluator;

options {
  language = Java;
  tokenVocab = TTGrammar;
  ASTLabelType = CommonTree;
}

@header {
  package columbia.plt.tt;
  import columbia.plt.tt.datatype.Calendar;
  import columbia.plt.tt.datatype.Date;
  import columbia.plt.tt.datatype.Task;
  import columbia.plt.tt.datatype.TimeFrame;
  import columbia.plt.tt.interpreter.*;
  import columbia.plt.tt.evaluator.implementations.*;
  import org.antlr.runtime.BitSet;
  import java.util.*;
}

@members {
  private SymbolTable symbolTable = new SymbolTable();

  private ArrayList<String> errors = new ArrayList<String>();  
  
  public ArrayList<String> getErrors()
  {
	return errors;
  }
}


// Variable declaration and definition
//@Author : Athresh

declarationStatement
  : ^(e=type IDENT) {			
  	
  		
  		//we can try switch here if all of you are using java 7
  		if( e == "String"){
  			int scopeID = symbolTable.addScope();
  			symbolTable.getScope(scopeID).addSymbol($IDENT.text, "String", null);				

  		}
  		if( e == "Number"){
  			int scopeID = symbolTable.addScope();
  			symbolTable.getScope(scopeID).addSymbol($IDENT.text, "Number", null);				
 
  		}
  		if( e == "Bool"){
  			int scopeID = symbolTable.addScope();
  			symbolTable.getScope(scopeID).addSymbol($IDENT.text, "Bool", null);				
 
  		}
  		
  		if( e == "Date"){
  			int scopeID = symbolTable.addScope();
  			symbolTable.getScope(scopeID).addSymbol($IDENT.text, "Date", null);					
  		
  		}
  		if( e == "TimeFrame"){
  			int scopeID = symbolTable.addScope();
  			symbolTable.getScope(scopeID).addSymbol($IDENT.text, "TimeFrame", null);				

  		}
  		if (e == "Calendar") {				
  			int scopeID = symbolTable.addScope();
  			symbolTable.getScope(scopeID).addSymbol($IDENT.text, "Calendar", null);				
  			
  		}
  		if( e == "Task"){
  			int scopeID = symbolTable.addScope();
  			symbolTable.getScope(scopeID).addSymbol($IDENT.text, "Task", null);				
  		}
  	}
  ;

definitionStatement
	: ^(t=type as=assignmentStmt) {
	
		if(t == "String"){
			// code to check if as is string
		}
	
	}
	
	;

assignmentStmt returns [Evaluator result]
	:	^(ASSIGN IDENT e=expression)
	| ^(ASSIGN memberAccessExpression e=expression)
	;

type returns [String result]
  : 'String' {result = "String";}
  | 'Number' {result = "Number";}
  | 'Bool' {result = "Bool";}
  | 'Date' {result = "Date";}
  | 'Task' {result = "Task";}
  | 'TimeFrame' {result = "TimeFrame";}
  | 'Calendar' {result = "Calendar";}
  ;

//zheng
checkType returns [BOOL result]
  : 
  ;
  
memberAccessExpression
	:	^(DOT IDENT IDENT )
	;
	
//Statement
//@Author : Michelle


statement 
  : statement_type+
  ;

statement_type 
  : print
  | declarationStatement
  |	definitionStatement
  | ifThenStatement
  | everyFromToByStatement
  | everyInStatement
  | breakStatement
  | continueStatement
  | exitStatement
  | readStatement
  | functionInvocationStatement
  ;

ifThenStatement
  : 'if' '(' expression ')' '{' statement_type* '}' elseStatement
  ;

elseStatement
  : 'else' '{' statement_type* '}'
  |
  ;
/*
everyFromToByStatement
  :'every' 'Date' IDENT 'from' dateOrIdent 'to' dateOrIdent 'by' timeframeOrIdent '{' statement_type* '}'
  ;
*/
everyFromToByStatement
  : ^('every' dateVar=IDENT start=dateOrIdent end=dateOrIdent increment=timeframeOrIdent statements=statement_type*)
  {
         System.out.println("HMM: "+$increment.result);
         // Get the current scope
              Scope currentScope = symbolTable.getCurrentScope();
              
              // Add the Date IDENT to the current symbol table
              Date itterDate = new Date(start.getYear(), start.getMonth(), start.getDay(), start.getHour(), start.getMinute());
              currentScope.addSymbol($dateVar.text, "Date", itterDate);
              
              System.out.println("begin itterDate " + itterDate.toString());
              
          System.out.println(input.LT(0));
          BufferedTreeNodeStream stream = (BufferedTreeNodeStream)input;
          int place = stream.mark();
          
          stream.seek(place);
        // Perform a while loop incrementing the dateVar by increment each loop
        while( itterDate.compareTo((Date)end) <= 0) {
          int day = itterDate.getDay();
          day += $increment.result.getDays();
          
          // Update the itterDate variable
          itterDate.setDay(day);
          currentScope.addSymbol($dateVar.text, "Date", itterDate);
        
          System.out.println("loopDate " + itterDate.toString());
          System.out.println(input.LT(1));
          //stream.rewind(place);
        }
    }
 // 'every' 'Date' IDENT 'from' dateOrIdent 'to' dateOrIdent 'by' timeframeOrIdent '{' statement_type* '}' 
  ;

everyInStatement
  : 'every' 'Task' IDENT 'in' IDENT constraintOptions  '{' statement_type* '}'
  ;
  
constraintOptions
  : 'from' dateOrIdent 'to' dateOrIdent loopOptions
  | loopOptions
  ;
  
loopOptions
  : 'on' expression
  |
  ;
  
dateOrIdent returns [Date result]
  : IDENT         { Scope scope = symbolTable.getCurrentScope();
                    $result = (Date)scope.getSymbol($IDENT.text);}
  | DATE_CONSTANT	{ $result = new Date($DATE_CONSTANT.text);}
  ; 
  
timeframeOrIdent returns [TimeFrame result]
  : IDENT
  { 
    // TODO get the saved IDENT data
    $result = new TimeFrame("1 days");}
  | t=timeFrameConstant { $result = $t.result;}
  ;
    
breakStatement
  : 'break' ';'
  ;
  
continueStatement
  : 'continue' ';'
  ;
  
exitStatement
  : 'exit' ';'
  ;
  
readStatement
  : 'Read' '(' STRING ')' ';'
  ;
  
functionInvocationStatement
  : functionInvocation ';'
  ;
  
functionInvocation
  : IDENT argumentList
  ;
  
argumentList
  : '(' expressionList? ')'
  ;
  
expressionList
  : expression (','expression)*
  ;
  

print : ^('print' '(' STRING_CONSTANT ')') 		{System.out.println($STRING_CONSTANT.text);} ; 

timeFrame returns [String result]
  : p=primaryExpression
    t=('year'|'years'|'month'|'months'|'day'|'days'|'hour'|'hours'|'minute'|'minutes') 
    {
      //TODO get primaryExpression
      $result = "1 "+$t.text;
    }
  ;

timeFrameConstant returns [TimeFrame result]
  : t1=timeFrame (p='+' t2=timeFrame)* 
  {
    if ($t2.result != null && $p.text != null)
       $result = new TimeFrame($t1.result + " " + $p.text + " " + $t2.result);
    else
      $result = new TimeFrame($t1.result);
    }
 ;

//// Arithmetic Expressions .. Jason
//// @Author : Jason

         
  
expression returns [Evaluator result]
	:^(PLUS s1=STRING s2=STRING)						{ result = s1.concat(s2);}
	|^(OR op1 = expression op2=expression) 	{	result = op1 || op2;}
	|^(AND op1= expression op2=expression)	{ result = op1 && op2;}
	|^(o = (EQUALS | NOTEQUALS) 
	op1=expression op2=expression)  				{ if (o == "==")
		 																					result = (op1 == op2);
		 																				else (o == "!=")
		 																					result = (op1 != op2);	}
	|	^(o = (LT | LTEQ | GT | GTEQ) 
		op1=expression op2=expression) 				{	if (o == "<")
																							result = op1 < op2;
																					else if ( o == ">")
																						result = op1 > op2;
																					else if( o == ">=")
																						result = (op1 >=op2);
																					else if (o == "<=")
																						result = (op1 <=op2);}
	| ^(o = (PLUS| MINUS) 
	op1=expression op2=expression)					{ if (o == '+')
		 																						result = op1 + op2;
		 																				else if( o == '-')
		 																						result = op1 - op2;
		 		
		 																			}																					
	| ^(o = (MULT | DIV | MOD) 
	op1=expression op2=expression)					{ if( o == '*')
																								result = op1 * op2;
																						else if( o == '/')
																								result = op1 / op2;
																					 }	

	|	 ^(o=(NOT?) e= expression)						{ if (o == '!') result = !e;}																			 



	| IDENT 																{symbolTable.get($IDENT.text);}
	
	| CONSTANT															{ result = $CONSTANT.text;}
	;
	
primaryExpression 
  : '(' expression ')'
  | NUMBER
  | IDENT
    ;
