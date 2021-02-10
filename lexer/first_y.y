%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  #define YYSTYPE char *
  int yylex();
  void yyerror(char *);
  void lookup(char *,int,char,char*,char* );
  //void insert(char *,int,char,char*,char* );
  void update(char *,int,char *);
  void search_id(char *,int );
  extern FILE *yyin;
  extern int yylineno;
  extern char *yytext;
%}  
  
%% 
 Lines :  Lines S '\n' { printf("OK \n"); } 
       |  S '\n'
       |  error '\n' {yyerror("Error: reenter last line:"); yyerrok; }; 
 S     :  '(' S ')' 
       |  '[' S ']'
       |   /* empty */    ; 
%%  
  
#include "lex.yy.c"  
   
void yyerror(char * s) 
/* yacc error handler */
{    
 fprintf (stderr, "%s\n", s); 
}  
   
int main(void)  
 { 
 return yyparse(); 
 }