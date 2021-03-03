%{

#include <stdio.h>
#include <stdlib.h>
#include "ctype.h"
#include "string.h"
#include "symboltable.h"


void yyerror(char* s);
int yylex();
void inserttype();
void insertvalue();
int flag=0;
extern char curid[20];
extern char curval[20];
char currfunc[100];
char currfunccall[100];
extern int currnest;
extern char curtype[20];
char currfunctype[100];
int params_count=0;
int call_params_count=0;
int top = 0,count=0,ltop=0,lno=0;
char temp[3] = "t";



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
			: identifier {if(duplicate(curid)){printf("Redeclaration not allowed\n");exit(0);}insertSTnest(curid,currnest); inserttype();  } abc   
			  | array_identifier {if(duplicate(curid)){printf("Redeclaration not allowed\n");exit(0);}insertSTnest(curid,currnest); inserttype();  } abc;
			
			

abc : identifier_array_type | assign_op simple_expression  ; 

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
            : INT MAIN '(' ')' statement;

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
			: IF '(' simple_expression ')' {l1();if($3!=1){printf("Condition checking is not of type int\n");exit(0);}} statement {l2();} conditional_statements_breakup;

conditional_statements_breakup
			: ELSE statement {l3();}
			| {l3();};

iterative_statements 
			: WHILE '(' {l4();} simple_expression ')'  {l1();if($4!=1){printf("Condition checking is not of type int\n");exit(0);}} statement {l5();};


return_statement 
			: RETURN ';' 
			| RETURN expression ';' { 	
										if((currfunctype[0]=='i' || currfunctype[0]=='c') && $2!=1)
										{
											printf("Expression doesn't match return type of function\n"); exit(0);
										}
			              
			                     	};

string_initilization
			: assign_op string_literal {insertvalue();} ;

array_initialization
			: assign_op '{' array_int_declarations '}';

array_int_declarations
			: int_literal array_int_declarations_breakup;

array_int_declarations_breakup
			: ',' array_int_declarations 
			| ;

expression 
			: mutable assign_op {push("=");} expression            {
																	  if($1==1 && $4==1) 
																	  {
			                                                          $$=1;
			                                                          } 
			                                                          else 
			                                                          {$$=-1; printf("Type mismatch\n"); exit(0);}
                                                                      codeassign(); 
			                                                       }

                                                                                                                              
			| mutable doubleplus_op 							{ push("++");if($1 == 1) $$=1; else $$=-1; genunary();}
			| mutable doubleminus_op 							{ push("--");if($1 == 1) $$=1; else $$=-1;}
			| simple_expression {if($1 == 1) $$=1; else $$=-1;} ;


simple_expression 
			: simple_expression logicor and_expression {push("||");} {if($1 == 1 && $3==1) $$=1; else $$=-1; codegen();}
			| and_expression {if($1 == 1) $$=1; else $$=-1;};

and_expression 
			: and_expression logicand {push("&&");} unary_relation_expression {if($1 == 1 && $3==1) $$=1; else $$=-1; codegen();}
			  |unary_relation_expression {if($1 == 1) $$=1; else $$=-1;} ;


unary_relation_expression 
			: not_op {push("!");} unary_relation_expression {if($2==1) $$=1; else $$=-1; codegen();} 
			| regular_expression {if($1 == 1) $$=1; else $$=-1;} ;

regular_expression 
			: regular_expression relational_operators sum_expression {if($1 == 1 && $3==1) $$=1; else $$=-1; codegen();}
			  | sum_expression {if($1 == 1) $$=1; else $$=-1;} ;
			
relational_operators 
			: geq_op {push(">=");}| leq_op {push("<=");}| g_op {push(">");}
			| l_op {push("<");} | doubleequal_op {push("==");} | notequal_op {push("!=");};

sum_expression 
			: sum_expression sum_operators term  {if($1 == 1 && $3==1) $$=1; else $$=-1; codegen();}
			| term {if($1 == 1) $$=1; else $$=-1;};

sum_operators 
			: add_op {push("+");}
			| sub_op {push("-");};

term
			: term MULOP factor {if($1 == 1 && $3==1) $$=1; else $$=-1; codegen();}
			| factor {if($1 == 1) $$=1; else $$=-1;} ;

MULOP 
			: mul_op  {push("*");} | div_op {push("/");}| mod_op {push("%");} ;

factor 
			: immutable {if($1 == 1) $$=1; else $$=-1;} 
			| mutable {if($1 == 1) $$=1; else $$=-1;} ;

mutable 
			: identifier {
                          push(curid);
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
			| call {if($1==-1) $$=-1; else $$=1;} 
			| constant {if($1==1) $$=1; else $$=-1;};

call
			: identifier '('{
			             if(!check_declaration(curid, "Function"))
			             {printf("Function not declared"); exit(0);} 
			             insertSTF(curid); 
						 strcpy(currfunccall,curid);
                         if(gettype(curid,0)=='i' || gettype(curid,1)== 'c')
						 {
			             $$ = 1;
			             }
			             else
			             $$ = -1;
                         call_params_count=0;
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
                            callgen();
						 };

arguments 
			: arguments_list | ;

arguments_list 
			: arguments_list ',' exp { call_params_count++; }  
			| exp { call_params_count++; };

exp : identifier {arggen(1);} | int_literal {arggen(2);} | string_literal {arggen(3);} | float_literal {arggen(4);} | char_literal {arggen(5);} ;

constant 
			: int_literal 	{  insertvalue(); codegencon(); $$=1; } 
			| string_literal	{  insertvalue();codegencon(); $$=-1;} 
			| float_literal	{  insertvalue(); codegencon(); } 
			| char_literal{  insertvalue(); codegencon();$$=1; };

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
		printf("Parsing Successfull\n");
	}
}

void yyerror(char *s)
{
	printf("%d %s %s\n", yylineno, s, yytext);
	flag=1;
	printf("Parsing Error\n");
	exit(7);
}

void inserttype()
{
	insertSTtype(curid,curtype);
}

void insertvalue()
{
	insertSTvalue(curid,curval);
}

int yywrap()
{
	return 1;
}
