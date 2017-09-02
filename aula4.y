
%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  
  void add_command_list(char *command);
  void add_param_list_begin(char *param);
  void print_list();
  
  typedef struct command_list{
      char command[30];
      struct command_list *next;
      struct param_list *params;
  } command_list;
  
  typedef struct param_list{
      char param[30];
      struct param_list *next;
  } param_list;
  
  
  struct command_list * list = NULL;
  
  //flags de controle
  int comando_detectado = 0;
  char comandoTxt[30];
  char paramTxt[30];


%}

%union {
  char str[30];
}

%token <str> PALAVRA
%token VIRGULA NL DP

%type <str> palavra comando DP parametro parametro_NL

%%

linhas  :   linhas linha
        | linha


linha   :   comando parametro_final {comando_detectado = 0;}
            | comando NL		{comando_detectado = 0;}
            | erro      {comando_detectado = 0;}
            | NL        {comando_detectado = 0;}

comando :	palavra DP {comando_detectado = 1;
                        strcpy(comandoTxt, $1);
                        add_command_list(&comandoTxt);
                       };

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
    printf(" ---------------- PRINTANDO LISTA ----------------------\n");
    command_list * current = list;
    
    while (current != NULL) {
        
        printf("%s\n", current->command);
        
        while(current->params != NULL){
            printf("\tParâmetro: %s\n", current->params->param);
            current->params = current->params->next;
        }
        
        current = current->next;
    }
    printf(" ------------------------------------------------------\n");
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
    printf(param);
    
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

