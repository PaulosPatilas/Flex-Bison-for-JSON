%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "code_parser.tab.h"
int line=1;
%}
ALPHA [a-zA-Z_]
DIGIT [0-9]
DIGITS {DIGIT}+
FRAC [.]{DIGITS}
EXP {E}{DIGITS}
E [eE][+-]?
HEX_DIGIT [0-9a-f]
UNESCAPEDCHAR [ -!#-\[\]-~]
ESCAPEDCHAR \\["\\bfnrt/]
UNICODECHAR \\u{HEX_DIGIT}{HEX_DIGIT}{HEX_DIGIT}{HEX_DIGIT}
CHAR {UNESCAPEDCHAR}|{ESCAPEDCHAR}|{UNICODECHAR} 
STR {CHAR}+
%x COMMENTS
	
%%
<INITIAL>"\""       {printf("%s",yytext);}BEGIN(COMMENTS);
<COMMENTS>"\""      {printf("%s",yytext);}BEGIN(INITIAL);
<COMMENTS>" \n "    {continue;}
true			{printf("%s", yytext); return TRUE; }
false			{printf("%s", yytext); return FALSE; }
\"created_at\"		{printf("%s", yytext); return JSON_CREATEDAT; }
\"id\"			{printf("\t%s", yytext); return JSON_ID; }
\"id_str\"		{printf("%s", yytext); return JSON_IDSTR; }
\"text\"		{printf("%s", yytext); return JSON_TEXT; }
\"user\"		{printf("%s", yytext); return JSON_USER; }
\"name\"		{printf("\t%s", yytext); return JSON_NAME; }
\"screen_name\"		{printf("\t%s", yytext); return JSON_SCREENNAME; }	
\"location\"		{printf("\t%s", yytext); return JSON_LOCATION; }
\"tweet\"		{printf("%s", yytext); return JSON_TWEET; }
\"retweeted_status\"	{printf("%s", yytext); return JSON_RETWEETEDSTATUS; }
\"extended_tweet\"	{printf("%s", yytext); return JSON_EXTENDEDTWEET; }
\"truncated\"       {printf("%s", yytext); return JSON_TRUNCATED; }
\"full_text\"       {if(yyleng == 140){yyless(140);} printf("%s", yytext); return JSON_FULLTEXT; }
\"display_text_range\"  {printf("%s", yytext); return JSON_DISPLAYTEXTRANGE; }
Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec	{printf("%s",yytext); return JSON_MONTH;}
Mon|Thu|Wed|Tue|Fri|Sat|Sun { printf("%s", yytext); return JSON_DAY;}
\{	{printf("\n{"); return '{';}
\}	{printf("\n}"); return '}';}
,	{printf(","); return ',';}
:	{printf(":"); return ':';}	
@   {printf("@"); return '@';}
{ALPHA} {printf("%s", yytext); return JSON_ALPH; }
\"{DIGITS}\"	{printf("%s", yytext); return JSON_STRNUM; }
\"{STR}\"	{printf("%s", yytext); return JSON_STRING; }	
{DIGITS}	{printf("%s", yytext); return JSON_NUM; }
\n 	{printf("%s",yytext); line++; }  
\[ {printf("%s", yytext); return '[';}
\] {printf("%s", yytext); return ']';}
%%
