%{
    #include<string.h>
    #include<stdio.h>
    #include "y.tab.h"
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
                    }

\/\*([^*]|(\*[^*/]))*    {
                      printf("\033[1;31merror \033[0min line %d : unclosed comment section\n",yylineno);
                      strcpy(error,"error in line ");
                      sprintf(stringNumber, "%d", yylineno);
                      strcat(error,stringNumber);
                      strcat(error," : unclosed comment section\n");
                      fprintf(yyout,"%s",error);
                    }

.*\*\/   {
                      printf("\033[1;31merror \033[0min line %d : unopend comment section\n",yylineno);
                      strcpy(error,"error in line ");
                      sprintf(stringNumber, "%d", yylineno);
                      strcat(error,stringNumber);
                      strcat(error," : unopend comment section\n");
                      fprintf(yyout,"%s",error);

                    }

\/\*([^*]|(\*[^*/]))*\*\/   {
                    strcpy(line, "TOKEN_COMMENT ");
                    strcat(line,yytext);
                    strcat(line,"\n");
                    fprintf(yyout,"%s",line);
                    }

\/[^\/]*$	{printf("incomplete single comment");}

%%