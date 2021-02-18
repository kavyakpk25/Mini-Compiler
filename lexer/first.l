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
"while"     {yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Token Type: %s \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_WHILE",yylineno,SourceCol);SourceCol+=yyleng;return WHILE;}
"class"     {yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_CLASS",yylineno,SourceCol);SourceCol+=yyleng;  return CLASS;}
"public"    {yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_PUBLIC",yylineno,SourceCol);SourceCol+=yyleng;return PUBLIC;}
"private"   {yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_PRIVATE",yylineno,SourceCol);SourceCol+=yyleng;return PRIVATE;}
"protected" {yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_PROTECTED",yylineno,SourceCol);SourceCol+=yyleng;return PROTECTED;}

"if"        {yylloc.first_line=yylineno;yylloc.first_column = SourceCol; yylloc.last_column = SourceCol+yyleng;yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_IF",yylineno,SourceCol);SourceCol+=yyleng;return IF;}
"else"      {yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_ELSE",yylineno,SourceCol);SourceCol+=yyleng;return ELSE;}


"switch"    {yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_SWITCH",yylineno,SourceCol);SourceCol+=yyleng;return SWITCH;}
"case"      {yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_CASE",yylineno,SourceCol);SourceCol+=yyleng;return CASE;}
"default"   {yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_DEFAULT",yylineno,SourceCol);SourceCol+=yyleng;return DEFAULT;}

"cout"      {yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_COUT",yylineno,SourceCol);SourceCol+=yyleng;return COUT; }
"endl"      {yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_ENDL",yylineno,SourceCol);SourceCol+=yyleng;return ENDL;}

"break"     {yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_BREAK",yylineno,SourceCol);SourceCol+=yyleng;return BREAK;}
"continue"  {yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_CONTINUE",yylineno,SourceCol);SourceCol+=yyleng;return CONTINUE;}
"return"    {yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_RETURN",yylineno,SourceCol);SourceCol+=yyleng;return RETURN;}

"int"       {yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_INT",yylineno,SourceCol);SourceCol+=yyleng; return INT;}
"float"     {yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_FLOAT",yylineno,SourceCol);SourceCol+=yyleng;return FLOAT;}
"char"      {yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_CHAR",yylineno,SourceCol);SourceCol+=yyleng;return CHAR;}
"void"      {yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_VOID",yylineno,SourceCol);SourceCol+=yyleng;return VOID;}
"string"    {yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_STRING",yylineno,SourceCol);SourceCol+=yyleng;return STRING;}
"bool"      {yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_BOOL",yylineno,SourceCol);SourceCol+=yyleng;return BOOL;}
"int*"      {yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_INTPTR",yylineno,SourceCol);SourceCol+=yyleng;return INT_PTR;}
"float*"    {yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_FLOATPTR",yylineno,SourceCol);SourceCol+=yyleng;return FLOAT_PTR;}
"char*"     {yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_CHARPTR",yylineno,SourceCol);SourceCol+=yyleng;return CHAR_PTR;}


"#include"  {yylval.string=strdup(yytext);printf("Token: %s \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_INCLUDE",yylineno,SourceCol);SourceCol+=yyleng;return INCLUDE;}
"main()"    {yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_MAINTOK",yylineno,SourceCol);SourceCol+=yyleng;return MAINTOK;}

"using"     {yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_USING",yylineno,SourceCol);SourceCol+=yyleng;return USING;}
"namespace" {yylval.string=strdup(yytext);printf("Token: %s \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_NAMESPACE",yylineno,SourceCol);SourceCol+=yyleng;return NAMESPACE;}

"true"      {yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_TRUE",yylineno,SourceCol);SourceCol+=yyleng;return T_TRUE;}
"false"     {yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_FALSE",yylineno,SourceCol);SourceCol+=yyleng;return T_FALSE;}
{digits}	{yylval.number=atoi(yytext);printf("Token: %d \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.number,"T_DIGIT",yylineno,SourceCol);SourceCol+=yyleng; return T_DIGIT;}
{real}		{yylval.real=atof(yytext);printf("Token: %f \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.real,"T_REAL", yylineno,SourceCol);SourceCol+=yyleng;return T_REAL;}
\".*\"      {yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_STRINGLIT",yylineno,SourceCol);SourceCol+=yyleng;return STRING_LIT;}
\'.\'       {yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_CHARCONST",yylineno,SourceCol);SourceCol+=yyleng;return CHAR_CONST;}

{alpha}({alpha}|{digit}){0,31}   {yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_ID",yylineno,SourceCol);SourceCol+=yyleng;return ID;}
{alpha}({alpha}|{digit})*"\.h"?  {yylval.string=strdup(yytext);printf("Token: %s \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_H",yylineno,SourceCol);SourceCol+=yyleng;return H;}


"<"     {yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_lt",yylineno,SourceCol);SourceCol+=yyleng;return T_lt;}
">"     {yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_gt",yylineno,SourceCol);SourceCol+=yyleng; return T_gt;}
"="     {yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_eq",yylineno,SourceCol);SourceCol+=yyleng;return T_eq;}
"<="    {yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_lteq",yylineno,SourceCol);SourceCol+=yyleng;return T_lteq;}
">="    {yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_gteq",yylineno,SourceCol);SourceCol+=yyleng;return T_gteq;}
"=="    {yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_eqeq",yylineno,SourceCol);SourceCol+=yyleng;return T_eqeq;}
"!="    {yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_neq",yylineno,SourceCol);SourceCol+=yyleng; return T_neq;}
"+"     {yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_pl",yylineno,SourceCol);SourceCol+=yyleng; return T_pl;}
"-"     {yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_min",yylineno,SourceCol);SourceCol+=yyleng; return T_min;}
"*"     {yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_mul",yylineno,SourceCol);SourceCol+=yyleng; return T_mul;}
"/"     {yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_div",yylineno,SourceCol);SourceCol+=yyleng; return T_div;}
"++"    {yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_incr",yylineno,SourceCol);SourceCol+=yyleng; return T_incr;}
"--"    {yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_decr",yylineno,SourceCol);SourceCol+=yyleng; return T_decr;}
"!"     {yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_neq",yylineno,SourceCol);SourceCol+=yyleng; return T_neq;}
"||"    {yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_or",yylineno,SourceCol);SourceCol+=yyleng;  return T_or;}
"&&"    {yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_and",yylineno,SourceCol);SourceCol+=yyleng; return T_and;}
"[]"    {yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_sq",yylineno,SourceCol);SourceCol+=yyleng; return T_sq;}
"["     {yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_lsq",yylineno,SourceCol);SourceCol+=yyleng; return T_lsq;}
"]"     {yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_rsq",yylineno,SourceCol);SourceCol+=yyleng; return T_rsq;}
"&"     {yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_amp",yylineno,SourceCol);SourceCol+=yyleng;return T_amp;}
":"     {yylval.string=strdup(yytext);printf("Token: %s \t \t Token Type: %s \t Line number: %d \t Column number: %d \t \n",yylval.string,"T_col",yylineno,SourceCol);SourceCol+=yyleng; return T_col;}
.    return yytext[0];

%%
