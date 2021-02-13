%{
    #include<string.h>
    #include<stdio.h>
    int colnum=0;
	  char line[1000];
	  char error[1000];
	  char stringNumber[5];
	  long long int temp;
%}

alpha [A-Za-z_]
digit [0-9]
%option yylineno

%%
\/\/.*             {
                    strcpy(line, "TOKEN_COMMENT ");
                    strcat(line,yytext);
                    strcat(line,"\n");
                    fprintf(yyout,"%s",line);
                    };

\/\*([^*]|(\*[^*/]))*    {
                      printf("\033[1;31merror \033[0min line %d : unclosed comment section\n",yylineno);
                      strcpy(error,"error in line ");
                      sprintf(stringNumber, "%d", yylineno);
                      strcat(error,stringNumber);
                      strcat(error," : unclosed comment section\n");
                      fprintf(yyout,"%s",error);
                    };

.*\*\/   {
                      printf("\033[1;31merror \033[0min line %d : unopend comment section\n",yylineno);
                      strcpy(error,"error in line ");
                      sprintf(stringNumber, "%d", yylineno);
                      strcat(error,stringNumber);
                      strcat(error," : unopend comment section\n");
                      fprintf(yyout,"%s",error);

                    };

\/\*([^*]|(\*[^*/]))*\*\/   {
                    strcpy(line, "TOKEN_COMMENT ");
                    strcat(line,yytext);
                    strcat(line,"\n");
                    fprintf(yyout,"%s",line);
                    };
[ \t\n]
"while" return WHILE;
"for" return FOR;
"if" return IF;
"else" return ELSE;
"cout" return COUT; 
"endl" return ENDL;
"break" return BREAK;
"continue" return CONTINUE;
"int" {printf("IN int"); return INT;}
"float" return FLOAT;
"char" return CHAR;
"void" return VOID;
"#include" {printf("IN include");return INCLUDE;}
"main()" {printf("IN main");return MAINTOK;}
{digit}+    return NUM;
{alpha}({alpha}|{digit})*    return ID;
{alpha}({alpha}|{digit})*"\.h"?   return H;
\".*\" return STRING;
"<"   return T_lt;
">"     return T_gt;
"="     return T_eq;
"<="    return T_lteq;
">="    return T_gteq;
"=="    return T_eqeq;
"!="    return T_neq;
"+"     return T_pl;
"-"     return T_min;
"*"     return T_mul;
"/"     return T_div;
"++"    return T_incr;
"--"    return T_decr;
"!"     return T_neq;
"||"    return T_or;
"&&"    return T_and;

.    return yytext[0];
%%
