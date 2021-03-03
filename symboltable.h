
	struct symboltable
	{
		char name[100];
		char class[100];
		char type[100];
		char value[100];
		int nestval;
		int lineno;
		int length;
		int params_count;
	}symboltable[1001];

 struct stack
{
	char value[100];
	int labelvalue;
}s[100],label[100];



    int hash(char *str);
    int findintable(char *str);
    void insertlineno(char *str1, int line);
    void insert(char *str1, char *str2);
    void insertSTtype(char *str1, char *str2);
    void insertSTvalue(char *str1, char *str2);
    void insertSTnest(char *s, int nest);
    void insertSTparamscount(char *s, int count);
    int getSTparamscount(char *s);
    void insertSTF(char *s);
    void deletedata (int nesting);
    int checkscope(char *s);
    int check_id_is_func(char *s);
    int checkarray(char *s);
    int duplicate(char *s);
    int check_duplicate(char* str);
    int check_declaration(char* str, char *check_type);
    int check_params(char* type_specifier);
    char gettype(char *s, int flag);
    void printtable();
    void push(char *x);
    void swap(char *x, char *y);
    void l2();
    void reverse(char str[], int length);
    char* itoa(int num, char* str, int base);
    void codegen();
    void codegencon();
    void l3();
    void l4();
    int isunary(char *s);
    void genunary();
    void codeassign();
    void l1();
    void funcgen();
    void funcgenend();
    void l5();
    void arggen();
    void callgen();

    



