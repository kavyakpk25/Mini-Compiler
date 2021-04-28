%{
#include<stdio.h>
#include<stdlib.h>
#include<ctype.h>
#include<string.h>
#include "header.c"
#ifndef YACC
#define YYSTYPE YACC
#endif
#define MAX(X, Y) (((X) > (Y)) ? (X) : (Y))
FILE *yyin;
FILE *file;
FILE *file2;
void yyerror();
int yylex();
char * type;
int yylineno;
extern unsigned int SourceCol;
extern unsigned int SourceLine;
int arr[200];
int cur=0;
int temp=1;
int assign=1;
int cur_size=0;
int no_elem=0;
char* zero;
int find_type(char *name,int index0);
int find_space(char *type);
int check_define(char *name,int index0);
char*  return_type(int index);
int return_index(char *type);
char* class_names[20];
int cur_class=-1;
int decider=0;
char *switch_lit;
int defined=1;
int cur_type;
char cur_value[50];
int type0;
typedef struct NODE
	{
	char* name;
	char* type;
	int lineno;
	char value[40];
	}NODE;

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
int *current_scope;
char *name;
int index_;
void insert(char *data_type,char *name, int lineno,int index0,char* value);



char *dtype;
LIST *list;
%}


%token  T_lround T_rround T_lflower T_rflower T_semi T_comma T_dot CLASS PUBLIC PRIVATE PROTECTED INT_PTR FLOAT_PTR BOOL T_TRUE T_FALSE T_col T_lt T_gt T_lteq T_gteq T_sq T_rsq T_lsq T_amp USING NAMESPACE T_neq T_eqeq T_pl T_min T_mul T_div T_and T_or T_incr T_decr T_not T_eq WHILE INT CHAR FLOAT VOID H MAINTOK INCLUDE BREAK CONTINUE IF ELSE COUT STRING FOR ENDL SWITCH CASE DEFAULT RETURN STRING_LIT CHAR_CONST
%token T_DIGIT
%token T_REAL
%token ID CHAR_PTR


%%
S     : START
			{
				printf("Input accepted.\n");
			}
      ;

START : INCLUDE T_lt H T_gt START
      | INCLUDE "\"" H "\""  START
      | INCLUDE T_lt ID T_gt  START
      | INCLUDE "\"" ID "\""  START
      | INCLUDE T_lt H T_gt START_CODE
      | INCLUDE "\"" H "\"" START_CODE
      | INCLUDE T_lt ID T_gt START_CODE
      | INCLUDE "\"" ID "\"" START_CODE
      ;

START_CODE : USING NAMESPACE ID T_semi GLOBAL
           | GLOBAL
           ;

GLOBAL  : ASSIGN_EXPR T_semi{defined=1;} GLOBAL
				| EXPR T_semi {defined=1;}  GLOBAL
				| DECLARATION T_semi  {defined=1;} GLOBAL
				| FUNCTION_DEF GLOBAL
				| CLASS_DEF GLOBAL
				| PTR_EXPR T_semi {defined=1;} GLOBAL
				| OBJ_EXPR T_semi {defined=1;} GLOBAL
				| ARR_EXPR T_semi {defined=1;} GLOBAL
				| MAIN
				;


ASSIGN_TOK  : ASSIGN_EXPR T_semi
						{
								defined=1;
						}
			      ;

MAIN : TYPE MAINTOK  BODY_MAIN
      | TYPE MAINTOK BODY_MAIN   FUNC_AND_DEC
      | TYPE MAINTOK   BODY_MAIN  CLASS_REC
      | TYPE MAINTOK    BODY_MAIN FUNC_AND_DEC CLASS_REC
      | TYPE MAINTOK  BODY_MAIN   CLASS_REC FUNC_AND_DEC
      ;

BODY_MAIN  : flower_paran_o {fprintf(file,"main{\n");} C flower_paran_c{fprintf(file,"}\n");}
		       | flower_paran_o flower_paran_c {fprintf(file,"main{\n}\n");}
		       ;

CLASS_REC: CLASS_REC CLASS_DEF
      | CLASS_DEF
      ;

FUNC_AND_DEC: ASSIGN_TOK FUNC_AND_DEC
      | EXPR_TOK FUNC_AND_DEC
      | ASSIGN_TOK
      |EXPR_TOK
      | FUNCTION_DEF
      | FUNCTION_DEF FUNC_AND_DEC
      | DECL_TOK FUNC_AND_DEC
      | DECL_TOK
      ;

EXPR_TOK: EXPR T_semi {defined=1;}
          ;

DECL_TOK : DECLARATION T_semi {defined=1;}
         ;

func_paran_o:	T_lround	{ index_++; current_scope[index_]+=1;} ;

func_paran_c:	T_rround	{current_scope[index_]-=1;index_--;};

flower_paran_o: T_lflower	 { index_++;current_scope[index_]+=1;} ;

flower_paran_c:	T_rflower	{index_--;};

BODY  : flower_paran_o C flower_paran_c
      | flower_paran_o flower_paran_c
      ;

PARAMS  : TYPE ID   {insert($1.string,$2.string,@$.first_line,index_,"NOT_DEFINED");}
	      | TYPE ID T_comma   {insert($1.string,$2.string,@$.first_line,index_,"NOT_DEFINED");} PARAMS
	      | CHAR_PTR ID   {insert($1.string,$2.string,@$.first_line,index_,"NOT_DEFINED");}
	      | CHAR_PTR ID T_comma   {insert($1.string,$2.string,@$.first_line,index_,"NOT_DEFINED");} PARAMS
	      | PTR_TYPE ID   {insert($1.string,$2.string,@$.first_line,index_,"NOT_DEFINED");}
	      | PTR_TYPE ID T_comma   {insert($1.string,$2.string,@$.first_line,index_,"NOT_DEFINED");} PARAMS
	      ;

FUNCTION_DEF  : TYPE ID func_paran_o PARAMS func_paran_c  {char res[300]="";for (int i=0;i<=cur_class;i++){strcat(res,class_names[i]);strcat(res,".");} strcat(res,$2.string);fprintf(file,"%s{\n",res);} BODY {insert(strcat($1.string,"_func"),$2.string,@$.first_line,index_,"A_FUNCTION");fprintf(file,"}\n");}
				      | TYPE ID func_paran_o func_paran_c {char res[300]="";for (int i=0;i<=cur_class;i++){ strcat(res,class_names[i]);strcat(res,".");} strcat(res,$2.string);fprintf(file,"%s{\n",res);} BODY {insert(strcat($1.string,"_func"),$2.string,@$.first_line,index_,"A_FUNCTION");fprintf(file,"}\n");}
				      | TYPE ID func_paran_o PARAMS func_paran_c T_semi {insert(strcat($1.string,"_func"),$2.string,@$.first_line,index_,"A_FUNCTION");}
				      | TYPE ID func_paran_o func_paran_c T_semi {insert(strcat($1.string,"_func"),$2.string,@$.first_line,index_,"A_FUNCTION");}
				      | VOID ID func_paran_o PARAMS func_paran_c {char res[300]="";for (int i=0;i<=cur_class;i++){ strcat(res,class_names[i]);strcat(res,".");} strcat(res,$2.string);fprintf(file,"%s{\n",res);} BODY {insert(strcat($1.string,"_func"),$2.string,@$.first_line,index_,"A_FUNCTION");}
				      | VOID ID func_paran_o func_paran_c {char res[300]="";for (int i=0;i<=cur_class;i++){ strcat(res,class_names[i]);strcat(res,".");} strcat(res,$2.string);fprintf(file,"%s{\n",res);} BODY {insert(strcat($1.string,"_func"),$2.string,@$.first_line,index_,"A_FUNCTION");fprintf(file,"}\n");}
				      | VOID ID func_paran_o PARAMS func_paran_c T_semi {insert(strcat($1.string,"_func"),$2.string,@$.first_line,index_,"A_FUNCTION");}
				      | VOID ID func_paran_o func_paran_c T_semi {insert(strcat($1.string,"_func"),$2.string,@$.first_line,index_,"A_FUNCTION");}
				      | PTR_TYPE ID func_paran_o PARAMS func_paran_c {char res[300]="";for (int i=0;i<=cur_class;i++){ strcat(res,class_names[i]);strcat(res,".");} strcat(res,$2.string);fprintf(file,"%s{\n",res);} BODY {insert(strcat($1.string,"_func"),$2.string,@$.first_line,index_,"A_FUNCTION");fprintf(file,"}\n");}
				      | PTR_TYPE ID func_paran_o func_paran_c {char res[300]="";for (int i=0;i<=cur_class;i++){ strcat(res,class_names[i]);strcat(res,".");} strcat(res,$2.string);fprintf(file,"%s{\n",res);} BODY {insert(strcat($1.string,"_func"),$2.string,@$.first_line,index_,"A_FUNCTION");fprintf(file,"}\n");}
				      | PTR_TYPE ID func_paran_o PARAMS func_paran_c T_semi {insert(strcat($1.string,"_func"),$2.string,@$.first_line,index_,"A_FUNCTION");}
				      | PTR_TYPE ID func_paran_o func_paran_c T_semi {insert(strcat($1.string,"_func"),$2.string,@$.first_line,index_,"A_FUNCTION");}
				      | CHAR_PTR ID func_paran_o PARAMS func_paran_c T_semi {insert(strcat($1.string,"_func"),$2.string,@$.first_line,index_,"A_FUNCTION");}
				      | CHAR_PTR ID func_paran_o func_paran_c T_semi {insert(strcat($1.string,"_func"),$2.string,@$.first_line,index_,"A_FUNCTION");}
				      | CHAR_PTR ID func_paran_o PARAMS func_paran_c {char res[300]="";for (int i=0;i<=cur_class;i++){ strcat(res,class_names[i]);strcat(res,".");} strcat(res,$2.string);fprintf(file,"%s{\n",res);} BODY {insert(strcat($1.string,"_func"),$2.string,@$.first_line,index_,"A_FUNCTION");fprintf(file,"}\n");}
				      | CHAR_PTR ID func_paran_o func_paran_c {char res[300]="";for (int i=0;i<=cur_class;i++){ strcat(res,class_names[i]);strcat(res,".");} strcat(res,$2.string);fprintf(file,"%s{\n",res);} BODY {insert(strcat($1.string,"_func"),$2.string,@$.first_line,index_,"A_FUNCTION");fprintf(file,"}\n");}
				      ;

C     : C statement T_semi
      | C LOOPS
      | statement T_semi
      | LOOPS
      | C ID func_paran_o {fprintf(file,"call ( %s , %d ) \n",$2.string,no_elem);fprintf(file2,"|%-10s|%-10s|%-10d|%-10s|\n","call",$2.string,no_elem," ");no_elem=0;} ARRAY  func_paran_c T_semi
      | C ID func_paran_o  func_paran_c T_semi
      | ID func_paran_o {fprintf(file,"call ( %s , %d ) \n",$1.string,no_elem);fprintf(file2,"|%-10s|%-10s|%-10d|%-10s|\n","call",$1.string,no_elem," ");no_elem=0;} ARRAY   func_paran_c T_semi
      | ID func_paran_o  func_paran_c T_semi {fprintf(file,"call ( %s , 0 ) \n",$1.string);fprintf(file2,"|%-10s|%-10s|%-10d|%-10s|\n","call",$1.string,0," ");}
      | error
      ;

CLASS_DEF : CLASS ID flower_paran_o {fprintf(file,"%s{\n",$2.string); class_names[cur_class+1]=$2.string;cur_class+=1;} CLASS_BODY flower_paran_c T_semi {insert($1.string,$2.string,@$.first_line,index_,"A_CLASS");cur_class-=1;}
		      | CLASS ID flower_paran_o flower_paran_c T_semi {fprintf(file,"%s{\n}\n",$2.string);insert($1.string,$2.string,@$.first_line,index_,"A_CLASS");}
		      ;

CLASS_BODY  : PUBLIC T_col FUNC_AND_DEC
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

LOOPS : SWITCH T_lround LIT T_rround flower_paran_o {switch_lit=$3.string;}SWITCHBODY flower_paran_c
      | IF_HEAD LOOPBODY {fprintf(file,"L%d :\n",arr[cur-1]);fprintf(file2,"|%-10s|%-10s|%-10s|L%-10d|\n","Label","","",arr[cur-1]);cur-=1;}
      | IF_HEAD LOOPBODY ELSE {char k1[50];sprintf(k1,"%d",assign);assign+=1;char res1[100]="";strcat(res1,"L");strcat(res1,k1); fprintf(file,"goto %s\n",res1);fprintf(file2,"|%-10s|%-10s|%-10s|%-10s|\n","goto","","",res1);arr[cur]=arr[cur-1]; arr[cur-1]=assign-1;cur+=1;fprintf(file,"L%d :\n",arr[cur-1]);fprintf(file2,"|%-10s|%-10s|%-10s|L%-10d|\n","Label","","",arr[cur-1]);fprintf(file2,"|%-10s|%-10s|%-10s|L%-10d|\n","Label","","",arr[cur-1]);cur-=1;} LOOPBODY {fprintf(file,"L%d :\n",arr[cur-1]);fprintf(file2,"|%-10s|%-10s|%-10s|L%-10d|\n","Label","","",arr[cur-1]);cur-=1;}
      ;

IF_HEAD
      :IF T_lround COND T_rround {char k[50];sprintf(k,"%d",assign);assign+=1;char res[100]="";strcat(res,"L");strcat(res,k); fprintf(file,"if %s goto %s\n",$3.string,res);char k1[50];fprintf(file2,"|%-10s|%-10s|%-10s|%-10s|\n","if",$3.string,"goto",res);sprintf(k1,"%d",assign);assign+=1;char res1[100]="";strcat(res1,"L");strcat(res1,k1); fprintf(file,"goto %s\n",res1);fprintf(file2,"|%-10s|%-10s|%-10s|%-10s|\n","goto","","",res1);arr[cur]=assign-1;cur+=1;arr[cur]=assign-2;cur+=1; fprintf(file,"L%d :\n",arr[cur-1]);fprintf(file2,"|%-10s|%-10s|%-10s|L%-10d|\n","Label","","",arr[cur-1]);cur-=1;};

SWITCHBODY
      : SWITCHBODY CASE LIT T_col {char k0[50]; sprintf(k0,"%d",temp);char res0[100]="";strcat(res0,"t");strcat(res0,k0);temp+=1;fprintf(file,"%s = %s == %s \n",res0,switch_lit,$3.string);fprintf(file2,"|%-10s|%-10s|%-10s|%-10s|\n","==",switch_lit,$3.string,res0);char k[50];sprintf(k,"%d",assign);assign+=1;char res[100]="";strcat(res,"L");strcat(res,k); fprintf(file,"if %s goto %s\n",res0,res);fprintf(file2,"|%-10s|%-10s|%-10s|%-10s|\n","if",res0,"goto",res);char k1[50];sprintf(k1,"%d",assign);assign+=1;char res1[100]="";strcat(res1,"L");strcat(res1,k1); fprintf(file,"goto %s\n",res1);fprintf(file2,"|%-10s|%-10s|%-10s|%-10s|\n","goto","","",res1);arr[cur]=assign-1;cur+=1;arr[cur]=assign-2;cur+=1; fprintf(file,"L%d :\n",arr[cur-1]);fprintf(file2,"|%-10s|%-10s|%-10s|L%-10d|\n","Label","","",arr[cur-1]);cur-=1;fprintf(file,"L%d :\n",arr[cur-1]);fprintf(file2,"|%-10s|%-10s|%-10s|L%-10d|\n","Label","","",arr[cur-1]);cur-=1;}
      | CASE LIT T_col{char k0[50]; sprintf(k0,"%d",temp);char res0[100]="";strcat(res0,"t");strcat(res0,k0);temp+=1;fprintf(file,"%s = %s == %s \n",res0,switch_lit,$2.string);fprintf(file2,"|%-10s|%-10s|%-10s|%-10s|\n","==",switch_lit,$2.string,res0);char k[50];sprintf(k,"%d",assign);assign+=1;char res[100]="";strcat(res,"L");strcat(res,k); fprintf(file,"if %s goto %s\n",res0,res);char k1[50];sprintf(k1,"%d",assign);assign+=1;char res1[100]="";strcat(res1,"L");strcat(res1,k1); fprintf(file,"goto %s\n",res1);arr[cur]=assign-1;cur+=1;arr[cur]=assign-2;cur+=1; fprintf(file,"L%d :\n",arr[cur-1]);cur-=1;fprintf(file,"L%d :\n",arr[cur-1]);fprintf(file2,"|%-10s|%-10s|%-10s|L%-10d|\n","Label","","",arr[cur-1]);cur-=1;}
      | SWITCHBODY CASE LIT T_col BREAK {char k0[50]; sprintf(k0,"%d",temp);char res0[100]="";strcat(res0,"t");strcat(res0,k0);temp+=1;fprintf(file,"%s = %s == %s \n",res0,switch_lit,$3.string);fprintf(file2,"|%-10s|%-10s|%-10s|%-10s|\n","==",switch_lit,$3.string,res0);char k[50];sprintf(k,"%d",assign);assign+=1;char res[100]="";strcat(res,"L");strcat(res,k); fprintf(file,"if %s goto %s\n",res0,res);char k1[50];sprintf(k1,"%d",assign);assign+=1;char res1[100]="";strcat(res1,"L");strcat(res1,k1); fprintf(file,"goto %s\n",res1);arr[cur]=assign-1;cur+=1;arr[cur]=assign-2;cur+=1; fprintf(file,"L%d :\n",arr[cur-1]);fprintf(file2,"|%-10s|%-10s|%-10s|L%-10d|\n","Label","","",arr[cur-1]);cur-=1;fprintf(file,"call ( break , 0 ) \n");fprintf(file,"L%d :\n",arr[cur-1]);fprintf(file2,"|%-10s|%-10s|%-10s|L%-10d|\n","Label","","",arr[cur-1]);cur-=1;}T_semi
      | SWITCHLOOP1 BREAK {fprintf(file,"call ( break , 0 ) \n");fprintf(file,"L%d :\n",arr[cur-1]);fprintf(file2,"|%-10s|%-10s|%-10s|L%-10d|\n","Label","","",arr[cur-1]);cur-=1;} T_semi
      | SWITCHLOOP1 {fprintf(file,"L%d :\n",arr[cur-1]);fprintf(file2,"|%-10s|%-10s|%-10s|L%-10d|\n","Label","","",arr[cur-1]);cur-=1;}
      | SWITCHLOOP2 BREAK {fprintf(file,"call ( break , 0 ) \n");fprintf(file,"L%d :\n",arr[cur-1]);fprintf(file2,"|%-10s|%-10s|%-10s|L%-10d|\n","Label","","",arr[cur-1]);cur-=1;}  T_semi
      | SWITCHLOOP2 {fprintf(file,"L%d :\n",arr[cur-1]);fprintf(file2,"|%-10s|%-10s|%-10s|L%-10d|\n","Label","","",arr[cur-1]);cur-=1;}
      | SWITCHLOOP3 BREAK  {fprintf(file,"call ( break , 0 ) \n");fprintf(file,"L%d :\n",arr[cur-1]);fprintf(file2,"|%-10s|%-10s|%-10s|L%-10d|\n","Label","","",arr[cur-1]);cur-=1;}T_semi
      | SWITCHLOOP3 {fprintf(file,"L%d :\n",arr[cur-1]);fprintf(file2,"|%-10s|%-10s|%-10s|L%-10d|\n","Label","","",arr[cur-1]);cur-=1;}
      | SWITCHLOOP4 BREAK  {fprintf(file,"call ( break , 0 ) \n");fprintf(file,"L%d :\n",arr[cur-1]);fprintf(file2,"|%-10s|%-10s|%-10s|L%-10d|\n","Label","","",arr[cur-1]);cur-=1;} T_semi
      | SWITCHLOOP4 {fprintf(file,"L%d :\n",arr[cur-1]);fprintf(file2,"|%-10s|%-10s|%-10s|L%-10d|\n","Label","","",arr[cur-1]);cur-=1;}
      ;
SWITCHLOOP1
      :SWITCHBODY  CASE LIT T_col {char k0[50]; sprintf(k0,"%d",temp);char res0[100]="";strcat(res0,"t");strcat(res0,k0);temp+=1;fprintf(file,"%s = %s == %s \n",res0,switch_lit,$3.string);fprintf(file2,"|%-10s|%-10s|%-10s|%-10s|\n","==",switch_lit,$3.string,res0);char k[50];sprintf(k,"%d",assign);assign+=1;char res[100]="";strcat(res,"L");strcat(res,k); fprintf(file,"if %s goto %s\n",res0,res);char k1[50];sprintf(k1,"%d",assign);assign+=1;char res1[100]="";strcat(res1,"L");strcat(res1,k1); fprintf(file,"goto %s\n",res1);arr[cur]=assign-1;cur+=1;arr[cur]=assign-2;cur+=1;fprintf(file,"L%d :\n",arr[cur-1]);cur-=1;} LOOPBODY ;

SWITCHLOOP2
      : CASE LIT T_col {char k0[50]; sprintf(k0,"%d",temp);char res0[100]="";strcat(res0,"t");strcat(res0,k0);temp+=1;fprintf(file,"%s = %s == %s \n",res0,switch_lit,$2.string);fprintf(file2,"|%-10s|%-10s|%-10s|%-10s|\n","==",switch_lit,$2.string,res0);char k[50];sprintf(k,"%d",assign);assign+=1;char res[100]="";strcat(res,"L");strcat(res,k); fprintf(file,"if %s goto %s\n",res0,res);char k1[50];sprintf(k1,"%d",assign);assign+=1;char res1[100]="";strcat(res1,"L");strcat(res1,k1); fprintf(file,"goto %s\n",res1);arr[cur]=assign-1;cur+=1;arr[cur]=assign-2;cur+=1;fprintf(file,"L%d :\n",arr[cur-1]);cur-=1;} LOOPBODY;

SWITCHLOOP3
       :DEFAULT T_col {char k[50];sprintf(k,"%d",assign);assign+=1;char res[100]="";strcat(res,"L");strcat(res,k); fprintf(file,"if %s goto %s\n","1",res);char k1[50];sprintf(k1,"%d",assign);assign+=1;char res1[100]="";strcat(res1,"L");strcat(res1,k1); fprintf(file,"goto %s\n",res1);arr[cur]=assign-1;cur+=1;arr[cur]=assign-2;cur+=1;fprintf(file,"L%d :\n",arr[cur-1]);fprintf(file2,"|%-10s|%-10s|%-10s|L%-10d|\n","Label","","",arr[cur-1]);cur-=1;} LOOPBODY ;

SWITCHLOOP4
       :DEFAULT T_col {char k[50];sprintf(k,"%d",assign);assign+=1;char res[100]="";strcat(res,"L");strcat(res,k); fprintf(file,"if %s goto %s\n","1",res);char k1[50];sprintf(k1,"%d",assign);assign+=1;char res1[100]="";strcat(res1,"L");strcat(res1,k1); fprintf(file,"goto %s\n",res1);arr[cur]=assign-1;cur+=1;arr[cur]=assign-2;cur+=1;fprintf(file,"L%d :\n",arr[cur-1]);fprintf(file2,"|%-10s|%-10s|%-10s|L%-10d|\n","Label","","",arr[cur-1]);cur-=1;}  ;


LOOPBODY  : flower_paran_o C flower_paran_c
					| flower_paran_o C BREAK T_semi flower_paran_c
					| T_semi
					| statement T_semi
					| flower_paran_o flower_paran_c
					| error
					;

statement : DECLARATION
		      | ASSIGN_EXPR
		      | EXPR
		      | TERNARY_EXPR
		      | PTR_EXPR
		      | ARR_EXPR
		      | OBJ_EXPR
		      | PRINT
		      | RETURN {fprintf(file,"call ( return , 0 ) \n");}
		      | RETURN T_lround EXPR T_rround { fprintf(file,"PARAM %s \n",$3.string);fprintf(file,"call ( return , 1 ) \n");}
		      | RETURN EXPR {fprintf(file,"PARAM %s \n",$2.string);fprintf(file,"call ( return , 1 ) \n");}
		      | error
		      ;

COND  : LIT RELOP LIT {char k[50]; sprintf(k,"%d",temp);char res[100]="";strcat(res,"t");strcat(res,k);temp+=1;fprintf(file,"%s = %s %s %s \n",res,$1.string,$2.string,$3.string);fprintf(file2,"|%-10s|%-10s|%-10s|%-10s|\n",$2.string,$1.string,$3.string,res);$$.string=res;}
      | LIT {$$.string=$1.string;}
      | LIT RELOP LIT bin_boolop LIT RELOP LIT {char k[50]; sprintf(k,"%d",temp);char res[100]="";strcat(res,"t");strcat(res,k);temp+=1;fprintf(file,"%s = %s %s %s \n",res,$1.string,$2.string,$3.string);fprintf(file2,"|%-10s|%-10s|%-10s|%-10s|\n",$2.string,$1.string,$3.string,res);char k1[50]; sprintf(k1,"%d",temp);char res1[100]="";strcat(res1,"t");strcat(res1,k1);temp+=1;fprintf(file,"%s = %s %s %s \n",res1,$5.string,$6.string,$7.string);fprintf(file2,"|%-10s|%-10s|%-10s|%-10s|\n",$6.string,$5.string,$7.string,res1);char k2[50]; sprintf(k2,"%d",temp);char res2[100]="";strcat(res2,"t");strcat(res2,k2);temp+=1; fprintf(file,"%s = %s %s %s\n",res2,res,$4.string,res1);$$.string=res2;}
      | un_boolop T_lround LIT RELOP LIT T_rround {char k[50]; sprintf(k,"%d",temp);char res[100]="";strcat(res,"t");strcat(res,k);temp+=1;fprintf(file,"%s = %s %s %s \n",res,$3.string,$4.string,$5.string);fprintf(file2,"|%-10s|%-10s|%-10s|%-10s|\n",$4.string,$3.string,$5.string,res);char k1[50]; sprintf(k1,"%d",temp);char res1[100]="";strcat(res1,"t");strcat(res1,k1);temp+=1;fprintf(file,"%s = %s %s\n",res1,$1.string,res);$$.string=res1;}
      | un_boolop LIT RELOP LIT {char k[50]; sprintf(k,"%d",temp);char res[100]="";strcat(res,"t");strcat(res,k);temp+=1;fprintf(file,"%s = %s %s %s \n",res,$2.string,$3.string,$4.string);fprintf(file2,"|%-10s|%-10s|%-10s|%-10s|\n",$2.string,$1.string,$3.string,res);char k1[50]; sprintf(k1,"%d",temp);char res1[100]="";strcat(res1,"t");strcat(res1,k1);temp+=1;fprintf(file,"%s = %s %s\n",res1,$1.string,res);$$.string=res1;}
      | LIT bin_boolop LIT {char k[50]; sprintf(k,"%d",temp);char res[100]="";strcat(res,"t");strcat(res,k);temp+=1;fprintf(file,"%s = %s %s %s \n",res,$1.string,$2.string,$3.string);fprintf(file2,"|%-10s|%-10s|%-10s|%-10s|\n",$2.string,$1.string,$3.string,res);$$.string=res;}
      | un_boolop T_lround LIT T_rround  {char k[50]; sprintf(k,"%d",temp);char res[100]="";strcat(res,"t");strcat(res,k);temp+=1;fprintf(file,"%s = %s %s \n",res,$1.string,$3.string);fprintf(file2,"|%-10s|%-10s|%-10s|%-10s|\n","",$1.string,$3.string,res);$$.string=res;}
      | un_boolop LIT {char k[50]; sprintf(k,"%d",temp);char res[100]="";strcat(res,"t");strcat(res,k);temp+=1;fprintf(file,"%s = %s %s \n",res,$1.string,$2.string);fprintf(file2,"|%-10s|%-10s|%-10s|%-10s|\n","",$1.string,$2.string,res);$$.string=res;}
      | error
      ;

ASSIGN_EXPR
      : ID T_eq EXPR
			{
					type0=check_define($1.string,index_);
					if(type0!=0)
					{
							type0=cur_type;
					}
					if (type0==$3.number)
					{
							fprintf(file,"%s = %s\n",$1.string,$3.string);
							fprintf(file2,"|%-10s|%-10s|%-10s|%-10s|\n","=",$1.string,"",$3.string);
					}
			}
      | TYPE ID T_eq EXPR
			{

					type0=return_index($1.string);
					//printf("\n\nTYPES: %d %d\n\n", type0, $4.number);
					if ((type0==$4.number || type0==2) && $4.number == -1)
					{
							insert(dtype,$2.string,@$.first_line,index_,$4.string);
							fprintf(file,"%s = %s\n",$2.string,$4.string);
							fprintf(file2,"|%-10s|%-10s|%-10s|%-10s|\n","=",$2.string,"",$4.string);
					}
					else if($4.number == 999){}
					else if(type0 > -1 && $4.number != -1)
					{
							insert(dtype,$2.string,@$.first_line,index_,$4.string);
							fprintf(file,"%s = %s\n",$2.string,$4.string);
							fprintf(file2,"|%-10s|%-10s|%-10s|%-10s|\n","=",$2.string,"",$4.string);
					}
					else
					{
							printf("Error: The given expression cannot be casted to %s\n\n", $1.string);
					}

			}
      | CHAR_PTR ID T_eq STRING_LIT
			{
					insert($1.string,$2.string,@$.first_line,index_,$4.string);
					fprintf(file,"%s = %s\n",$2.string,$4.string);
					fprintf(file2,"|%-10s|%-10s|%-10s|%-10s|\n","=",$2.string,"",$4.string);
			}
      ;

DECLARATION
      : TYPE ID  {insert($1.string,$2.string,@$.first_line,index_,"NOT_DEFINED");}
      | DECLARATION T_comma ID {insert(dtype,$3.string,@$.first_line,index_,"NOT_DEFINED");}
      | CHAR_PTR ID {insert($1.string,$2.string,@$.first_line,index_,"NOT_DEFINED");}
      ;

TERNARY_EXPR
      : T_lround COND T_rround '?' {char k[50];sprintf(k,"%d",assign);assign+=1;char res[100]="";strcat(res,"L");strcat(res,k); fprintf(file,"if %s goto %s\n",$2.string,res);char k1[50];sprintf(k1,"%d",assign);assign+=1;char res1[100]="";strcat(res1,"L");strcat(res1,k1); fprintf(file,"goto %s\n",res1);arr[cur]=assign-1;cur+=1;arr[cur]=assign-2;cur+=1;} {fprintf(file,"L%d :\n",arr[cur-1]);fprintf(file2,"|%-10s|%-10s|%-10s|L%-10d|\n","Label","","",arr[cur-1]);cur-=1;} statement T_col  {fprintf(file,"L%d :\n",arr[cur-1]);fprintf(file2,"|%-10s|%-10s|%-10s|L%-10d|\n","Label","","",arr[cur-1]);cur-=1;} statement
      ;

REP_PRINT:
        T_lt T_lt LIT {fprintf(file,"PARAM %s\n",$3.string);fprintf(file2,"|%-10s|%-10s|%-10s|%-10s|\n","PARAM",$3.string,"",""); $$.number=1;}
      | REP_PRINT  T_lt T_lt LIT  {fprintf(file,"PARAM %s\n",$4.string);fprintf(file2,"|%-10s|%-10s|%-10s|%-10s|\n","PARAM",$4.string,"","");$$.number=$1.number+1;}
      | T_lt T_lt ENDL  {fprintf(file,"PARAM %s\n",$3.string);fprintf(file2,"|%-10s|%-10s|%-10s|%-10s|\n","PARAM",$3.string,"",""); $$.number=1;}
      |  REP_PRINT T_lt T_lt ENDL  {fprintf(file,"PARAM %s\n",$4.string);fprintf(file2,"|%-10s|%-10s|%-10s|%-10s|\n","PARAM",$4.string,"","");$$.number=$1.number+1;}
			;

PRINT
      : COUT  REP_PRINT {fprintf(file,"call ( cout , %d ) \n",$2.number);fprintf(file2,"|%-10s|%-10s|%-10d|%-10s|\n","call","cout",$2.number,"");}
      ;
LIT
      : ID {$$.string=$1.string;defined=check_define($1.string,index_); if(defined){$$.number=cur_type;$$.is_id=1;strcpy($$.value,cur_value);} }
      | STRING_LIT {$$.string=$1.string;if(defined){ $$.number=-1;$$.is_id=0;strcpy($$.value,"");}}
      | CHAR_CONST {$$.string=$1.string;if(defined){ $$.number=1;$$.is_id=0;strcpy($$.value,"");}}
      | T_DIGIT {strcpy($$.string,$1.string);if(defined){ $$.number=3;$$.is_id=0;strcpy($$.value,"");}}
      | T_REAL  {$$.string=$1.string;if(defined){$$.number=4;$$.is_id=0;strcpy($$.value,"");}}
      | T_TRUE   {$$.string=$1.string;if(defined){ $$.number=2;$$.is_id=0;strcpy($$.value,"");}}
      | T_FALSE  {$$.string=$1.string;if(defined){ $$.number=2;$$.is_id=0;strcpy($$.value,"");}}
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

PTR_EXPR: PTR_TYPE ID {insert($1.string,$2.string,@$.first_line,index_,"NOT_DEFINED");}
      | PTR_TYPE ID T_eq T_amp ID {insert($1.string,$2.string,@$.first_line,index_,"NOT_DEFINED");fprintf(file,"%s = addr(%s)\n",$2.string,$5.string);fprintf(file2,"|%-10s|addr %-10s|%-10s|%-10s|\n","=",$5.string,"",$2.string);}
      | CHAR_PTR ID T_eq T_amp ID {insert($1.string,$2.string,@$.first_line,index_,"NOT_DEFINED");fprintf(file,"%s = addr(%s)\n",$2.string,$5.string);fprintf(file2,"|%-10s|addr %-10s|%-10s|%-10s|\n","=",$5.string,"",$2.string);}
      | ID T_eq T_amp ID {fprintf(file,"%s = addr(%s)\n",$1.string,$4.string);fprintf(file2,"|%-10s|addr %-10s|%-10s|%-10s|\n","=",$4.string,"",$1.string);}
      ;

ARR_EXPR: TYPE ID T_lsq T_DIGIT T_rsq {type0=return_index($1.string);type0*=-1;insert(strcat($1.string,"_arr"),$2.string,@$.first_line,index_,"NOT_DEFINED");}
      | TYPE ID T_lsq T_DIGIT T_rsq T_eq{type0=return_index($1.string);type0*=-1;decider=2;zero=$2.string;cur_size=find_space($1.string);no_elem=0;} T_lflower ARRAY T_rflower {insert(strcat($1.string,"_arr"),$2.string,@$.first_line,index_,"NOT_DEFINED");if (cur_size && type0!=0){if(no_elem==1){fprintf(file,"%s[%d] = %s \n",$2.string,cur_size*atoi($4.string),$9.string);fprintf(file2,"|%-10s[]|%-10s|%-10d|%-10s|\n","=",$9.string,cur_size*atoi($4.string),$2.string);} else{ fprintf(file,"%s[%d] = %s \n",$2.string,(no_elem-1)*cur_size,$9.string);fprintf(file2,"|%-10s[]|%-10s|%-10d|%-10s|\n","=",$9.string,(no_elem-1)*cur_size,$2.string); }}cur_size=0;no_elem=0;}
      | TYPE ID T_sq T_eq {type0=return_index($1.string);type0*=-1;decider=2;zero=$2.string;cur_size=find_space($1.string);no_elem=0;}T_lflower ARRAY T_rflower {insert(strcat($1.string,"_arr"),$2.string,@$.first_line,index_,"NOT_DEFINED");if (cur_size && type0!=0){fprintf(file,"%s[%d] = %s \n",$2.string,(no_elem-1)*cur_size,$7.string);fprintf(file2,"|%-10s[]|%-10s|%-10d|%-10s|\n","=",$7.string,(no_elem-1)*cur_size,$2.string); }cur_size=0; no_elem=0;}
      | ID T_lsq T_DIGIT T_rsq T_eq{type0=check_define($1.string,index_);if(type0!=0){type0=cur_type;}if(type0){decider=2;cur_size=find_type($1.string,index_);zero=$1.string;no_elem=0;}} ARRAY {if(type0){if (cur_size && type0!=0){if(no_elem==1){fprintf(file,"%s[%d] = %s \n",$1.string,cur_size*atoi($3.string),$7.string);} else{fprintf(file,"%s[%d] = %s \n",$1.string,(no_elem-1)*cur_size,$7.string);fprintf(file2,"|%-10s[]|%-10s|%-10d|%-10s|\n","=",$7.string,(no_elem-1)*cur_size,$2.string); }}}cur_size=0;no_elem=0;}
      ;

OBJ_EXPR : ID ID  {insert(strcat($1.string,"_obj"),$2.string,@$.first_line,index_,"AN_OBJECT");}
      | ID T_dot ID T_eq LIT {fprintf(file,"%s.%s = %s \n",$1.string,$3.string,$5.string);fprintf(file2,"|%-10s|%-10s|%-10s|%-10s|\n","=",$5.string,"",$3.string);}
      | ID T_dot ID T_lround T_rround {fprintf(file,"call ( %s.%s , 0 ) \n",$1.string,$2.string);fprintf(file2,"|%-10s|%-10s|%-10d|%-10s|\n","call",$2.string,0,"");}
      | ID T_dot ID T_lround ARRAY T_rround {fprintf(file,"call ( %s.%s , %d ) \n",$1.string,$3.string,no_elem);fprintf(file2,"|%-10s|%-10s|%-10d|%-10s|\n","call",$3.string,no_elem,""); no_elem=0;}
      ;

ARRAY
      : LIT { no_elem+=1; if  (decider==2 ){if(type0!=0 && type0*-1==$1.number){ $$.string=$1.string;$$.number=$1.number;$$.is_id=$1.is_id;strcpy($$.value,$1.value);} else{ type0=0;}}else{fprintf(file,"PARAM %s\n",$1.string);fprintf(file2,"|%-10s|%-10s|%-10s|%-10s|\n","PARAM",$1.string,"",""); }}
      | ARRAY T_comma  {  if (decider==2&& type0!=0){ fprintf(file,"%s[%d] = %s\n",zero,(no_elem-1)*cur_size,$1.string);fprintf(file2,"|%-10s[]|%-10s|%-10d|%-10s|\n","=",$1.string,(no_elem-1)*cur_size,"0");no_elem+=1; } else{ no_elem+=1;}}  LIT {if(decider==2){if(type0*-1==$4.number  && type0!=0){$$.string=$4.string;} else{type0=0;}}else{fprintf(file,"PARAM %s\n",$4.string);fprintf(file2,"|%-10s|%-10s|%-10s|%-10s|\n","PARAM",$4.string,"","");} $$.number=$4.number;}
      ;

EXPR
	: EXPR bin_boolop EXP
	{
						if($1.number <= -1 || $3.number <= -1 || $1.number == 999 || $3.number == 999)
						{
								if($1.number <= -1)
										printf("Error: Invalid operand: %s used for %s\n\n", $1.string, $2.string);
								if($3.number <= -1)
										printf("Error: Invalid operand: %s used for %s\n\n", $3.string, $2.string);
								$$.number = 999;
								$$.is_id=1;
								strcpy($$.value,"");
								strcpy($$.string,"");
						}

						else
						{
								char k[50];
								sprintf(k,"%d",temp);
								char res[100]="";
								strcat(res,"t");
								strcat(res,k);
								temp+=1;
								fprintf(file,"%s = %s %s %s \n",res,$1.string,$2.string,$3.string);
								fprintf(file2,"|%-10s|%-10s|%-10s|%-10s|\n",$2.string,$1.string,$3.string,res);
								$$.number=MAX($1.number,$3.number);
								char *type=return_type($$.number);
								char val[50]="";
								insert(type,res,yylineno,index_,val);
								$$.is_id=1;
								strcpy($$.value,"");
								strcpy($$.string,res);
						}
	}
	| EXP
	{
			$$.string=$1.string;
			$$.number=$1.number;
			$$.is_id=$1.is_id;
			strcpy($$.value,$1.value);
	}
	;

EXP
        :EXP RELOP T
				{
								if($1.number <= -1 || $3.number <= -1 || $1.number == 999 || $3.number == 999)
								{

										if($1.number <= -1)
												printf("Error: Invalid operand: %s used for %s\n\n", $1.string, $2.string);
										if($3.number <= -1)
												printf("Error: Invalid operand: %s used for %s\n\n", $3.string, $2.string);
										$$.number = 999;
										$$.is_id=1;
										strcpy($$.value,"");
										strcpy($$.string,"");

								}
								else
								{
										char k[50];
										sprintf(k,"%d",temp);
										char res[100]="";
										strcat(res,"t");
										strcat(res,k);
										temp+=1;
										fprintf(file,"%s = %s %s %s \n",res,$1.string,$2.string,$3.string);
										fprintf(file2,"|%-10s|%-10s|%-10s|%-10s|\n",$2.string,$1.string,$3.string,res);
										$$.number = MAX($1.number,$3.number);
										char *type=return_type($$.number);
										char val[50]="";
										insert(type,res,yylineno,index_,val);
										$$.is_id=1;
										strcpy($$.value,"");
										strcpy($$.string,res);
								}
				}
        |T
				{
						$$.string=$1.string;
						$$.number=$1.number;
						$$.is_id=$1.is_id;
						strcpy($$.value,$1.value);
				}
				;

T
	: T T_pl F
	{
				if($1.number <= -1 || $3.number <= -1 || $1.number == 999 || $3.number == 999)
				{
						if($1.number <= -1)
								printf("Error: Invalid operand: %s used for addition\n\n", $1.string);
						if($3.number <= -1)
								printf("Error: Invalid operand: %s used for addition\n\n", $3.string);
						$$.number = 999;
						$$.is_id=1;
						strcpy($$.value,"");
						strcpy($$.string,"");
				}
				else
				{
						char k[50];
						sprintf(k,"%d",temp);
						char res[100]="";
						strcat(res,"t");
						strcat(res,k);
						temp += 1;
						fprintf(file,"%s = %s %s %s \n",res,$1.string,$2.string,$3.string);
						fprintf(file2,"|%-10s|%-10s|%-10s|%-10s|\n",$2.string,$1.string,$3.string,res);
						$$.number = MAX($1.number,$3.number);
						char *type=return_type($$.number);
						char val[50]="";
						insert(type,res,yylineno,index_,val);
						$$.is_id=1;
						strcpy($$.value,"");
						strcpy($$.string,res);
				}


	}
	| T T_min F
	{
						if($1.number <= -1 || $3.number <= -1 || $1.number == 999 || $3.number == 999)
						{
								if($1.number <= -1)
										printf("Error: Invalid operand: %s used for subtraction\n\n", $1.string);
								if($3.number <= -1)
										printf("Error: Invalid operand: %s used for subtraction\n\n", $3.string);
								$$.number = 999;
								$$.is_id=1;
								strcpy($$.value,"");
								strcpy($$.string,"");

						}
						else
						{
								char k[50];
								sprintf(k,"%d",temp);
								char res[100]="";
								strcat(res,"t");
								strcat(res,k);
								temp+=1;
								fprintf(file,"%s = %s %s %s \n",res,$1.string,$2.string,$3.string);
								fprintf(file2,"|%-10s|%-10s|%-10s|%-10s|\n",$2.string,$1.string,$3.string,res);
								$$.number = MAX($1.number,$3.number);
								char *type=return_type($$.number);
								char val[50]="";
								insert(type,res,yylineno,index_,val);
								$$.is_id=1;
								strcpy($$.value,"");
								strcpy($$.string,res);
						}
	}
	| F
	{
			strcpy($$.string,$1.string);
			$$.number=$1.number;
			$$.is_id=$1.is_id;
			strcpy($$.value,$1.value);
	}
	;

F
	: F T_mul G
	{


						if($1.number <= -1 || $3.number <= -1 || $1.number == 999 || $3.number == 999)
						{

								if($1.number <= -1)
										printf("Error: Invalid operand: %s used for multiplication\n\n", $1.string);
								if($3.number <= -1)
										printf("Error: Invalid operand: %s used for multiplication\n\n", $3.string);
								$$.number = 999;
								$$.is_id=1;
								strcpy($$.value,"");
								strcpy($$.string,"");

						}

						else
						{
								char k[50];
								sprintf(k,"%d",temp);
								char res[100]="";
								strcat(res,"t");
								strcat(res,k);
								temp+=1;
								fprintf(file,"%s = %s %s %s \n",res,$1.string,$2.string,$3.string);
								fprintf(file2,"|%-10s|%-10s|%-10s|%-10s|\n",$2.string,$1.string,$3.string,res);
								$$.number = MAX($1.number,$3.number);
								char *type=return_type($$.number);
								char val[50]="";
								insert(type,res,yylineno,index_,val);
								$$.is_id=1;
								strcpy($$.value,"");
								strcpy($$.string,res);
						}
	}
	| F T_div G
	{
					if($1.number <= -1 || $3.number <= -1 || $1.number == 999 || $3.number == 999)
					{

							if($1.number <= -1)
									printf("Error: Invalid operand: %s used for division\n\n", $1.string);
							if($3.number <= -1)
									printf("Error: Invalid operand: %s used for division\n\n", $3.string);
							$$.number = 999;
							$$.is_id=1;
							strcpy($$.value,"");
							strcpy($$.string,"");
					}

					else
					{
							char k[50];
							sprintf(k,"%d",temp);
							char res[100]="";
							strcat(res,"t");
							strcat(res,k);
							temp+=1;
							fprintf(file,"%s = %s %s %s \n",res,$1.string,$2.string,$3.string);
							fprintf(file2,"|%-10s|%-10s|%-10s|%-10s|\n",$2.string,$1.string,$3.string,res);
							$$.number = MAX($1.number,$3.number);
							char *type=return_type($$.number);
							char val[50]="";
							insert(type,res,yylineno,index_,val);
							$$.is_id=1;
							strcpy($$.value,"");
							strcpy($$.string,res);
					}
	}
	| G
	{
			strcpy($$.string,$1.string);
			$$.number=$1.number;
			$$.is_id=$1.is_id;
			strcpy($$.value,$1.value);
	}
	;

G
    : LIT
		{
					strcpy($$.string,$1.string);
					$$.number=$1.number;
					$$.is_id=$1.is_id;
					strcpy($$.value,$1.value);
		}
	;

RELOP
      : T_lt  {$$.string=$1.string;$$.number=1;}
      | T_gt  {$$.string=$1.string;$$.number=2;}
      | T_lteq {$$.string=$1.string;$$.number=3;}
      | T_gteq {$$.string=$1.string;$$.number=4;}
      | T_neq  {$$.string=$1.string;$$.number=5;}
      | T_eqeq  {$$.string=$1.string;$$.number=6;}
      ;

bin_boolop
      : T_and {$$.string=$1.string;}
      | T_or {$$.string=$1.string;}
      ;

un_boolop
      : T_not {$$.string=$1.string;}
      ;

  ;

%%

#include "lex.yy.c"
void yyerror()
{
      printf("Error at line %d\n",yylineno);
}

int yywrap ()
 {
 return 1;
 }


char*  return_type(int index)
{
		if(index==-1) return "string";
		else if (index==1) return "char";
		else if(index==2)return "bool";
		else if (index==3)return "int";
		else if (index==4)return "float";
		else if (index==5)return "double";
		else if(index==-3)return "int*";
		else if(index==-4)return "float*";
		else return "double*";
}

int return_index(char *type)
{
		if (!strcmp(type,"string"))return -1;
		else if (!strcmp(type,"char"))return 1;
		else if(!strcmp(type,"bool"))return 2;
		else if(!strcmp(type,"int"))return 3;
		else if(!strcmp(type,"float"))return 4;
		else if(!strcmp(type,"double"))return 5;
		else if(!strcmp(type,"char*") || !strcmp(type,"char_arr"))return -1; //WHAT IS GOING ON
		else if(!strcmp(type,"int*") || !strcmp(type,"int_arr"))return -3;
		else if(!strcmp(type,"float*") || !strcmp(type,"float_arr"))return -4;
		else return -5;
}

int find_space(char *type)
{
		if (strlen(type)==0)return 0;
		else if(!strcmp(type,"int") || !strcmp(type,"int_arr"))return 4;
		else if(!strcmp(type,"float") || !strcmp(type,"float_arr"))return 4;
		else if(!strcmp(type,"char") || !strcmp(type,"char_arr"))return 1;
		else if(!strcmp(type,"bool"))return 1;
		else return 4;
}

int find_type(char *name,int index0)
{
		FINAL *head=list->head;
		int len=0;
		while(head)
		{
				int flag=1;
				for(int i=0;i<=index0;i++)
				{
						if(head->scope_arr[i]!=current_scope[i])
						{
								flag=0;
								break;
						}
				}
				if(flag)
				{
						for(int i=0;i<head->count;i++)
						{
								if(strcmp(name,head->data_arr[i].name)==0)
										return find_space(head->data_arr[i].type);
						}
						printf("Error: Variable %s used before declaring\n",name);
						return 0;
				}
				head=head->next;
		}
		printf("Error: Variable %s used before declaring\n",name);
		return 0;
}

FINAL* create_final(NODE node,int index0)
{
		FINAL *final=(FINAL*)malloc(sizeof(FINAL));
		for(int i=0;i<=index0;i++)
		{
				final->scope_arr[i]=current_scope[i];
		}
		final->len=index0;
		final->count=1;
		final->data_arr[0]=node;
		return final;
}

void node_insert(NODE node,FINAL * final)
{
		final->count+=1;
		final->data_arr[final->count-1]=node;
		return;
}

int check_match(int index0,FINAL* final)
{
		if(index0!=final->len)
			return 0;
		for(int i=0;i<=index0;i++)
		{
			if(final->scope_arr[i]!=current_scope[i])
			   return 0;
		}
		return 1;
}

FINAL* return_final(int index0)
{
		FINAL *head=list->head;
		while(head)
		{
				if(check_match(index0,head))
						return head;
				head=head->next;
		}
		return NULL;
}

int check_define(char *name,int index0)
{
		FINAL *head=list->head;
		while(head)
		{
				int flag=1;
				for(int i=0;i<=index0;i++)
				{
						if(head->scope_arr[i]!=current_scope[i])
						{
								flag=0;
								break;
						}
				}
				if(flag)
				{
						for(int i=0;i<head->count;i++)
						{
								if(strcmp(name,head->data_arr[i].name)==0)
								{
										cur_type=return_index(head->data_arr[i].type);
										strcpy(cur_value,head->data_arr[i].value);
										return 1;
								}
						}
						printf("Error: Variable %s used before declaring\n",name);
						return 0;
				}
				head = head->next;
		}
		printf("Error: Variable %s used before declaring\n",name);
		return 0;
}


int check_redifine(char *name,int index0)
{
		FINAL *head = list->head;
		while(head)
		{
				if (check_match(index0,head))
				{
						for(int i=0;i<head->count;i++)
						{
								if(strcmp(name,head->data_arr[i].name)==0)
								{
										printf("Error: Variable %s Redeclared\n",name);
										return 0;
								}
						}
				}
				head=head->next;
		}
		return 1;
}

void insert(char *data_type,char *name, int lineno,int index0,char* value)
{
		if(check_redifine(name,index0))
		{
				NODE node;
				node.name=(char *)malloc(sizeof(char)*100);
				strcpy(node.name,name);
				node.lineno=lineno;
				node.type=data_type;
				strcpy(node.value,value);
				if(list->head==NULL)
				{
						FINAL *final=create_final(node,index0);
						list->count=1;
						list->head=final;
						list->tail=final;
				}
				else
				{
						FINAL* cur=return_final(index0);
						if(cur)
						    node_insert(node,cur);
						else
						{
								FINAL *final=create_final(node,index0);
								list->count+=1;
								FINAL *temp=list->tail;
								temp->next=final;
								list->tail=final;
						}
				}
		}
}


void display_table()
{
		FINAL *head=list->head;
		printf("\nSYMBOL TABLE\n");
		while(head)
    {
				printf("\n\nscope of table ");
				for(int i=0;i<=head->len;i++)
				{
					printf("%d.",head->scope_arr[i]);
				}
				printf("\n\n");
				printf("Name	Type	Line number value \n");
				for(int i=0;i<head->count;i++)
				{
					printf("%s \t %s \t %d \t %s	\n",head->data_arr[i].name,head->data_arr[i].type,head->data_arr[i].lineno,head->data_arr[i].value);
				}
				head = head->next;
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
	file=fopen("icg.txt","w+");
      file2=fopen("quadruple.txt","w+");
      fprintf(file2, "|op        |op1        |op2       |result     | \n");
      fprintf(file2,"-------------------------------------------------------------------\n");
      fprintf(file2,"|%-10d|%-10s|%-10d|%-10s|\n",1,"hi",2,"hi");

	yyparse();
	display_table();
	return 0;
}
