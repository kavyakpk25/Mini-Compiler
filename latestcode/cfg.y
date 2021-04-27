S     : START;

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

GLOBAL  : ASSIGN_EXPR T_semi  GLOBAL
				| EXPR T_semi  GLOBAL
				| DECLARATION T_semi  GLOBAL
				| FUNCTION_DEF GLOBAL
				| CLASS_DEF GLOBAL
				| PTR_EXPR T_semi  GLOBAL
				| OBJ_EXPR T_semi  GLOBAL
				| ARR_EXPR T_semi  GLOBAL
				| MAIN
				;

ASSIGN_TOK  : ASSIGN_EXPR T_semi;

MAIN : TYPE MAINTOK  BODY_MAIN
      | TYPE MAINTOK BODY_MAIN   FUNC_AND_DEC
      | TYPE MAINTOK   BODY_MAIN  CLASS_REC
      | TYPE MAINTOK    BODY_MAIN FUNC_AND_DEC CLASS_REC
      | TYPE MAINTOK  BODY_MAIN   CLASS_REC FUNC_AND_DEC
      ;

BODY_MAIN  : flower_paran_o 
		    | flower_paran_o flower_paran_c 
		    ;

CLASS_REC: CLASS_REC CLASS_DEF
      | CLASS_DEF
      ;

FUNC_AND_DEC: ASSIGN_TOK FUNC_AND_DEC
      | EXPR_TOK FUNC_AND_DEC
      | ASSIGN_TOK
      | EXPR_TOK
      | FUNCTION_DEF
      | FUNCTION_DEF FUNC_AND_DEC
      | DECL_TOK FUNC_AND_DEC
      | DECL_TOK
      ;

EXPR_TOK: EXPR T_semi 
          ;

DECL_TOK : DECLARATION T_semi 
         ;

func_paran_o:	T_lround	

func_paran_c:	T_rround

flower_paran_o: T_lflower

flower_paran_c:	T_rflower	

BODY  : flower_paran_o C flower_paran_c
      | flower_paran_o flower_paran_c
      ;

PARAMS  : TYPE ID  
	      | TYPE ID T_comma PARAMS
	      | CHAR_PTR ID  
	      | CHAR_PTR ID T_comma PARAMS
	      | PTR_TYPE ID   
	      | PTR_TYPE ID T_comma PARAMS
	      ;

FUNCTION_DEF  : TYPE ID func_paran_o PARAMS func_paran_c 
				      | TYPE ID func_paran_o func_paran_c 
				      | TYPE ID func_paran_o PARAMS func_paran_c T_semi 
				      | TYPE ID func_paran_o func_paran_c T_semi 
				      | VOID ID func_paran_o PARAMS func_paran_c 
				      | VOID ID func_paran_o func_paran_c 
				      | VOID ID func_paran_o PARAMS func_paran_c T_semi 
				      | VOID ID func_paran_o func_paran_c T_semi 
				      | PTR_TYPE ID func_paran_o PARAMS func_paran_c 
				      | PTR_TYPE ID func_paran_o func_paran_c 
				      | PTR_TYPE ID func_paran_o PARAMS func_paran_c T_semi 
				      | PTR_TYPE ID func_paran_o func_paran_c T_semi 
				      | CHAR_PTR ID func_paran_o PARAMS func_paran_c T_semi 
				      | CHAR_PTR ID func_paran_o func_paran_c T_semi 
				      | CHAR_PTR ID func_paran_o PARAMS func_paran_c 
				      | CHAR_PTR ID func_paran_o func_paran_c 
				      ;

C     : C statement T_semi
      | C LOOPS
      | statement T_semi
      | LOOPS
      | C ID func_paran_o 
      | C ID func_paran_o  func_paran_c T_semi
      | ID func_paran_o 
      | ID func_paran_o  func_paran_c T_semi 
      | error
      ;

CLASS_DEF : CLASS ID flower_paran_o 
		      | CLASS ID flower_paran_o flower_paran_c T_semi 
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

LOOPS : SWITCH T_lround LIT T_rround flower_paran_o SWITCHBODY flower_paran_c
      | IF_HEAD LOOPBODY 
      | IF_HEAD LOOPBODY ELSE 
      ;

IF_HEAD
      :IF T_lround COND T_rround 

SWITCHBODY
      : SWITCHBODY CASE LIT T_col 
      | CASE LIT T_col 
      | SWITCHBODY CASE LIT T_col BREAK 
      | SWITCHLOOP1 BREAK  T_semi
      | SWITCHLOOP1 
      | SWITCHLOOP2 BREAK   T_semi
      | SWITCHLOOP2 
      | SWITCHLOOP3 BREAK  
      | SWITCHLOOP3 
      | SWITCHLOOP4 BREAK  T_semi
      | SWITCHLOOP4
      ;
SWITCHLOOP1
      :SWITCHBODY  CASE LIT T_col  LOOPBODY ;

SWITCHLOOP2
      : CASE LIT T_col LOOPBODY;

SWITCHLOOP3
       :DEFAULT T_col  LOOPBODY ;

SWITCHLOOP4
       :DEFAULT T_col   
       ;

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
		      | RETURN 
		      | RETURN T_lround EXPR T_rround 
		      | RETURN EXPR 
		      | error
		      ;

COND  : LIT RELOP LIT 
      | LIT
      | LIT RELOP LIT bin_boolop LIT RELOP LIT 
      | un_boolop LIT RELOP LIT 
      | LIT bin_boolop LIT 
      | un_boolop T_lround LIT T_rround  
      | un_boolop LIT 
      | error
      ;

ASSIGN_EXPR
      : ID T_eq EXPR
      | TYPE ID T_eq EXPR
      | CHAR_PTR ID T_eq STRING_LIT
      ;

DECLARATION
      : TYPE ID 
      | DECLARATION T_comma ID 
      | CHAR_PTR ID 
      ;

TERNARY_EXPR
      : T_lround COND T_rround '?' statement T_col statement
      ;

REP_PRINT:
        T_lt T_lt LIT 
      | REP_PRINT  T_lt T_lt LIT  
      | T_lt T_lt ENDL 
      |  REP_PRINT T_lt T_lt ENDL 
			;

PRINT : COUT  REP_PRINT 
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
      | CHAR_PTR ID T_eq T_amp ID 
      | ID T_eq T_amp ID
      ;

ARR_EXPR: TYPE ID T_lsq T_DIGIT T_rsq 
      | TYPE ID T_lsq T_DIGIT T_rsq T_eq 
      | TYPE ID T_sq T_eq 
      | ID T_lsq T_DIGIT T_rsq T_eq
      ;

OBJ_EXPR : ID ID  
      | ID T_dot ID T_eq LIT 
      | ID T_dot ID T_lround T_rround 
      | ID T_dot ID T_lround ARRAY T_rround 
      ;

ARRAY : LIT 
      | ARRAY T_comma 
      ;

EXPR
	: EXPR bin_boolop EXP
	| EXP
	;

EXP: EXP RELOP T
    | T
	;

T
	: T T_pl F
	| T T_min F
	| F
	;

F
	: F T_mul G
	| F T_div G
	| G
	;

G
    : LIT
	;

RELOP
      : T_lt  
      | T_gt 
      | T_lteq 
      | T_gteq 
      | T_neq  
      | T_eqeq  
      ;

bin_boolop
      : T_and 
      | T_or 
      ;

un_boolop
      : T_not 
      ;
