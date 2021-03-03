
%{
	#include "y.tab.h"
	#include <stdio.h>
	#include <string.h>

	char curid[20];
	char curtype[20];
	char curval[20];

	int currnest = 0;
	extern int yylval;


%}

%%
\n 	{yylineno++;}
\/\/(.*)																		{ }
\/\*([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*\*+\/										{ }
[ \n\t] ;
";"				{ return(';'); }
","				{ return(','); }
("{")			{ return('{'); }
("}")			{ return('}'); }
"("				{ return('('); }
")"				{ return(')'); }
("[")		    { return('['); }
("]") 		    { return(']'); }

"char"			{ strcpy(curtype,yytext); insert(yytext, "Keyword");return CHAR;}
"else"			{ insert(yytext, "Keyword"); return ELSE;}
"float"			{ strcpy(curtype,yytext); insert(yytext, "Keyword"); return FLOAT;}
"while"			{ insert(yytext, "Keyword"); return WHILE;}
"if"			{ insert(yytext, "Keyword"); return IF;}
"int"			{ strcpy(curtype,yytext); insert(yytext, "Keyword"); return INT;}
"return"		{ insert(yytext, "Keyword"); return RETURN;}
"main"			{ insert(yytext, "Keyword"); return MAIN;}	




"++"			{ return doubleplus_op; }
"--"			{ return doubleminus_op; }
"<<"			{ return leftshift_op; }
">>"			{ return rightshift_op; }
"<="			{ return leq_op; }
"<"				{ return l_op; }
">="			{ return geq_op; }
">"				{ return g_op; }
"=="			{ return doubleequal_op; }
"!="			{ return notequal_op; }
"^"				{ return bxor_op; }
"&"				{ return band_op; }
"|"				{ return bor_op; }
"!"				{ return not_op; }
"~"				{ return tilda_op; }
"-"				{ return sub_op; }
"+"				{ return add_op; }
"*"				{ return mul_op; }
"/"				{ return div_op; }
"%"				{ return mod_op; }
"->"            { return pointer_op;}
"="             {return assign_op;}
"&&"			{return logicand;}
"||"			{return logicor;}


\"[^\n]*\"/[;|,|\)] 			{strcpy(curval,yytext);  return string_literal;}
\'[A-Z|a-z]\'/[;|,|\)|:] 		{strcpy(curval,yytext);  return char_literal;}
[a-z|A-Z]([a-z|A-Z]|[0-9])*/\[ 	{strcpy(curid,yytext); insert(yytext, "array_identifier");  return array_identifier;}
[1-9][0-9]*|0/[;|,|" "|\)|<|>|=|\!|\||&|\+|\-|\*|\/|\%|~|\]|\}|:|\n|\t|\^] 	{strcpy(curval,yytext);  yylval = atoi(yytext); return int_literal;}
([0-9]*)\.([0-9]+)/[;|,|" "|\)|<|>|=|\!|\||&|\+|\-|\*|\/|\%|~|\n|\t|\^] 	{strcpy(curval,yytext);  return float_literal;}
[A-Za-z_][A-Za-z_0-9]* {strcpy(curid,yytext); insert(curid,"Identifier"); return identifier;}

%%