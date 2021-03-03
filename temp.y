%{

#include <stdio.h>
#include <stdlib.h>
#include "ctype.h"
#include "string.h"
#include "symboltable.h"


void yyerror(char* s);
int yylex();
void ins();
void insV();
int flag=0;
extern char curid[20];
extern char curtype[20];
extern char curval[20];
char currfunctype[100];
char currfunc[100];
char currfunccall[100];
extern int currnest;
extern int params_count;
int call_params_count;





// // Number of rows in Hash table for symbol and constant tables
// // #define MAX_NODES 1000

// // void yyerror(char * s);

// symbolnode *table[2000];
// // symbolnode *constant_table[2000];

// // To track the current scope so that out of scope errors can be found
// scopeinfo *csi;

// extern char *yytext;
// extern int yylineno;

// char datatype[100];
// // int num_params;

// symbolnode * checkredefined(char *value);

%}

%nonassoc IF
%nonassoc ELSE
%token identifier array_identifier 
%token INT 
%token CHAR 
%token FLOAT 
%token WHILE 
%token RETURN MAIN
%token int_literal string_literal float_literal char_literal
%expect 1

%right assign_op tilda_op not_op
%left logicand logicor doubleplus_op doubleminus_op leq_op geq_op doubleequal_op notequal_op l_op g_op
%left leftshift_op rightshift_op bxor_op band_op bor_op sub_op add_op mul_op div_op mod_op comma_op pointer_op


%start program

%%
program
			: declaration_list;

declaration_list
			: declaration declaration_list
            | declaration;


declaration
			: variable_declaration 
			| function_declaration

variable_declaration
			: type_specifier variable_declaration_list ';' 

variable_declaration_list
			: variable_declaration_list ',' variable_declaration_identifier | variable_declaration_identifier;

variable_declaration_identifier 
			: identifier {if(duplicate(curid)){printf("Duplicate\n");exit(0);}insertSTnest(curid,currnest); ins();  } vdi   
			  | array_identifier {if(duplicate(curid)){printf("Duplicate\n");exit(0);}insertSTnest(curid,currnest); ins();  } vdi;
			
			

vdi : identifier_array_type | assign_op simple_expression  ; 

identifier_array_type
			: '['int_literal']' initilization {if($2 < 1) {printf("Wrong array size\n"); exit(0);} }
            | '['']' string_initilization
			| ;

initilization
			: string_initilization
			| array_initialization
			| ;

type_specifier 
			: INT | CHAR | FLOAT 
			;

function_declaration
			: function_declaration_type function_declaration_param_statement;

function_declaration_type
			: type_specifier identifier '('  { strcpy(currfunctype, curtype); strcpy(currfunc, curid); check_duplicate(curid); insertSTF(curid); ins(); };

function_declaration_param_statement
			: params ')' statement;

params 
			: parameters_list | ;

parameters_list 
			: type_specifier { check_params(curtype); } parameters_identifier_list { insertSTparamscount(currfunc, params_count); };

parameters_identifier_list 
			: param_identifier parameters_identifier_list_breakup;

parameters_identifier_list_breakup
			: ',' parameters_list 
			| ;

param_identifier 
			: identifier { ins();insertSTnest(curid,1); params_count++; } param_identifier_breakup;

param_identifier_breakup
			: '[' ']'
			| ;

statement 
			: expression_statment | compound_statement 
			| conditional_statements | iterative_statements 
			| return_statement 
			| variable_declaration;

compound_statement 
			: {currnest++;} '{'  statment_list  '}' {deletedata(currnest);currnest--;}  ;

statment_list 
			: statement statment_list 
			| ;

expression_statment 
			: expression ';' 
			| ';' ;

conditional_statements 
			: IF '(' simple_expression ')' {if($3!=1){printf("Condition checking is not of type int\n");exit(0);}} statement conditional_statements_breakup;

conditional_statements_breakup
			: ELSE statement
			| ;

iterative_statements 
			: WHILE '(' simple_expression ')' {if($3!=1){printf("Condition checking is not of type int\n");exit(0);}} statement ;


return_statement 
			: RETURN ';' {if(strcmp(currfunctype,"void")) {printf("Returning void of a non-void function\n"); exit(0);}}
			| RETURN expression ';' { 	if(!strcmp(currfunctype, "void"))
										{ 
											yyerror("Function is void");
										}

										if((currfunctype[0]=='i' || currfunctype[0]=='c') && $2!=1)
										{
											printf("Expression doesn't match return type of function\n"); exit(0);
										}
			              
			                     	};

string_initilization
			: assign_op string_literal {insV();} ;

array_initialization
			: assign_op '{' array_int_declarations '}';

array_int_declarations
			: int_literal array_int_declarations_breakup;

array_int_declarations_breakup
			: ',' array_int_declarations 
			| ;

expression 
			: mutable assign_op expression              {
																	  if($1==1 && $3==1) 
																	  {
			                                                          $$=1;
			                                                          } 
			                                                          else 
			                                                          {$$=-1; printf("Type mismatch\n"); exit(0);} 
			                                                       }

                                                                                                                              
			| mutable doubleplus_op 							{if($1 == 1) $$=1; else $$=-1;}
			| mutable doubleminus_op 							{if($1 == 1) $$=1; else $$=-1;}
			| simple_expression {if($1 == 1) $$=1; else $$=-1;} ;


simple_expression 
			: simple_expression logicor and_expression {if($1 == 1 && $3==1) $$=1; else $$=-1;}
			| and_expression {if($1 == 1) $$=1; else $$=-1;};

and_expression 
			: and_expression logicand unary_relation_expression {if($1 == 1 && $3==1) $$=1; else $$=-1;}
			  |unary_relation_expression {if($1 == 1) $$=1; else $$=-1;} ;


unary_relation_expression 
			: not_op unary_relation_expression {if($2==1) $$=1; else $$=-1;} 
			| regular_expression {if($1 == 1) $$=1; else $$=-1;} ;

regular_expression 
			: regular_expression relational_operators sum_expression {if($1 == 1 && $3==1) $$=1; else $$=-1;}
			  | sum_expression {if($1 == 1) $$=1; else $$=-1;} ;
			
relational_operators 
			: geq_op| leq_op | g_op 
			| l_op | doubleequal_op | notequal_op ;

sum_expression 
			: sum_expression sum_operators term  {if($1 == 1 && $3==1) $$=1; else $$=-1;}
			| term {if($1 == 1) $$=1; else $$=-1;};

sum_operators 
			: add_op 
			| sub_op ;

term
			: term MULOP factor {if($1 == 1 && $3==1) $$=1; else $$=-1;}
			| factor {if($1 == 1) $$=1; else $$=-1;} ;

MULOP 
			: mul_op | div_op | mod_op ;

factor 
			: immutable {if($1 == 1) $$=1; else $$=-1;} 
			| mutable {if($1 == 1) $$=1; else $$=-1;} ;

mutable 
			: identifier {
						  if(check_id_is_func(curid))
						  {printf("Function name used as Identifier\n"); exit(8);}
			              if(!checkscope(curid))
			              {printf("%s\n",curid);printf("Undeclared\n");exit(0);} 
			              if(!checkarray(curid))
			              {printf("%s\n",curid);printf("Array ID has no subscript\n");exit(0);}
			              if(gettype(curid,0)=='i' || gettype(curid,1)== 'c')
			              $$ = 1;
			              else
			              $$ = -1;
			              }
			| array_identifier {if(!checkscope(curid)){printf("%s\n",curid);printf("Undeclared\n");exit(0);}} '[' expression ']' 
			                   {if(gettype(curid,0)=='i' || gettype(curid,1)== 'c')
			              		$$ = 1;
			              		else
			              		$$ = -1;
			              		};

immutable 
			: '(' expression ')' {if($2==1) $$=1; else $$=-1;}
			| call 
			| constant {if($1==1) $$=1; else $$=-1;};

call
			: identifier '('{
			             if(!check_declaration(curid, "Function"))
			             {printf("Function not declared"); exit(0);} 
			             insertSTF(curid); 
						 strcpy(currfunccall,curid);
			             } arguments ')' 
						 { if(strcmp(currfunccall,"printf"))
							{ 
								if(getSTparamscount(currfunccall)!=call_params_count)
								{	
									yyerror("Number of arguments in function call doesn't match number of parameters");
									//printf("Number of arguments in function call %s doesn't match number of parameters\n", currfunccall);
									exit(8);
								}
							} 
						 };

arguments 
			: arguments_list | ;

arguments_list 
			: expression { call_params_count++; } A ;

A
			: ',' expression { call_params_count++; } A 
			| ;

constant 
			: int_literal 	{  insV(); $$=1; } 
			| string_literal	{  insV(); $$=-1;} 
			| float_literal	{  insV(); } 
			| char_literal{  insV();$$=1; };

%%







extern FILE *yyin;
extern int yylineno;
extern char *yytext;


int main(int argc , char **argv)
{
	yyin = fopen(argv[1], "r");
	yyparse();

	if(flag == 0)
	{
		printf("Parsing Complete - Valid","\n");
		printf("SYMBOL TABLE\n");
		printf("------------");
		printST();

		printf("CONSTANT TABLE\n");
		printf("--------------");
		printCT();
	}
}

void yyerror(char *s)
{
	printf("%d %s %s\n", yylineno, s, yytext);
	flag=1;
	printf("Status: Parsing Failed - Invalid\n");
	exit(7);
}

void ins()
{
	insertSTtype(curid,curtype);
}

void insV()
{
	insertSTvalue(curid,curval);
}

int yywrap()
{
	return 1;
}



//changed declaration list D and identifier_array_type change these to normal to go back to the modiied working type 