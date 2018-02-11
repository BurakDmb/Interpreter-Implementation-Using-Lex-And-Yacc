
%union {
    int integer;
    char *str;
    char operator;
};
%start EtuMnaProgram
%token <str> id message
%token <str> PROGRAM DEGISKENLER KOMUTLAR OKU YAZ
%token <str> ARTI EKSI CARPI BOLU TOPLA CIKAR CARP BOL ESITTIR ATA

%token <integer> int_literal
%token <operator> SEMICOLON COMMA LEFTBRACE RIGHTBRACE

%type <integer> Expression Term Factor InfixExp PostfixExp
%type <str> VariableName ArtiEksiEBNF CarpiBoluEBNF OutputStmtEBNF Operator


%{
    #include <stdio.h>
    #include <stdlib.h>
    #include "uthash.h"
    struct variable {                  /* key */
            char id[10];
            int varValue;
            UT_hash_handle hh;         /* makes this structure hashable */
        };
    void yyerror(char *);
    int yylex(void);
    int calculate(int val1, char operator, int val2);
    void init_var(char *varname, int varvalue);
    struct variable *find_var(char *varname, int choice);
    struct variable  *deleteUnInit(char *varname);
    void yyerror(char *s);
    void unInit_var(char *varname);
    void init_varFromVar(struct variable *s);
%}

%%

EtuMnaProgram:
                PROGRAM id SEMICOLON DeclarationSection MainSection  {return 0;};
DeclarationSection:
                DEGISKENLER DeclerationEBNF SEMICOLON   {};
DeclerationEBNF:
                VariableList
                |/*empty*/;
VariableList:
                VariableDef
                |VariableDef COMMA VariableList;
VariableDef:
                VariableName ESITTIR int_literal  {init_var($1,$3); }
                |VariableName   {unInit_var($1);}
                ;

VariableName:
                id;
MainSection:
                KOMUTLAR MainSectionEBNF {};
MainSectionEBNF:
                /*empty*/
                |MainSectionEBNF Statement SEMICOLON;

Statement:
                InputStmt
                |OutputStmt
                |AssignmentStmt;
InputStmt:
                OKU message VariableName    {
                                                int value;
                                                printf("%s",$2);
                                                scanf("%d",&value);
                                                struct variable *a;
                                                a=find_var($3,0);
                                                if(a==NULL){
                                                    a=deleteUnInit($3);
                                                    if(a==NULL){
                                                        yyerror("Error: Variable not found.");
                                                    }
                                                    else{
                                                        a->varValue=value;
                                                        init_varFromVar(a);
                                                    }
                                                }
                                                else{
                                                    a->varValue=value;
                                                }

                                            };
OutputStmt:
                YAZ message OutputStmtEBNF {if($3!=NULL) printf("%s%s",$2,$3); else printf("%s",$2);} ;

OutputStmtEBNF:
                /*empty*/           {$$=NULL;}
                |Expression         {char buffer[12]; sprintf(buffer, "%d", $1); $$=buffer;};
AssignmentStmt:
                VariableName ATA Expression {
                                                struct variable *a=find_var($1,0);
                                                if(a==NULL){
                                                    a=deleteUnInit($1);
                                                    if(a!=NULL){
                                                      a->varValue=$3;init_varFromVar(a);
                                                    }else{
                                                        yyerror("Error: Variable not found.");
                                                    }
                                                }
                                                else{
                                                    a->varValue=$3;
                                                }

                                            };
Expression:
                InfixExp    {$$=$1;}
                |PostfixExp {$$=$1;};
InfixExp:
                Term
                |InfixExp ArtiEksiEBNF Term {$$=calculate($1,$2[0],$3);};
ArtiEksiEBNF:
                ARTI    {$$="+";}
                |EKSI   {$$="-";};
Term:
                Factor
                |Term CarpiBoluEBNF Factor {$$=calculate($1,$2[0],$3);};

CarpiBoluEBNF:
                CARPI {$$="*";}
                |BOLU {$$="/";};
Factor:
                int_literal {$$=$1;}
                |VariableName       {struct variable *s=find_var($1,0);
                                        if(s!=NULL){
                                            $$=s -> varValue;
                                        }
                                        else yyerror("Error: UnInitialized variable used.");
                                        }
                |LEFTBRACE InfixExp RIGHTBRACE  {$$=$2;}
PostfixExp:
                PostfixExp PostfixExp Operator {$$=calculate($1,$3[0],$2);};
PostfixExp:
                int_literal         {$$=$1;}
                |VariableName      {
                                        struct variable *s;
                                        s=find_var($1,0);
                                        if(s!=NULL){
                                            $$=s -> varValue;
                                        }
                                        else yyerror("Error: UnInitialized variable used.");
                                   };
Operator:
                TOPLA   {$$="+";}
                |CIKAR  {$$="-";}
                |CARP   {$$="*";}
                |BOL    {$$="/";};

%%
struct variable *unInitVars=NULL;
struct variable *vars=NULL;

int calculate(int val1, char operator, int val2){
    int result;
    switch(operator){
        case '+':
            result=val1+val2;
            break;
        case '-':
            result=val1-val2;
            break;
        case '*':
            result=val1*val2;
            break;
        case '/':
            result=val1/val2;
            break;
    }
    return result;
}

struct variable *find_var(char *varname, int choice) {
    struct variable *s;
    if(choice==0){
        HASH_FIND_STR( vars, varname, s );  /* s: output pointer */
    }
    else{
        HASH_FIND_STR( unInitVars, varname, s );  /* s: output pointer */
    }
    return s;
}

void init_var(char *varname, int varvalue) {
    struct variable *s;

    s = malloc(sizeof(struct variable));
    s->varValue = varvalue;
    strcpy(s->id, varname);
    HASH_ADD_STR( vars, id, s );  /* id: name of key field */
}
void init_varFromVar(struct variable *s) {
    HASH_ADD_STR( vars, id, s );  /* id: name of key field */
}
void unInit_var(char *varname) {
    struct variable *s;

    s = malloc(sizeof(struct variable));
    s->varValue = 0;
    strcpy(s->id, varname);
    HASH_ADD_STR( unInitVars, id, s );  /* id: name of key field */
}
struct variable  *deleteUnInit(char *varname) {
    struct variable *s;
    s=find_var(varname,1);
    if(s!=NULL){
        HASH_DEL(unInitVars, s);
        return s;
    }
    else return NULL;
}
void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
    abort();
}
int main(void) {

    yyparse();
    return 0;
}