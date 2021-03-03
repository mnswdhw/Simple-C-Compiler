    #include <stdlib.h>
    #include <stdio.h>
    #include <string.h>
    #include "symboltable.h"

	extern int currnest;
	extern int params_count;
    extern int call_params_count;
    extern int top,count,ltop,lno;
    extern char temp[3];
	extern int yylval;
    extern FILE *yyin;
    extern int yylineno;
    extern char *yytext;
	extern char currfunctype[100];
	extern char currfunc[100];
	extern char currfunccall[100];
    extern char curid[20];
    extern char curtype[20];
    extern char curval[20];

	int hash(char *str)
	{
		int value = 0;
		for(int i = 0 ; i < strlen(str) ; i++)
		{
			value = 10*value + (str[i] - 'A');
			value = value % 1001;
			while(value < 0)
				value = value + 1001;
		}
		return value;
	}

	int findintable(char *str)
	{
		int value = hash(str);
		if(symboltable[value].length == 0)
		{
			return 0;
		}
		else if(strcmp(symboltable[value].name,str)==0)
		{
			
			return value;
		}
		else
		{
			for(int i = value + 1 ; i!=value ; i = (i+1)%1001)
			{
				if(strcmp(symboltable[i].name,str)==0)
				{
					
					return i;
				}
			}
			return 0;
		}
	}



	void insertlineno(char *str1, int line)
	{
		for(int i = 0 ; i < 1001 ; i++)
		{
			if(strcmp(symboltable[i].name,str1)==0)
			{
				symboltable[i].lineno = line;
			}
		}
	}


	void insert(char *str1, char *str2)
	{
		if(findintable(str1))
		{
			if(strcmp(symboltable[findintable(str1)].class,"Identifier")==0 && strcmp(str2,"Array Identifier")==0)
			{
				printf("Error in using array\n");
				exit(0);
			}	
			return;
		}
		else
		{
			int value = hash(str1);
			if(symboltable[value].length == 0)
			{
				strcpy(symboltable[value].name,str1);
				strcpy(symboltable[value].class,str2);
				symboltable[value].length = strlen(str1);
				symboltable[value].nestval = 9999;
				symboltable[value].params_count = -1;
				insertlineno(str1,yylineno);
				return;
			}

			int pos = 0;

			for (int i = value + 1 ; i!=value ; i = (i+1)%1001)
			{
				if(symboltable[i].length == 0)
				{
					pos = i;
					break;
				}
			}

			strcpy(symboltable[pos].name,str1);
			strcpy(symboltable[pos].class,str2);
			symboltable[pos].length = strlen(str1);
			symboltable[pos].nestval = 9999;
			symboltable[pos].params_count = -1;
		}
	}

	void insertSTtype(char *str1, char *str2)
	{
		for(int i = 0 ; i < 1001 ; i++)
		{
			if(strcmp(symboltable[i].name,str1)==0)
			{
				strcpy(symboltable[i].type,str2);
			}
		}
    }

	void insertSTvalue(char *str1, char *str2)
	{
		for(int i = 0 ; i < 1001 ; i++)
		{
			if(strcmp(symboltable[i].name,str1)==0 && symboltable[i].nestval == currnest)
			{
				strcpy(symboltable[i].value,str2);
			}
		}
	}


	void insertSTnest(char *s, int nest)
	{
		if(findintable(s) && symboltable[findintable(s)].nestval != 9999)
		{
             int pos = 0;
             int value = hash(s);
			for (int i = value + 1 ; i!=value ; i = (i+1)%1001)
			{
				if(symboltable[i].length == 0)
				{
					pos = i;
					break;
				}
			}

			strcpy(symboltable[pos].name,s);
			strcpy(symboltable[pos].class,"Identifier");
			symboltable[pos].length = strlen(s);
			symboltable[pos].nestval = nest;
			symboltable[pos].params_count = -1;
			symboltable[pos].lineno = yylineno;
		}
		else
		{
			for(int i = 0 ; i < 1001 ; i++)
			{
				if(strcmp(symboltable[i].name,s)==0 )
				{
					symboltable[i].nestval = nest;
				}
			}
		}
	}

	void insertSTparamscount(char *s, int count)
	{
		for(int i = 0 ; i < 1001 ; i++)
		{
			if(strcmp(symboltable[i].name,s)==0 )
			{
				symboltable[i].params_count = count;
			}
		}
	}

	int getSTparamscount(char *s)
	{
		for(int i = 0 ; i < 1001 ; i++)
		{
			if(strcmp(symboltable[i].name,s)==0 )
			{
				return symboltable[i].params_count;
			}
		}
		return -2;
	}

	void insertSTF(char *s)
	{
		for(int i = 0 ; i < 1001 ; i++)
		{
			if(strcmp(symboltable[i].name,s)==0 )
			{
				strcpy(symboltable[i].class,"Function");
				return;
			}
		}

	}

	void deletedata (int nesting)
	{
		for(int i = 0 ; i < 1001 ; i++)
		{
			if(symboltable[i].nestval == nesting)
			{
				symboltable[i].nestval = 99999;
			}
		}


	}

	int checkscope(char *s)
	{
		int flag = 0;
		for(int i = 0 ; i < 1000 ; i++)
		{
			if(strcmp(symboltable[i].name,s)==0)
			{
				if(symboltable[i].nestval > currnest)
				{
					flag = 1;
				}
				else
				{
					flag = 0;
					break;
				}
			}
		}
		if(!flag)
		{
			return 1;
		}
		else
		{
			return 0;
		}
	}

	int check_id_is_func(char *s)
	{
		for(int i = 0 ; i < 1000 ; i++)
		{
			if(strcmp(symboltable[i].name,s)==0)
			{
				if(strcmp(symboltable[i].class,"Function")==0)
					return 1;
			}
		}
		return 0;
	}

	int checkarray(char *s)
	{
		for(int i = 0 ; i < 1000 ; i++)
		{
			if(strcmp(symboltable[i].name,s)==0)
			{
				if(strcmp(symboltable[i].class,"Array Identifier")==0)
				{
					return 0;
				}
			}
		}
		return 1;
	}

	int duplicate(char *s)
	{
		for(int i = 0 ; i < 1000 ; i++)
		{
			if(strcmp(symboltable[i].name,s)==0)
			{				
				if(symboltable[i].nestval == currnest)
				{
			        return 1;
				}
			}
		}
		
		return 0;
	}

	int check_duplicate(char* str)
	{
		for(int i=0; i<1001; i++)
		{
			if(strcmp(symboltable[i].name, str) == 0 && strcmp(symboltable[i].class, "Function") == 0)
			{
				printf("Function redeclaration not allowed\n");
				exit(0);
			}
		}
	}

	int check_declaration(char* str, char *check_type)
	{
		for(int i=0; i<1001; i++)
		{
			if(strcmp(symboltable[i].name, str) == 0 && strcmp(symboltable[i].class, "Function") == 0 || strcmp(symboltable[i].name,"printf")==0 )
			{
				return 1;
			}
		}
		return 0;
	}

	int check_params(char* type_specifier)
	{
		if(!strcmp(type_specifier, "void"))
		{
			printf("Void Parameters Not Allowed\n");
			exit(0);
		}
		return 0;
	}

	char gettype(char *s, int flag)
	{
			for(int i = 0 ; i < 1001 ; i++ )
			{
				if(strcmp(symboltable[i].name,s)==0)
				{
					return symboltable[i].type[0];
				}
			}
		
	}

    void printtable()
	{
		printf("%10s | %15s | %10s | %10s | %10s |\n","symbol", "category", "type","value", "line");
		printf("\n");
		for(int i = 0 ; i < 1001 ; i++)
		{
			if(symboltable[i].length == 0)
			{
				continue;
			}
			printf("%10s | %15s | %10s | %10s | %10d |\n",symboltable[i].name, symboltable[i].class, symboltable[i].type, symboltable[i].value, symboltable[i].lineno);
		}
    }





void push(char *x)
{
	strcpy(s[++top].value,x);
}

void swap(char *x, char *y)
{
	char temp = *x;
	*x = *y;
	*y = temp;
}

void reverse(char str[], int length) 
{ 
    int start = 0; 
    int end = length -1; 
    while (start < end) 
    { 
        swap((str+start), (str+end)); 
        start++; 
        end--; 
    } 
} 
  
char* itoa(int num, char* str, int base) 
{ 
    int i = 0; 
    int isNegative = 0; 
  
   
    if (num == 0) 
    { 
        str[i++] = '0'; 
        str[i] = '\0'; 
        return str; 
    } 
  
    if (num < 0 && base == 10) 
    { 
        isNegative = 1; 
        num = -num; 
    } 
  
   
    while (num != 0) 
    { 
        int rem = num % base; 
        str[i++] = (rem > 9)? (rem-10) + 'a' : rem + '0'; 
        num = num/base; 
    } 
  
    if (isNegative) 
        str[i++] = '-'; 
  
    str[i] = '\0'; 
  
   
    reverse(str, i); 
  
    return str; 
} 

void codegen()
{
	strcpy(temp,"t");
	char buffer[100];
	itoa(count,buffer,10);
	strcat(temp,buffer);
	printf("%s = %s %s %s\n",temp,s[top-2].value,s[top-1].value,s[top].value);
	top = top - 2;
	strcpy(s[top].value,temp);
	count++; 
}

void codegencon()
{
	strcpy(temp,"t");
	char buffer[100];
	itoa(count,buffer,10);
	strcat(temp,buffer);
	printf("%s = %s\n",temp,curval);
	push(temp);
	count++;
	
}

int isunary(char *s)
{
	if(strcmp(s, "--")==0 || strcmp(s, "++")==0)
	{
		return 1;
	}
	return 0;
}

void genunary()
{
	char temp1[100], temp2[100], temp3[100];
	strcpy(temp1, s[top].value);
	strcpy(temp2, s[top-1].value);

	if(isunary(temp1))
	{
		strcpy(temp3, temp1);
		strcpy(temp1, temp2);
		strcpy(temp2, temp3);
	}
	strcpy(temp, "t");
	char buffer[100];
	itoa(count, buffer, 10);
	strcat(temp, buffer);
	count++;

	if(strcmp(temp2,"--")==0)
	{
		printf("%s = %s - 1\n", temp, temp1);
		printf("%s = %s\n", temp1, temp);
	}

	if(strcmp(temp2,"++")==0)
	{
		printf("%s = %s + 1\n", temp, temp1);
		printf("%s = %s\n", temp1, temp);
	}

	top = top -2;
}

void codeassign()
{
	printf("%s = %s\n",s[top-2].value,s[top].value);
	top = top - 2;
}

void l1()
{
	strcpy(temp,"L");
	char buffer[100];
	itoa(lno,buffer,10);
	strcat(temp,buffer);
	printf("IF not %s GoTo %s\n",s[top].value,temp);
	label[++ltop].labelvalue = lno++;
}

void l2()
{
	strcpy(temp,"L");
	char buffer[100];
	itoa(lno,buffer,10);
	strcat(temp,buffer);
	printf("GoTo %s\n",temp);
	strcpy(temp,"L");
	itoa(label[ltop].labelvalue,buffer,10);
	strcat(temp,buffer);
	printf("%s:\n",temp);
	ltop--;
	label[++ltop].labelvalue=lno++;
}

void l3()
{
	strcpy(temp,"L");
	char buffer[100];
	itoa(label[ltop].labelvalue,buffer,10);
	strcat(temp,buffer);
	printf("%s:\n",temp);
	ltop--;
	
}

void l4()
{
	strcpy(temp,"L");
	char buffer[100];
	itoa(lno,buffer,10);
	strcat(temp,buffer);
	printf("%s:\n",temp);
	label[++ltop].labelvalue = lno++;
}


void l5()
{
	strcpy(temp,"L");
	char buffer[100];
	itoa(label[ltop-1].labelvalue,buffer,10);
	strcat(temp,buffer);
	printf("GoTo %s:\n",temp);
	strcpy(temp,"L");
	itoa(label[ltop].labelvalue,buffer,10);
	strcat(temp,buffer);
	printf("%s:\n",temp);
	ltop = ltop - 2;
    
   
}

void funcgen()
{
	printf("func begin %s\n",currfunc);
}

void funcgenend()
{
	printf("func end\n\n");
}

void arggen(int i)
{
    if(i==1)
    {
	printf("refparam %s\n", curid);
	}
	else
	{
	printf("refparam %s\n", curval);
	}
}

void callgen()
{
	printf("refparam result\n");
	push("result");
	printf("call %s, %d\n",currfunccall,call_params_count);
}


