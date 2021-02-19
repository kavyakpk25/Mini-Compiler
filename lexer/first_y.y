%{
#include<stdio.h>
#include<stdlib.h>
#include<ctype.h>
#include<string.h>
extern FILE *yyin;
void yyerror();
int yylex();
char * type;
extern unsigned int SourceCol;
extern unsigned int SourceLine;
/*typedef struct SCOPE_NODE
	{
	int current;
	struct SCOPE_NODE * next;
	}SCOPE_NODE;*/
typedef struct NODE
	{
	char* name;
	char* type;
	}NODE;
/*
typedef struct symbol_table
	{
		NODE* head;
		int entries;
	}TABLE;*/
typedef struct FINAL
{
	int scope_arr[100];
	int len;
	int count;
	NODE data_arr[100];
	struct FINAL *next;
	}FINAL;
	
typedef struct LIST{
	FINAL *head;
	FINAL *tail;
	int count;
	}LIST;

char *data_type;
int * current_scope;
char *name;
int index_;
void insert(char *data_type,char *name, int index0);
char *dtype;
LIST *list;
%}
%locations
%union{
	int number;
	double real;
	char *string;
	}
%token <string> T_lround T_rround T_lflower T_rflower T_semi T_comma T_dot CLASS PUBLIC PRIVATE PROTECTED INT_PTR FLOAT_PTR BOOL T_TRUE T_FALSE T_col T_lt T_gt T_lteq T_gteq T_sq T_rsq T_lsq T_amp USING NAMESPACE T_neq T_eqeq T_pl T_min T_mul T_div T_and T_or T_incr T_decr T_not T_eq WHILE INT CHAR FLOAT VOID H MAINTOK INCLUDE BREAK CONTINUE IF ELSE COUT STRING FOR ENDL SWITCH CASE DEFAULT RETURN STRING_LIT CHAR_CONST
%token <number> T_DIGIT
%token <real> T_REAL
%token ID CHAR_PTR 
%type <string> TYPE FUNCTION_DEF ID PARAMS BODY ASSIGN_EXPR CHAR_PTR CLASS_DEF PTR_TYPE

%%
S
      : START {printf("Input accepted.\n");}
      ;

START
      : INCLUDE T_lt H T_gt START
      | INCLUDE "\"" H "\""  START
      | INCLUDE T_lt ID T_gt  START
      | INCLUDE "\"" ID "\""  START
      | INCLUDE T_lt H T_gt START_CODE 
      | INCLUDE "\"" H "\"" START_CODE
      | INCLUDE T_lt ID T_gt START_CODE
      | INCLUDE "\"" ID "\"" START_CODE
      ;

START_CODE : 
           | USING NAMESPACE ID T_semi GLOBAL
           | GLOBAL
           ;

GLOBAL : ASSIGN_EXPR T_semi  GLOBAL
      | ARITH_EXPR T_semi GLOBAL
      | DECLARATION T_semi GLOBAL 
      | FUNCTION_DEF GLOBAL
      | CLASS_DEF GLOBAL
      | PTR_EXPR T_semi GLOBAL
      | OBJ_EXPR T_semi GLOBAL
      | ARR_EXPR T_semi GLOBAL
      | MAIN 
      ;
MAIN
      : TYPE MAINTOK BODY 
      | TYPE MAINTOK BODY FUNC_AND_DEC
      | TYPE MAINTOK BODY CLASS_REC 
      | TYPE MAINTOK BODY FUNC_AND_DEC CLASS_REC
      | TYPE MAINTOK BODY CLASS_REC FUNC_AND_DEC
      ;
CLASS_REC: CLASS_REC CLASS_DEF
      | CLASS_DEF 
      ;

FUNC_AND_DEC: ASSIGN_EXPR T_semi  FUNC_AND_DEC
      | ARITH_EXPR T_semi FUNC_AND_DEC
      | ASSIGN_EXPR T_semi
      | ARITH_EXPR T_semi
      | FUNCTION_DEF
      | FUNCTION_DEF FUNC_AND_DEC
      | DECLARATION T_semi FUNC_AND_DEC
      | DECLARATION T_semi
      ;
func_paran_o:
	T_lround	{ index_++;current_scope[index_]+=1;} ;
func_paran_c:
	T_rround	{current_scope[index_]-=1;index_--;};

flower_paran_o:
	T_lflower	 { index_++;current_scope[index_]+=1;/*for(int i=0;i<=index_;i++){
	printf("%d.",current_scope[i]);} printf("opening_parna\n");*/} ;

flower_paran_c:
	T_rflower	{index_--;/*for(int i=0;i<=index_+1;i++){
	printf("%d.",current_scope[i]);}printf("closing_parana\n");*/};

BODY
      : flower_paran_o C flower_paran_c
      | flower_paran_o flower_paran_c
      
      ;

PARAMS : TYPE ID
      | TYPE ID T_comma PARAMS
      | CHAR_PTR ID
      | CHAR_PTR ID T_comma PARAMS
      | PTR_TYPE ID
      | PTR_TYPE ID T_comma PARAMS
      ;

FUNCTION_DEF
      : TYPE ID func_paran_o PARAMS func_paran_c BODY {insert(strcat($1,"_func"),$2,index_);}
      | TYPE ID func_paran_o func_paran_c BODY {insert(strcat($1,"_func"),$2,index_);}
      | TYPE ID func_paran_o PARAMS func_paran_c T_semi {insert(strcat($1,"_func"),$2,index_);}
      | TYPE ID func_paran_o func_paran_c T_semi {insert(strcat($1,"_func"),$2,index_);}
      | VOID ID func_paran_o PARAMS func_paran_c BODY {insert(strcat($1,"_func"),$2,index_);}
      | VOID ID func_paran_o func_paran_c BODY {insert(strcat($1,"_func"),$2,index_);}
      | VOID ID func_paran_o PARAMS func_paran_c T_semi {insert(strcat($1,"_func"),$2,index_);}
      | VOID ID func_paran_o func_paran_c T_semi {insert(strcat($1,"_func"),$2,index_);}
      | PTR_TYPE ID func_paran_o PARAMS func_paran_c BODY {insert(strcat($1,"_func"),$2,index_);}
      | PTR_TYPE ID func_paran_o func_paran_c BODY {insert(strcat($1,"_func"),$2,index_);}
      | PTR_TYPE ID func_paran_o PARAMS func_paran_c T_semi {insert(strcat($1,"_func"),$2,index_);}
      | PTR_TYPE ID func_paran_o func_paran_c T_semi {insert(strcat($1,"_func"),$2,index_);}
      | CHAR_PTR ID func_paran_o PARAMS func_paran_c T_semi {insert(strcat($1,"_func"),$2,index_);}
      | CHAR_PTR ID func_paran_o func_paran_c T_semi {insert(strcat($1,"_func"),$2,index_);}
      | CHAR_PTR ID func_paran_o PARAMS func_paran_c BODY {insert(strcat($1,"_func"),$2,index_);}
      | CHAR_PTR ID func_paran_o func_paran_c BODY {insert(strcat($1,"_func"),$2,index_);}
     ;
C
      : C statement T_semi
      | C LOOPS
      | statement T_semi
      | LOOPS
      | C ID func_paran_o ARRAY func_paran_c T_semi
      | C ID func_paran_o  func_paran_c T_semi
      | ID func_paran_o ARRAY func_paran_c T_semi
      | ID func_paran_o  func_paran_c T_semi
      | error
      ;

CLASS_DEF : CLASS ID flower_paran_o CLASS_BODY flower_paran_c T_semi {insert($1,$2,index_);} 
      | CLASS ID flower_paran_o flower_paran_c T_semi {insert($1,$2,index_);}
      ;

CLASS_BODY : PUBLIC T_col FUNC_AND_DEC 
      | PUBLIC T_col FUNC_AND_DEC CLASS_BODY
      | PRIVATE T_col FUNC_AND_DEC 
      | PRIVATE T_col FUNC_AND_DEC CLASS_BODY
      | PROTECTED T_col FUNC_AND_DEC
      | PROTECTED T_col FUNC_AND_DEC CLASS_BODY
      | PUBLIC T_col CLASS_BODY
      | PRIVATE T_col CLASS_BODY
      | PROTECTED T_col CLASS_BODY
      | PUBLIC T_col
      | PRIVATE T_col
      | PROTECTED T_col

      ;

LOOPS
      : SWITCH T_lround LIT T_rround flower_paran_o SWITCHBODY flower_paran_c
      | IF T_lround COND T_rround LOOPBODY 
      | IF T_lround COND T_rround LOOPBODY ELSE LOOPBODY 
      ;

SWITCHBODY
      : CASE LIT T_col SWITCHBODY
      | CASE LIT T_col
      | CASE LIT T_col BREAK T_semi SWITCHBODY
      | CASE LIT T_col LOOPBODY BREAK T_semi SWITCHBODY
      | CASE LIT T_col LOOPBODY SWITCHBODY
      | CASE LIT T_col LOOPBODY BREAK T_semi
      | CASE LIT T_col LOOPBODY
      | DEFAULT T_col LOOPBODY BREAK T_semi
      | DEFAULT T_col LOOPBODY
      | DEFAULT T_col BREAK T_semi
      | DEFAULT T_col
      ;

LOOPBODY
  	  : flower_paran_o C flower_paran_c
        | flower_paran_o C BREAK T_semi flower_paran_c
  	  | T_semi
  	  | statement T_semi 
        | flower_paran_o flower_paran_c
        | error
      ;
statement
      : DECLARATION
      | ASSIGN_EXPR
      | ARITH_EXPR
      | TERNARY_EXPR
      | PTR_EXPR
      | ARR_EXPR
      | OBJ_EXPR
      | PRINT
      | RETURN 
      | RETURN T_lround ARITH_EXPR T_rround
      | RETURN ARITH_EXPR
      | error
      ;
COND
      : LIT RELOP LIT
      | LIT
      | LIT RELOP LIT bin_boolop LIT RELOP LIT
      | un_boolop T_lround LIT RELOP LIT T_rround
      | un_boolop LIT RELOP LIT
      | LIT bin_boolop LIT
      | un_boolop T_lround LIT T_rround
      | un_boolop LIT
      | error
      ;

ASSIGN_EXPR
      : ID T_eq ARITH_EXPR {insert(dtype,$1,index_);}
      | TYPE ID T_eq ARITH_EXPR {insert(dtype,$2,index_);}
      | CHAR_PTR ID T_eq STRING_LIT {($1,$2,index_);}
      ;

DECLARATION
      : TYPE ID  {insert($1,$2,index_);}
      | DECLARATION T_comma ID   {insert(dtype,$3,index_);}
      | CHAR_PTR ID {insert($1,$2,index_);}
      ;
ARITH_EXPR
      : LIT
      | LIT bin_arop ARITH_EXPR
      | LIT RELOP ARITH_EXPR
      | LIT bin_boolop ARITH_EXPR
      | LIT un_arop
      | un_arop ARITH_EXPR
      | un_boolop ARITH_EXPR
      ;

TERNARY_EXPR
      : T_lround COND T_rround '?' statement T_col statement
      ;

REP_PRINT:
        T_lt T_lt LIT
      | T_lt T_lt LIT REP_PRINT
      | T_lt T_lt ENDL
      | T_lt T_lt ENDL REP_PRINT

PRINT
      : COUT REP_PRINT 
      ;
LIT
      : ID
      | STRING_LIT 
      | CHAR_CONST
      | T_DIGIT
      | T_REAL
      | T_TRUE
      | T_FALSE
      ;
TYPE
      : INT {dtype=yylval.string;}
      | CHAR {dtype=yylval.string;}
      | FLOAT {dtype=yylval.string;}
      | STRING {dtype=yylval.string;}
      | BOOL {dtype=yylval.string;}
      ;
PTR_TYPE : INT_PTR {dtype=yylval.string;}
      | FLOAT_PTR {dtype=yylval.string;}
      ;
PTR_EXPR: PTR_TYPE ID {insert($1,$2,index_);}
      | PTR_TYPE ID T_eq T_amp ID {insert($1,$2,index_);}
      | CHAR_PTR ID T_eq T_amp ID {insert($1,$2,index_);}
      | ID T_eq T_amp ID
      ;
ARR_EXPR: TYPE ID T_lsq T_DIGIT T_rsq {insert(strcat($1,"_arr"),$2,index_);}
      | TYPE ID T_lsq T_DIGIT T_rsq T_eq T_lflower ARRAY T_rflower {insert(strcat($1,"_arr"),$2,index_);}
      | TYPE ID T_sq T_eq T_lflower ARRAY T_rflower {insert(strcat($1,"_arr"),$2,index_);}
      | ID T_lsq T_DIGIT T_rsq T_eq ARRAY 
      ;
OBJ_EXPR : ID ID  {insert(strcat($1,"_obj"),$2,index_);}
      | ID T_dot ID T_eq LIT 
      | ID T_dot ID T_lround T_rround 
      | ID T_dot ID T_lround ARRAY T_rround 
      ;
ARRAY
      : LIT
      | ARRAY T_comma LIT 
      ;

RELOP
      : T_lt
      | T_gt
      | T_lteq
      | T_gteq
      | T_neq
      | T_eqeq
      ;

bin_arop
      : T_pl
      | T_min
      | T_mul
      | T_div
      ;

bin_boolop
      : T_and
      | T_or
      ;

un_arop
      : T_incr
      | T_decr
      ;

un_boolop
      : T_not
      ;

  ;

%%
#include "lex.yy.c"
      
void yyerror(){
      //yyerrok; yyclearin;
      printf("Error at line %d\n",yylineno);
}

int yywrap ()
 {
 return 1;
 }
 /*SCOPE_NODE * init_scope_node(){
 	SCOPE_NODE * scope_node= (SCOPE_NODE *)malloc(sizeof(SCOPE_NODE));
 	scope_node.next=NULL;
 	return scope_node;
 	}
 NODE * init_node(){
 	NODE *node=(NODE*)malloc(sizeof(NODE));
 	node->next=NULL;
 	return node;
 	}
 TABLE *init_table(){
	TABLE *table=(TABLE*) malloc(sizeof(TABLE));
	table->head=NULL;
	table->entries=0;
	return table;
	}*/
FINAL* create_final(NODE node,int index0){
	FINAL *final=(FINAL*)malloc(sizeof(FINAL));
	for(int i=0;i<=index0;i++){
		final->scope_arr[i]=current_scope[i];
		}
	final->len=index0;
	final->count=1;
	final->data_arr[0]=node;
	return final;
	}
void node_insert(NODE node,FINAL * final){
	final->count+=1;
	final->data_arr[final->count-1]=node;
	return;
	}
int check_match(int index0,FINAL* final){
	if(index0!=final->len){
		return 0;
		}
	for(int i=0;i<=index0;i++){
		if(final->scope_arr[i]!=current_scope[i]){
			return 0;
			}
		}
	return 1;
	}
FINAL* return_final(int index0){
	FINAL *head=list->head;
	while(head){
		if(check_match(index0,head)){
			return head;
		}
		head=head->next;
		}
	return NULL;
	}
		
void insert(char *data_type,char *name, int index0){
	NODE node;
	node.name=name;
	node.type=data_type;
	if(list->head==NULL){
		FINAL *final=create_final(node,index0);
		list->count=1;
		list->head=final;
		list->tail=final;
		}
	else{
		FINAL* cur=return_final(index0);
		if(cur){
			node_insert(node,cur);
			}
		else{
			FINAL *final=create_final(node,index0);
			list->count+=1;
			FINAL *temp=list->tail;
			temp->next=final;
			list->tail=final;
			}
	}
	
}

void display_table()
{
	FINAL *head=list->head;
      printf("\n\n\n\nSYMBOL TABLE\n\n\n\n");
	while(head)
      {
		printf("\n\nscope of table ");
		for(int i=0;i<=head->len;i++){
			printf("%d.",head->scope_arr[i]);
			}
		printf("\n\n");
		for(int i=0;i<head->count;i++){
			printf("%s	%s	\n",head->data_arr[i].name,head->data_arr[i].type);
			}
		head=head->next;
	}
}
		
int main(int argc, char  **argv)
{
	list=(LIST *)malloc(sizeof(LIST));
	list->head=NULL;
	list->count=0;
	current_scope=(int*)malloc(100*sizeof(int));
	current_scope[0]=1;
	index_=0;
	char fname[100];
	yyin=fopen(argv[1],"r");
	yyparse();
	display_table();
	return 0;
}

