%{
    #include<string.h>
    #include<stdio.h>
%}

%e  1019
%p  2807
%n  371
%k  284
%a  1213
%o  1117
%x ML_COMMENT
O   [0-7]
NZ  [1-9]
A   [a-zA-Z_0-9]
H   [a-fA-F0-9]
HP  (0[xX])
E   ([Ee][+-]?{D}+)
P   ([Pp][+-]?{D}+)
FS  (f|F|l|L)
IS  (((u|U)(l|L|ll|LL)?)|((l|L|ll|LL)(u|U)?))
CP  (u|U|L)
SP  (u8|u|U|L)
ES  (\\(['"\?\\abfnrtv]|[0-7]{1,3}|x[a-fA-F0-9]+))
WS  [ \t\v\f]
NL  [\n]

alpha [A-Za-z_]
digit [0-9]
%option yylineno

%%
"//".*        { printf("Comment at line %d\n", yylineno); } 
"/*"          { printf("Multi line comment starts from %d ", yylineno); BEGIN(ML_COMMENT); }
<ML_COMMENT>"*/"    { printf("Multi line comment ends at %d\n", yylineno); BEGIN(INITIAL); }
<ML_COMMENT>[^*\n]+		
<ML_COMMENT>"*"			
<ML_COMMENT>"\n"    { ; }

[ \t\n]
"while" return WHILE;
"for" return FOR;
"if" return IF;
"else" return ELSE;
"cout" {printf("IN cout");return COUT; }
"endl" return ENDL;
"break" return BREAK;
"continue" return CONTINUE;
"int" {printf("IN int"); return INT;}
"float" return FLOAT;
"char" return CHAR;
"void" return VOID;
"case" return CASE;
"switch" {printf("IN switch ");return SWITCH;}
"default" return DEFAULT;
"#include" {printf("IN include");return INCLUDE;}
"main()" {printf("IN main");return MAINTOK;}
"return" return RETURN;
{digit}+    return NUM;
"using" return USING;
"namespace" return NAMESPACE;
{alpha}({alpha}|{digit})*     {printf("\nIN id\n"); return ID;}
{alpha}({alpha}|{digit})*"\.h"?   {printf("\nIN .h %s \n",yylval);return H;}
\".*\" {printf("STRING[%s]",yytext); return STRING;}
\'.\' {printf("CHAR[%s]",yytext); return CHAR_CONST;}

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
