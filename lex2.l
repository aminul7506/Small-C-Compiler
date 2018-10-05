
%{
#include<stdio.h>
#include<stdlib.h>
#include<iostream>
#include<string>
#include<string.h>
#include<sstream>
#include<fstream>
#include "y.tab.h"



using namespace std;

int line_count=1;
int error_count = 0;
extern YYSTYPE yylval;

%}

WHITESPACE [ \t\f\r\v]+ 
LETTER [a-zA-Z]
DIGIT [0-9]
FLOAT_NUMBER [0-9]*([.][0-9]+)?(E[+-]?[0-9]+)?
NEWLINE \n
CHARACTER '[A-Za-z0-9]'
CHARACTER_EX '\\[ntabfv0\r"v]'
IDENTIFIER ([A-Za-z_]([A-Za-z0-9_]*)?)
NOT_IDENTIFIER [0-9]+[A-Za-z0-9_]+

SINGLE_LINE_COMMENT "//"[^\n]*

DECIMAL_POINT_ERROR [0-9]*[.][0-9]*([.]+[0-9]*)*
ILL_FORMATTED_NUMBER  [0-9]*((E[+-]?[0-9]+)([.][0-9]+)*)(E[+-]?[0-9]+)?([.][0-9]+)*
ILL_FORMATTED_CHAR '[A-Za-z0-9][A-Za-z0-9]+'
UNDETERMINED_CHAR '[A-Za-z0-9]*

%%



{NEWLINE} {	line_count++;
		
		
		}	
{WHITESPACE} {}

"main"	{
			return MAIN;
		}


"if"	{
			return IF;
		}

"for"	{
			return FOR;
		}
"do"	{
			return DO;
		}
"int"	{
			return INT;
		}
"float"	{
			return FLOAT;

		}
"void"	{
			return VOID;
		}
"switch"	{
			return SWITCH;
		}
"default"	{
			return DEFAULT;
		}

"else"	{
			return ELSE;
		}
"while"	{
			return WHILE;
		}
"break"	{
			return BREAK;
		}
"char"	{
			return CHAR;
		}
"double"	{
			return DOUBLE;
		}
"return"	{
			return RETURN;
		}
"case"	{
			return CASE;
		}
"continue"	{
			return CONTINUE;
		}
"println"	{
			return PRINTLN;
		}

{DIGIT}+ 	{
			//	cmain("CONST_INT");
				//SymbolInfo *s;
				//s->name = string(yytext);
				//s->type = "CONST_INT";
				//yylval = (YYSTYPE)s;
				yylval.i = atoi(yytext);
				return CONST_INT;
			}
{FLOAT_NUMBER}	{
			//	cmain("CONST_FLOAT");
				//SymbolInfo s;
				//s.setValue(yytext, (char *)"CONST_FLOAT");
				yylval.f = atof(yytext);
				
				return CONST_FLOAT;
			}
{CHARACTER}	{
			//	cmain("CONST_CHAR");
				//SymbolInfo s= new  SymbolInfo();
				//s.setValue(yytext, (char *)"CONST_CHAR");
				//char a = yytext[0];
				yylval.st = strdup(yytext);
				return CONST_CHAR;
			}
{CHARACTER_EX}	{
			//	cmain("CONST_CHAR");				
				//SymbolInfo s= new  SymbolInfo();
				//s.setValue(yytext, (char *)"CONST_CHAR");
				//char a = yytext[0];
				yylval.st = strdup(yytext);
				return CONST_CHAR;
			}
{IDENTIFIER}	{
			//	cmain("ID");
				//s.setValue(yytext, (char *)"ID");
		//		yylval.st = (YYSTYPE)s;
				yylval.st = strdup(yytext);
				
				return ID;
			}

[+-]		{
			//SymbolInfo s= new  SymbolInfo();
			//s.setValue(yytext, (char *)"ADDOP");
			//yylval = (YYSTYPE)s;
			yylval.st = strdup(yytext);
			//cmain("ADDOP");
			return ADDOP;
			}
[*/%]		{
			//SymbolInfo s= new  SymbolInfo();
			//s.setValue(yytext, (char *)"MULOP");
			//yylval = (YYSTYPE)s;
			//cmain("MULOP");
			yylval.st = strdup(yytext);
			return MULOP;
			}
"++"		{
			//cmain("INCOP");
			return INCOP;
			}
"--"		{
			//cmain("DECOP");
			
			return DECOP;
			}
">"|">="|"<"|"<="|"=="|"!="		{
			//cmain("RELOP");
			//SymbolInfo s= new  SymbolInfo();
			//s.setValue(yytext, (char *)"RELOP");
			//yylval = (YYSTYPE)s;
			yylval.st = strdup(yytext);
			return RELOP;
			}
"="		{
			//cmain("ASSIGNOP");
			
			return ASSIGNOP;
			}
"&&"|"||"	{
			//cmain("LOGICOP");
			//SymbolInfo s= new  SymbolInfo();
			//s.setValue(yytext, (char *)"LOGICOP");
			//yylval = (YYSTYPE)s;
			yylval.st = strdup(yytext);
			return LOGICOP;
	}
"!"            {return NOT;}
"("		{
			//cmain("LPAREN");
			
			return LPAREN;

			}
")"		{
			//cmain("RPAREN");
			
			return RPAREN;
			}
"{"		{
			//cmain("LCURL");
			
			return LCURL;
			}
"}"		{
			//cmain("RCURL");
			
			return RCURL;
			}
"["		{
			//cmain("LBRACKET");
			
			return LBRACKET;
			}
"]"		{
			//cmain("RBRACKET");
			
			return RBRACKET;
			}
","		{
			//cmain("COMMA");
			
			return COMMA;
			}
";"		{
			//cmain("SEMICOLON");
			
			return SEMICOLON;
			}


<<EOF>> 	{
			//g.~SymbolTable();
			
			return 0;
			}

%%

int yywrap()
{
	
	return 1;
}
