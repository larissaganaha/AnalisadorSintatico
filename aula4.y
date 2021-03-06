
%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>

  //cores de print
  #define RED   "\x1B[31m"
  #define GRN   "\x1B[32m"
  #define YEL   "\x1B[33m"
  #define BLU   "\x1B[34m"
  #define MAG   "\x1B[35m"
  #define CYN   "\x1B[36m"
  #define WHT   "\x1B[37m"
  #define RESET "\x1B[0m"

  void add_command_list(char *command);
  void add_param_list_begin(char *param);
  void print_list();

  typedef struct command_list{
      char command[200];
      struct command_list *next;
      struct param_list *params;
  } command_list;

  typedef struct param_list{
      char param[200];
      struct param_list *next;
  } param_list;


  struct command_list * list = NULL;

  //flags de controle
  int comando_detectado = 0;
  int nLinha = 0;
  char comandoTxt[200];
  char paramTxt[200];
  char frase[200];


%}

%union {
  char str[200];
}

%token <str> PALAVRA COMANDO
%token VIRGULA NL DP INVALIDO 

%type <str> palavra comando DP parametro parametro_NL

%%

linhas  :   linhas linha
        | linha


linha   :   comando parametro_final {nLinha++;
                                    comando_detectado = 0;}
            |comando_sp NL          {add_param_list_begin(&frase);
                                    nLinha++;
                                    comando_detectado = 0;}
            | comando NL		{nLinha++;
                            comando_detectado = 0;}
            | erro      {nLinha++;
                        comando_detectado = 0;
                        fprintf(stderr,RED "Erro(l_%d): Nao ha comando valido.\n" RESET, nLinha);}
            | NL        {nLinha++;
                        comando_detectado = 0;}

comando_sp : COMANDO   {frase[0] = '\0';
                        strcpy(comandoTxt, $1);
                        add_command_list(&comandoTxt);}
            |comando_sp VIRGULA {strcat(frase, ",");}
            |comando_sp DP      {strcat(frase, ":");}            
            |comando_sp palavra {strcat(frase, " ");
                                strcat(frase, $2);}

comando :	palavra DP {comando_detectado = 1;
                        strcpy(comandoTxt, $1);
                        add_command_list(&comandoTxt);}

erro    :  DP parametro_final
        |  DP NL


parametro_final :   parametros parametro_NL
                |   parametro_NL

parametros  :   parametro
            |   parametros parametro

parametro_NL: palavra NL   { if(comando_detectado){
                                strcpy(paramTxt, $1);
                                add_param_list_begin(&paramTxt);
                             }
                           };

parametro: palavra VIRGULA { if(comando_detectado){
                                strcpy(paramTxt, $1);
                                add_param_list_begin(&paramTxt);
                             }
                           };

palavra : PALAVRA


%%

void print_list() {
    command_list * current = list;

    while (current != NULL) {

        printf("%s\n", current->command);

        while(current->params != NULL){
            printf("\tParâmetro: %s\n", current->params->param);
            current->params = current->params->next;
        }

        current = current->next;
    }
}

void add_command_list(char *command) {
    //se a lista nao tiver sido criada, cria o primeiro elemento
    if(list == NULL){

        list = malloc(sizeof(command_list));

        strcpy(list->command, command);
        list->next = NULL;
        list->params = NULL;

        return;
    }

    command_list * current = list;

    while (current->next != NULL) {
        current = current->next;
    }

    current->next = malloc(sizeof(command_list));
    strcpy(current->next->command, command);
    current->next->next = NULL;
    current->next->params = NULL;

    return;
}


void add_param_list_begin(char *param) {

    command_list * current = list;

    while (current->next != NULL) {
        current = current->next;
    }

    //se a lista de parametros nao tiver sido criada, cria o primeiro elemento
    if(current->params == NULL){

        current->params = malloc(sizeof(param_list));

        strcpy(current->params->param, param);
        current->params->next = NULL;

        return;
    }
    param_list * new_node;
    new_node = malloc(sizeof(param_list));

    strcpy(new_node->param, param);
    new_node->next = current->params;
    current->params = new_node;

    return;
}

void main() {
    yyparse();
    print_list();
}
