import java.io.*;
import java_cup.runtime.ComplexSymbolFactory.ComplexSymbol;
import java_cup.runtime.ComplexSymbolFactory.Location;
import java_cup.runtime.ComplexSymbolFactory;
import java_cup.runtime.Symbol;
import java.util.*;

%%

%class Lexer
%cup
%line
%char
%column
%implements sym

%{

    ComplexSymbolFactory symbolFactory;
    public Lexer(java.io.Reader in, ComplexSymbolFactory sf){
	this(in);
	symbolFactory = sf;
    }
  
    private Symbol symbol(int sym) {
      return symbolFactory.newSymbol("sym", sym, new Location(yyline+1,yycolumn+1,yychar), new Location(yyline+1,yycolumn+yylength(),yychar+yylength()));
    }
  private Symbol symbol(int sym, Object val) {
      Location left = new Location(yyline+1,yycolumn+1,yychar);
      Location right= new Location(yyline+1,yycolumn+yylength(), yychar+yylength());
      return symbolFactory.newSymbol("sym", sym, left, right,val);
  } 
  private Symbol symbol(int sym, Object val,int buflength) {
      Location left = new Location(yyline+1,yycolumn+yylength()-buflength,yychar+yylength()-buflength);
      Location right= new Location(yyline+1,yycolumn+yylength(), yychar+yylength());
      return symbolFactory.newSymbol("sym", sym, left, right,val);
  }       
    
%}

D 		        = 	0 | [1-9][0-9]*
L               =	[A-Za-z]
AN		        = 	[0-9A-Za-z]
new_line       	=   \r|\n|\r\n
white_space    	=   {new_line} | [ \t\f]

%eofval{
     return symbolFactory.newSymbol("EOF", EOF, new Location(yyline+1,yycolumn+1,yychar), new Location(yyline+1,yycolumn+1,yychar+1));
%eofval} 

%%


<YYINITIAL>{
"if"			{ return symbol(IF, yytext()); }
"else" 			{ return symbol(ELSE, yytext()); }
"while"			{ return symbol(WHILE, yytext()); }

("{"|"<%")		{ return symbol(CURLYL, yytext()); }
("}"|"%>")		{ return symbol(CURLYR, yytext()); }
"("			{ return symbol(PARAL, yytext()); }
")"			{ return symbol(PARAR, yytext()); }

{L}({AN})*		{ return symbol(IDENT,yytext()); }
{D}			{ return symbol(INTCONST, new Integer(Integer.parseInt(yytext()))); }

"+="			{ return symbol(ADD_ASSIGN, yytext()); }
"-="			{ return symbol(SUB_ASSIGN, yytext()); }
"*="			{ return symbol(MUL_ASSIGN, yytext()); }
"/="			{ return symbol(SCROPPO_ASSIGN, yytext()); }
"%="			{ return symbol(MOD_ASSIGN, yytext()); }
"<="			{ return symbol(LE_OP,"<="); }
">="			{ return symbol(GE_OP,">="); }
"=="			{ return symbol(EQ_OP,"=="); }
"!="			{ return symbol(NE_OP,"!="); }
"&&"			{ return symbol(AND_OP,"&&"); }
"||"			{ return symbol(OR_OP,"||"); }
";"             { return symbol(SEMI,";"); }
"!"             { return symbol(NOT,"!"); }
"="             { return symbol(ASSIGN,"="); }
"-"	            { return symbol(MINUS); }
"+"	            { return symbol(PLUS,"+"); }
"*"	            { return symbol(MUL,"*"); }
"/"	            { return symbol(DIVIDE,"/"); }
"%"             { return symbol(MODULUS,"%"); }
"<"             { return symbol(LESS,"<"); }
">" 			{ return symbol(GREATER,">"); }

{white_space}		{ /* ignore bad characters */ }

}






