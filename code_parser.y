%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

FILE *yyin; 

void yyerror(const char *s);
extern char* yytext;
extern int line;
int error=0;
%}
%token TRUE
%token FALSE
%token JSON_ALPH
%token JSON_MONTH
%token JSON_DAY
%token JSON_IDSTR
%token JSON_STRNUM
%token JSON_USER
%token JSON_ID
%token JSON_TEXT
%token JSON_NAME
%token JSON_SCREENNAME
%token JSON_LOCATION
%token JSON_DISPLAYTEXTRANGE
%token JSON_CREATEDAT
%token JSON_RETWEETEDSTATUS
%token JSON_TWEET
%token JSON_TRUNCATED
%token JSON_STRING
%token JSON_NUM
%token JSON_EXTENDEDTWEET
%token JSON_FULLTEXT
%%
json: '{' body '}' ;
body: parts | body ',' parts;
parts: text | id_str |user |created_at|other |retweeted_status |  truncated | extended_tweet | tweet;
created_at: JSON_CREATEDAT ':'  JSON_DAY JSON_MONTH JSON_NUM JSON_NUM ':' JSON_NUM ':' JSON_NUM  JSON_NUM  ;
text: JSON_TEXT ':' JSON_STRING ;
twtext: JSON_TEXT ':' JSON_ALPH JSON_ALPH '@' JSON_STRING ',' JSON_STRING |JSON_TEXT ':' JSON_ALPH JSON_ALPH '@' JSON_STRING ; 
id_str: JSON_IDSTR ':' JSON_STRNUM  ;
user: JSON_USER ':' '{' userbody  '}' ;
userbody: user_parts | userbody ',' user_parts; 
user_parts: id | name | screen_name | location | other;
id: JSON_ID ':' JSON_NUM;
name: JSON_NAME ':' JSON_STRING;
screen_name: JSON_SCREENNAME ':' JSON_STRING;
location: JSON_LOCATION ':' JSON_STRING; 
other: JSON_STRING ':' JSON_STRING ;
retweeted_status: JSON_RETWEETEDSTATUS ':' '{' rtbody  '}' ;
rtbody: text ',' user | user ',' text ;
tweet: JSON_TWEET ':' '{' tbody  '}' ;
tbody: twtext ',' user | user ',' twtext ;
truncated: JSON_TRUNCATED ':' TRUE ',' display_text_range | JSON_TRUNCATED ':' FALSE;
extended_tweet: JSON_EXTENDEDTWEET ':' '{' full_text ',' display_text_range '}';
full_text : JSON_FULLTEXT ':' JSON_STRING;
display_text_range: JSON_DISPLAYTEXTRANGE ':' '[' nums ']';
nums: JSON_NUM | nums ',' JSON_NUM;
%%
void yyerror(const char *s) {
	printf("** Error in line: %d\n",line);
	error++;
}
int main(int argc, char* argv[]) {
	FILE *f;
	if (argc>1)
	{
		f = fopen(argv[1], "r");
		if (!f) {
			printf("File Error %s \n",argv[1]);
			exit(1);
		}
		yyin = f;

	}
	else
		yyin = stdin;
	
		yyparse();
		printf("\n Parsing... \n");
	if (error==0) printf("** No Errors Found \n");	
	else  printf(" Code has %d Errors !\n",error);	
}
