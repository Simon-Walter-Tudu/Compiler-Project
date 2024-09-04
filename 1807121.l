char [a-zA-Z]
digit [0-9]
special [$_@]
space " "
newline "\n"
Datatype "int_T"|"double_T"|"float_T"|"char_T"|"string_T"
Operator "add_T"|"sub_T"|"mul_T"|"div_T"|"mod_T"||"power_T"
Relational_Operator "greater_T"|"less_T"|"equal_T"|"not_equal_T"|"greater_eT"|"less_eT"
single_line_comment "//".*
multiple_line_comment [/][][A-Za-z0-9. \n][*][/]
user_datatype "int_T"|"float_T"|"char_T"|"double_T"|"string_T"
variable "var_"[a-zA-Z]([a-zA-Z0-9])*
logical_operator "&&"|"||"|"!!"
%{
    #include "1807121.tab.h"
	#include<string.h>
	#include <math.h>
%}

%%
","		{return COMMA;}
";"		{return SEMICOLON;}
":"		{return COLON;}
"show_var" { return SHOW_VAR;}
"show_str" {return SHOW_STR;}
"show_line" {return SHOW_LINE;}
"scan" {return SCAN;}

{digit}+ 	{
				yylval.val = atoi(yytext);
				return NUM;
			}
	

{single_line_comment} {
	printf("This is single line comment\n");
}
{multiple_line_comment} {
	printf("This is multiple line comment\n");
}


"main_T"		{return MAIN;}
"Func_"({char}|{digit}|{special})+ {return FUNCTION;}
{variable} { strcpy(yylval.text,yytext);return ID;}


"int_T"			{return INT;}
"double_T"		{return DOUBLE;}
"float_T"		{return FLOAT;}
"char_T"		{return CHAR;}

"if_T"			{return IF;}
"else_T"		{return ELSE;}
"eif_T"			{return ELSEIF;}
"switch_T"		{return SWITCH;}
"default_T"		{return DEFAULT;}


"fbs_T"			{return FBS;}
"fbe_T"			{return FBE;}
"sbs_T"			{return SBS;}
"sbe_T"			{return SBE;}


"for_T"		{return FOR;}
"To"        {return TO;}
"inc_by"    {return INCREMENT_BY;}
"while_T"     {return WHILE;}


"greater_T"  {return GT;}
"less_T"     {return LT;}
"greater_eT"    {return GE;}
"less_eT"       {return LE;}
"not_equal_T"		{return NENENENENENENENENENENENENENENENE;}
"equal_T"		{return EQ;}
"Less"  {return LESS;}
"Great" {return GREAT;}


"assign_T"		{return ASGN;}
"incre_T"		{printf("++");}
"decre_T"		{printf("--");}
"pincre_T"		{printf("++");}
"pdecre_T"		{printf("--");}



"add_T"			{return PLUS;}
"sub_T"			{return MINUS;}
"mul_T"			{return MULT;}
"div_T"			{return DIV;}
"mod_T"			{return MODULUS;}
"power_T"		{return POWER;}
"add_eT"		{printf("+=");}
"sub_eT"		{printf("-=");}
"mul_eT"		{printf("*=");}
"div_eT"		{printf("/=");}


. {}
"\""(.)*"\"" {strcpy(yylval.text,yytext);return STR;}

%%

int yywrap()
{
	return 1;
}

int main(){
   yyin = freopen("input.txt","r",stdin);
   yyout = freopen("output.txt","w",stdout);
   yyparse();
}