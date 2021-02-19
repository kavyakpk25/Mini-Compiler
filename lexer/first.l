%{
    #include<string.h>
    #include<stdio.h>
    unsigned int SourceCol=0;
%}
%e  1019
%p  2807
%n  371
%k  284
%a  1213
%o  1117
%x ML_COMMENT

NL  [\n]
alpha [A-Za-z_]
digit [0-9]
digits {digit}+
opFraction \.{digits}
opExponent [Ee][+-]?{digits}
real {digits}{opFraction}?{opExponent}?
delim [\t|' ']
whitespace {delim}+
%option yylineno

%%
"//".*        { printf("Comment at line %d\n", yylineno); } 
"/*"          { printf("Multi line comment starts from %d ", yylineno); BEGIN(ML_COMMENT); }
<ML_COMMENT>"*/"    { printf("Multi line comment ends at %d\n", yylineno); BEGIN(INITIAL); }
<ML_COMMENT>[^*\n]+		
<ML_COMMENT>"*"			
<ML_COMMENT>"\n"    { ; }

{NL}     {SourceCol=0;}
[ \t\n]
"while"      {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Token Type: %s \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_WHILE",yylineno,SourceCol);SourceCol+=yyleng;return WHILE;}
"for"        {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_FOR",yylineno,0);return FOR;}

"class"     {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_CLASS",yylineno,SourceCol);SourceCol+=yyleng;  return CLASS;}
"public"     {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_PUBLIC",yylineno,SourceCol);SourceCol+=yyleng;return PUBLIC;}
"private"    {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_PRIVATE",yylineno,SourceCol);SourceCol+=yyleng;return PRIVATE;}
"protected"  {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_PROTECTED",yylineno,SourceCol);SourceCol+=yyleng;return PROTECTED;}

"if"        {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_IF",yylineno,SourceCol);SourceCol+=yyleng;return IF;}
"else"       {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_ELSE",yylineno,SourceCol);SourceCol+=yyleng;return ELSE;}


"switch"     {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_SWITCH",yylineno,SourceCol);SourceCol+=yyleng;return SWITCH;}
"case"       {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_CASE",yylineno,SourceCol);SourceCol+=yyleng;return CASE;}
"default"    {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_DEFAULT",yylineno,SourceCol);SourceCol+=yyleng;return DEFAULT;}

"cout"       {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_COUT",yylineno,SourceCol);SourceCol+=yyleng;return COUT; }
"endl"       {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_ENDL",yylineno,SourceCol);SourceCol+=yyleng;return ENDL;}

"break"      {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_BREAK",yylineno,SourceCol);SourceCol+=yyleng;return BREAK;}
"continue"   {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_CONTINUE",yylineno,SourceCol);SourceCol+=yyleng;return CONTINUE;}
"return"     {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_RETURN",yylineno,SourceCol);SourceCol+=yyleng;return RETURN;}

"int"        {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_INT",yylineno,SourceCol);SourceCol+=yyleng; return INT;}
"float"      {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_FLOAT",yylineno,SourceCol);SourceCol+=yyleng;return FLOAT;}
"char"       {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_CHAR",yylineno,SourceCol);SourceCol+=yyleng;return CHAR;}
"void"       {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_VOID",yylineno,SourceCol);SourceCol+=yyleng;return VOID;}
"string"     {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_STRING",yylineno,SourceCol);SourceCol+=yyleng;return STRING;}
"bool"       {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_BOOL",yylineno,SourceCol);SourceCol+=yyleng;return BOOL;}
"int*"       {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_INTPTR",yylineno,SourceCol);SourceCol+=yyleng;return INT_PTR;}
"float*"     {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_FLOATPTR",yylineno,SourceCol);SourceCol+=yyleng;return FLOAT_PTR;}
"char*"      {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_CHARPTR",yylineno,SourceCol);SourceCol+=yyleng;return CHAR_PTR;}


"#include"   {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_INCLUDE",yylineno,SourceCol);SourceCol+=yyleng;return INCLUDE;}
"main()"     {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_MAINTOK",yylineno,SourceCol);SourceCol+=yyleng;return MAINTOK;}

"using"      {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_USING",yylineno,SourceCol);SourceCol+=yyleng;return USING;}
"namespace"  {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_NAMESPACE",yylineno,SourceCol);SourceCol+=yyleng;return NAMESPACE;}

"true"       {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_TRUE",yylineno,SourceCol);SourceCol+=yyleng;return T_TRUE;}
"false"      {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_FALSE",yylineno,SourceCol);SourceCol+=yyleng;return T_FALSE;}
{digits}	{yylval.number=atoi(yytext);printf("Token: %d \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.number,"T_DIGIT",yylineno,SourceCol);SourceCol+=yyleng; return T_DIGIT;}
{real}		{yylval.real=atof(yytext);printf("Token: %f \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.real,"T_REAL", yylineno,SourceCol);SourceCol+=yyleng;return T_REAL;}
\".*\"       {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_STRINGLIT",yylineno,SourceCol);SourceCol+=yyleng;return STRING_LIT;}
\'.\'        {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_CHARCONST",yylineno,SourceCol);SourceCol+=yyleng;return CHAR_CONST;}

{alpha}({alpha}|{digit}){0,31}    {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_ID",yylineno,SourceCol);SourceCol+=yyleng;return ID;}
{alpha}({alpha}|{digit})*"\.h"?   {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_H",yylineno,SourceCol);SourceCol+=yyleng;return H;}


"<"      {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_lt",yylineno,SourceCol);SourceCol+=yyleng;return T_lt;}
">"      {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_gt",yylineno,SourceCol);SourceCol+=yyleng; return T_gt;}
"="      {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_eq",yylineno,SourceCol);SourceCol+=yyleng;return T_eq;}
"<="     {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_lteq",yylineno,SourceCol);SourceCol+=yyleng;return T_lteq;}
">="     {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_gteq",yylineno,SourceCol);SourceCol+=yyleng;return T_gteq;}
"=="     {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_eqeq",yylineno,SourceCol);SourceCol+=yyleng;return T_eqeq;}
"!="     {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_neq",yylineno,SourceCol);SourceCol+=yyleng; return T_neq;}
"+"      {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_pl",yylineno,SourceCol);SourceCol+=yyleng; return T_pl;}
"-"      {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_min",yylineno,SourceCol);SourceCol+=yyleng; return T_min;}
"*"      {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_mul",yylineno,SourceCol);SourceCol+=yyleng; return T_mul;}
"/"      {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_div",yylineno,SourceCol);SourceCol+=yyleng; return T_div;}
"++"     {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_incr",yylineno,SourceCol);SourceCol+=yyleng; return T_incr;}
"--"     {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_decr",yylineno,SourceCol);SourceCol+=yyleng; return T_decr;}
"!"      {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_neq",yylineno,SourceCol);SourceCol+=yyleng; return T_neq;}
"||"     {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_or",yylineno,SourceCol);SourceCol+=yyleng;  return T_or;}
"&&"     {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_and",yylineno,SourceCol);SourceCol+=yyleng; return T_and;}
"[]"     {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_sq",yylineno,SourceCol);SourceCol+=yyleng; return T_sq;}
"["      {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_lsq",yylineno,SourceCol);SourceCol+=yyleng; return T_lsq;}
"]"      {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_rsq",yylineno,SourceCol);SourceCol+=yyleng; return T_rsq;}
"&"      {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_amp",yylineno,SourceCol);SourceCol+=yyleng;return T_amp;}
":"      {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_col",yylineno,SourceCol);SourceCol+=yyleng; return T_col;}

"("      {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_lround",yylineno,SourceCol);SourceCol+=yyleng; return T_lround;}
")"      {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_rround",yylineno,SourceCol);SourceCol+=yyleng; return T_rround;}
"{"      {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_lflower",yylineno,SourceCol);SourceCol+=yyleng; return T_lflower;}
"}"      {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_rflower",yylineno,SourceCol);SourceCol+=yyleng; return T_rflower;}
";"      {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_semi",yylineno,SourceCol);SourceCol+=yyleng; return T_semi;}
","      {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_comma",yylineno,SourceCol);SourceCol+=yyleng; return T_comma;}
"."      {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_dot",yylineno,SourceCol);SourceCol+=yyleng; return T_dot;}
.    {printf("Invalid character %s \n",yytext);return yytext[0];}

%%
