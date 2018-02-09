%{
    #include "y.tab.h"
    #include <string.h>
    void yyerror(char *);
%}

%%

!!.*\n {;}
PROGRAM {return PROGRAM;}
OKU         {return OKU;}
YAZ         {return YAZ;}

ARTI         {yylval.str="+";return ARTI;}
EKSI         {yylval.str="-";return EKSI;}
CARPI          {yylval.str="*";return CARPI;}
BOLU           {yylval.str="/";return BOLU;}

TOPLA         {yylval.str="+";return TOPLA;}
CIKAR         {yylval.str="-";return CIKAR;}
CARP          {yylval.str="*";return CARP;}
BOL           {yylval.str="/";return BOL;}
"<--"             {return ATA;}


ESITTIR           {yylval.str=strdup(yytext);return ESITTIR;}
KOMUTLAR            {yylval.str=strdup(yytext);return KOMUTLAR;}
DEGISKENLER           {yylval.str=strdup(yytext);return DEGISKENLER;}



[0-9]+                          {
                                yylval.integer= atoi(yytext);
                                return int_literal;
                                }
"\'"[^\n]*"\'"        { char buffer[strlen(yytext)-2];memcpy(buffer,&yytext[1],strlen(yytext)-2); buffer[strlen(yytext)-2]='\0';  yylval.str=strdup(buffer);
                                    return (message);
                                }


[a-zA-Z]([a-zA-Z0-9])*          {   yylval.str=strdup(yytext);
                                    return (id);
                                }


\(           {yylval.operator='(';return LEFTBRACE;}
\)           {yylval.operator=')';return LEFTBRACE;}

,     {yylval.operator=',';return COMMA;}
;     {yylval.operator=';';return SEMICOLON;}
[ \t\n\s]     ;


.               {yyerror("invalid character");}

%%
int yywrap(void) { 
    return 1;
}
