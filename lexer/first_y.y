%{
#include <stdio.h>
#include <stdlib.h>
FILE * yyin;
extern unsigned int SourceCol;
extern unsigned int SourceLine;
%}
%locations
%union{
	int number;
	double real;
	char *string;
	}
%token ID NUM CLASS PUBLIC PRIVATE PROTECTED INT_PTR CHAR_PTR FLOAT_PTR BOOL T_TRUE T_FALSE T_col T_lt T_gt T_lteq T_gteq T_sq T_rsq T_lsq T_amp USING NAMESPACE T_neq T_eqeq T_pl T_min T_mul T_div T_and T_or T_incr T_decr T_not T_eq WHILE INT CHAR FLOAT VOID H MAINTOK INCLUDE BREAK CONTINUE IF ELSE COUT STRING FOR ENDL SWITCH CASE DEFAULT RETURN STRING_LIT CHAR_CONST
%token <number> T_DIGIT
%token <real> T_REAL
%%
S
      : START {printf("Input accepted.\n");exit(0);}
      ;

START
      : INCLUDE T_lt H T_gt START_CODE
      | INCLUDE "\"" H "\"" START_CODE
      | INCLUDE T_lt ID T_gt START_CODE
      | INCLUDE "\"" ID "\"" START_CODE
      ;

START_CODE : 
           | USING NAMESPACE ID ';' GLOBAL
           | GLOBAL
           ;

GLOBAL : ASSIGN_EXPR ';'  GLOBAL
      | ARITH_EXPR ';' GLOBAL
      | FUNCTION_DEF GLOBAL;
      | CLASS_DEF GLOBAL;
      | MAIN 
      ;
MAIN
      : VOID MAINTOK BODY 
      | INT MAINTOK BODY
      | VOID MAINTOK BODY FUNC_AND_DEC
      | INT MAINTOK BODY FUNC_AND_DEC
      | INT MAINTOK BODY CLASS_REC 
      | VOID MAINTOK BODY CLASS_REC 
      | INT MAINTOK BODY FUNC_AND_DEC CLASS_REC
      | VOID MAINTOK BODY FUNC_AND_DEC CLASS_REC
      | INT MAINTOK BODY CLASS_REC FUNC_AND_DEC
      | VOID MAINTOK BODY CLASS_REC FUNC_AND_DEC
      ;
CLASS_REC: CLASS_REC CLASS_DEF
      | CLASS_DEF 
      ;

FUNC_AND_DEC: ASSIGN_EXPR ';'  FUNC_AND_DEC
      | ARITH_EXPR ';' FUNC_AND_DEC
      | ASSIGN_EXPR ';'
      | ARITH_EXPR ';'
      | FUNCTION_DEF
      | FUNCTION_DEF FUNC_AND_DEC
      ;

BODY
      : '{' C '}'
      | '{' '}'
      ;

PARAMS : TYPE ID
      | TYPE ID ',' PARAMS
      ;

FUNCTION_DEF
      : TYPE ID '(' PARAMS ')' BODY
      | TYPE ID '(' ')' BODY
      | TYPE ID '(' PARAMS ')' ';'
      | TYPE ID '(' ')' ';'
      | VOID ID '(' PARAMS ')' BODY
      | VOID ID '(' ')' BODY
      ;
C
      : C statement ';'
      | C LOOPS
      | statement ';'
      | LOOPS
      ;

CLASS_DEF : CLASS ID '{' CLASS_BODY '}' ';'
      | CLASS ID '{' '}' ';'
      ;

CLASS_BODY : PUBLIC T_col FUNC_AND_DEC 
      | PUBLIC T_col FUNC_AND_DEC CLASS_BODY
      | PRIVATE T_col FUNC_AND_DEC 
      | PRIVATE T_col FUNC_AND_DEC CLASS_BODY
      | PROTECTED T_col FUNC_AND_DEC 
      | PROTECTED T_col FUNC_AND_DEC CLASS_BODY
      | PUBLIC T_col
      | PRIVATE T_col
      | PROTECTED T_col
      ;

LOOPS
      : SWITCH '(' LIT ')' '{' SWITCHBODY '}'
      | IF '(' COND ')' LOOPBODY {printf("\n%d %d %d \n",@$.first_line,@$.first_column,@$.last_column);}
      | IF '(' COND ')' LOOPBODY ELSE LOOPBODY
      ;

SWITCHBODY
      : CASE LIT T_col SWITCHBODY
      | CASE LIT T_col
      | CASE LIT T_col BREAK ';' SWITCHBODY
      | CASE LIT T_col LOOPBODY BREAK ';' SWITCHBODY
      | CASE LIT T_col LOOPBODY SWITCHBODY
      | CASE LIT T_col LOOPBODY BREAK ';'
      | CASE LIT T_col LOOPBODY
      | DEFAULT T_col LOOPBODY BREAK ';'
      | DEFAULT T_col LOOPBODY
      | DEFAULT T_col BREAK ';'
      | DEFAULT T_col
      ;

LOOPBODY
  	  : '{' C '}'
        | '{' C BREAK ';' '}'
  	  | ';'
  	  | statement ';' 
  	  ;

statement
      : DECLARATION
      | ASSIGN_EXPR
      | ARITH_EXPR
      | TERNARY_EXPR
      | PTR_EXPR
      | ARR_EXPR
      | PRINT
      | RETURN 
      | RETURN '(' statement ')'
      ;
COND
      : LIT RELOP LIT
      | LIT
      | LIT RELOP LIT bin_boolop LIT RELOP LIT
      | un_boolop '(' LIT RELOP LIT ')'
      | un_boolop LIT RELOP LIT
      | LIT bin_boolop LIT
      | un_boolop '(' LIT ')'
      | un_boolop LIT
      ;

ASSIGN_EXPR
      : ID T_eq ARITH_EXPR
      | TYPE ID T_eq ARITH_EXPR
      | CHAR_PTR ID T_eq STRING_LIT
      ;

DECLARATION
      : TYPE ID
      | DECLARATION ',' ID
      | CHAR_PTR ID {printf("IN CHAR POINTER DEC");} 
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
      : '(' COND ')' '?' statement T_col statement
      ;

PRINT
      : COUT T_lt T_lt LIT
      | COUT T_lt T_lt LIT T_lt T_lt ENDL
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
      : INT
      | CHAR
      | FLOAT
      | STRING
      | BOOL
      ;
PTR_TYPE : INT_PTR
      | FLOAT_PTR
      ;
PTR_EXPR: PTR_TYPE ID 
      | PTR_TYPE ID T_eq T_amp ID
      ;
ARR_EXPR: TYPE ID T_lsq NUM T_rsq
      | TYPE ID T_lsq NUM T_rsq T_eq '{' ARRAY '}' {printf("IN arr init");} 
      ;
ARRAY
      : LIT  {printf("IN array def1");} 
      | ARRAY ',' LIT  {printf("IN array def");} 
      ;
OBJ_EXPR
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
      
int yyerror(){
      //yyerrok; yyclearin;
      printf("Error %d",yylineno);
}

int main(int argc, char* args[])
{
  yyin=fopen(args[1],"r");
  yyparse();
  return 0;
}