
%union {
    int integer;
    char *str;
    char operator;
};
%start EtuMnaProgram
%token <str> id message
%token <str> PROGRAM DEGISKENLER KOMUTLAR OKU YAZ
%token <str> ARTI EKSI CARPI BOLU TOPLA CIKAR CARP BOL ESITTIR ATA
%token <str> EXIT
%token <integer> int_literal
%token <operator> SEMICOLON COMMA LEFTBRACE RIGHTBRACE

%type <integer> VariableDefEBNF
%type <str> VariableName


%type <integer> Factor
%{
    #include <stdio.h>
    #include <stdlib.h>
    #include "uthash.h"
    void yyerror(char *);
    int yylex(void);

    struct variable {                  /* key */
        char id[10];
        int varValue;
        UT_hash_handle hh;         /* makes this structure hashable */
    };
%}

%%

EtuMnaProgram:
                PROGRAM id SEMICOLON DeclarationSection MainSection  {return 0;};
DeclarationSection:
                DEGISKENLER DeclerationEBNF SEMICOLON   {print_vars();};
DeclerationEBNF:
                VariableList
                |/*empty*/;
VariableList:
                VariableDef
                |VariableDef COMMA VariableList;
VariableDef:
                VariableName VariableDefEBNF  {add_variable($1,$2);};
VariableDefEBNF:
                ESITTIR int_literal             {$$=$2;}
                |/*empty*/                     {$$=0;};
VariableName:
                id;
MainSection:
                KOMUTLAR MainSectionEBNF {printf("%s",$1);};
MainSectionEBNF:
                /*empty*/
                |MainSectionEBNF Statement SEMICOLON;

Statement:
                InputStmt
                |OutputStmt
                |AssignmentStmt;
InputStmt:
                OKU message VariableName {printf("%s",$1);};
OutputStmt:
                YAZ message OutputStmtEBNF {printf("%s",$2);} ;

OutputStmtEBNF:
                /*empty*/
                |Expression         {};
AssignmentStmt:
                VariableName ATA Expression {
                                            struct variable *s;
                                            s=find_var($1);
                                            s->varValue=$3;}
Expression:
                InfixExp    {$$=$1;}
                |PostfixExp {$$=$1;};
InfixExp:
                Term
                |InfixExp ArtiEksiEBNF Term {};
ArtiEksiEBNF:
                ARTI
                |EKSI;
Term:
                Factor
                |Term CarpiBoluEBNF Factor;

CarpiBoluEBNF:
                CARPI
                |BOLU;
Factor:
                int_literal
                |VariableName   {$$=findval($1)->varValue;}
                |LEFTBRACE InfixExp RIGHTBRACE
PostfixExp:
                PostfixExp PostfixExp Operator;
PostfixExp:
                int_literal
                |VariableName;
Operator:
                TOPLA
                |CIKAR
                |CARP
                |BOL;

%%
struct variable *vars = NULL;

int calculate(char operator, int val1, int val2){

}
void print_vars() {
    struct variable *s;

    for(s=vars; s != NULL; s=s->hh.next) {
        printf("var name: %s\n var value: %d\n", s->id, s->varValue);
    }
}
struct variable *find_var(char *varname) {
    struct variable *s;

    HASH_FIND_STR( vars, varname, s );  /* s: output pointer */
    return s;
}
void add_variable(char *varname, int varvalue) {
    struct variable *s;

    s = malloc(sizeof(struct variable));
    s->varValue = varvalue;
    strcpy(s->id, varname);
    HASH_ADD_STR( vars, id, s );  /* id: name of key field */
}
void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}
int main(void) {
    yyparse();
    return 0;
}