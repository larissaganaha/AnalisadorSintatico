%{

  #include "y.tab.h"
  #include <string.h>
  
%}
%%
[a-zA-Z0-9_Ç-Û]+ 	{ sscanf(yytext, "%s", &yylval.str);
		  printf("Palavra: yytext = %s \t yylval = %s\n", yytext, yylval.str);
		  return (PALAVRA);
		}
:		{ sscanf(yytext, "%s", &yylval.str);
		  printf("Dois Pontos: yytext = %s \t yylval = %s\n", yytext, yylval.str);
		  return(DP);
		}
,		{ sscanf(yytext, "%s", &yylval.str);
		  printf("Virgula: yytext = %s \t yylval = %s\n", yytext, yylval.str);
		  return(VIRGULA);
		}
\n		{
          strcpy(yylval.str, yytext);
		  printf("nl: yytext = (%s) \t yylval = (%s)\n", yytext, yylval.str);
		  return(NL);
		}
[ ]     ;
[#].*\n  ;
%%
