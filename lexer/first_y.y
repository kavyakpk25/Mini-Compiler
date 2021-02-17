%{
#include <stdio.h>
#include <stdlib.h>
FILE * yyin;
%}
%token ID NUM T_lt T_gt T_lteq T_gteq USING NAMESPACE T_neq T_eqeq T_pl T_min T_mul T_div T_and T_or T_incr T_decr T_not T_eq WHILE INT CHAR FLOAT VOID H MAINTOK INCLUDE BREAK CONTINUE IF ELSE COUT STRING FOR ENDL SWITCH CASE DEFAULT RETURN STRING_CONST CHAR_CONST

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
           | GLOBAL
           ;

GLOBAL : ASSIGN_EXPR ';'  GLOBAL
      | ARITH_EXPR ';' GLOBAL
      | FUNCTION_DEF GLOBAL;
      | MAIN 
      ;
MAIN
      : VOID MAINTOK BODY 
      | INT MAINTOK BODY
      | VOID MAINTOK BODY FUNC_AND_DEC
      | INT MAINTOK BODY FUNC_AND_DEC
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
      | VOID ID '(' PARAMS ')' BODY
      | VOID ID '(' ')' BODY
      ;

C
      : C statement ';'
      | C LOOPS
      | statement ';'
      | LOOPS
      ;

LOOPS
      : SWITCH '(' LIT ')' '{' SWITCHBODY '}'
      | IF '(' COND ')' LOOPBODY 
      | IF '(' COND ')' LOOPBODY ELSE LOOPBODY 
      ;

SWITCHBODY
      : CASE LIT ':' SWITCHBODY
      | CASE LIT ':'
      | CASE LIT ':' BREAK ';' SWITCHBODY
      | CASE LIT ':' LOOPBODY BREAK ';' SWITCHBODY
      | CASE LIT ':' LOOPBODY SWITCHBODY
      | CASE LIT ':' LOOPBODY BREAK ';'
      | CASE LIT ':' LOOPBODY
      | DEFAULT ':' LOOPBODY BREAK ';'
      | DEFAULT ':' LOOPBODY
      | DEFAULT ':' BREAK ';'
      | DEFAULT ':'
      ;

LOOPBODY
  	  : '{' C '}'
        | '{' C BREAK ';' '}'
  	  | ';'
  	  | statement ';' 
  	  ;

statement
      : ASSIGN_EXPR
      | ARITH_EXPR
      | TERNARY_EXPR
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
      : '(' COND ')' '?' statement ':' statement
      ;

PRINT
      : COUT T_lt T_lt LIT
      | COUT T_lt T_lt LIT T_lt T_lt ENDL
      ;
LIT
      : ID
      | NUM
      | STRING 
      | CHAR_CONST
      ;
TYPE
      : INT
      | CHAR
      | FLOAT
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
      
int yyerror(){
      //yyerrok; yyclearin;
      printf("Error");
}

int main(int argc, char* args[])
{
  yyin=fopen(args[1],"r");
  yyparse();
  return 0;
}