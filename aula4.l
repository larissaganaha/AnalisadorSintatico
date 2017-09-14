%{

  #include "y.tab.h"
  #include <string.h>

%}
%%
[a-zA-Z0-9_Ç-Û;/+.=*()-]+ 	{ sscanf(yytext, "%s", &yylval.str);
		  return (PALAVRA);
		}
localhost:[0-9]+				{sscanf(yytext, "%s", &yylval.str);
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

[M][e][n][s][a][g][e][m][ ][R][e][c][e][b][i][d][a][:]  ;

.		return(INVALIDO);

%%
