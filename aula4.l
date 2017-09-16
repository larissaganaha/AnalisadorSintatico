%{

  #include "y.tab.h"
  #include <string.h>

%}
%%
^GET			{sscanf(yytext, "%s", &yylval.str);
		  return (COMANDO);
		}

^User-Agent:	{sscanf("User-Agent", "%s", &yylval.str);
		  return (COMANDO);
		}

[a-zA-Z0-9_Ç-Û;/+.=*()-]+ 		{ sscanf(yytext, "%s", &yylval.str);
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
[ ]		;
[#].*   ;

Mensagem[ ]Recebida:  ;

	/*a seguinte linha pode vir a ser usada para decidir se a conexao foi bem estabelecida, e se os parametros devem ser coletados*/
.*já[ ]está[ ]aceitando[ ]conexões[ ]de[ ]clientes[ ]HTTP.	;

.		return(INVALIDO);

%%
