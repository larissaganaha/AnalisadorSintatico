%{

  #include "y.tab.h"
  #include <string.h>
  
%}
%%
[a-zA-Z0-9_Ç-Û]+ 	{ sscanf(yytext, "%s", &yylval.str);
		  return (PALAVRA);
		}
:		{ sscanf(yytext, "%s", &yylval.str);
		  return(DP);
		}
,		{ sscanf(yytext, "%s", &yylval.str);
		  return(VIRGULA);
		}
\n		{
          strcpy(yylval.str, yytext);
		  return(NL);
		}
[ ]     ;
[#].*   ;
.		return(INVALIDO);

%%
