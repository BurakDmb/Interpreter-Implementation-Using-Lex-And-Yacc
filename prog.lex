%{
    #include "y.tab.h"
    #include <string.h>
%}

%%
PROGRAM {return PROGRAM;}

OKU         {return OKU;}
YAZ         {return YAZ;}

ARTI         {return ARTI;}
EKSI         {return EKSI;}
CARPI          {return CARPI;}
BOLU           {return BOLU;}

TOPLA         {yylval.str='+';return TOPLA;}
CIKAR         {yylval.str='-';return CIKAR;}
CARP          {yylval.str='*';return CARP;}
BOL           {yylval.str='/';return BOL;}
"<--"             {return ATA;}


ESITTIR           {yylval.str=strdup(yytext);return ESITTIR;}
DEGISKENLER           {yylval.str=strdup(yytext);return DEGISKENLER;}
KOMUTLAR            {yylval.str=strdup(yytext);return KOMUTLAR;}
EXIT                {yylval.str=strdup(yytext);return EXIT;}



[0-9]+                          {
                                yylval.integer= atoi(yytext);
                                return int_literal;
                                }
"\'"[a-zA-Z]([a-zA-Z0-9])*"\'"        { char buffer[strlen(yytext)-2];memcpy(buffer,&yytext[1],strlen(yytext)-2);  yylval.str=strdup(buffer);
                                    return (message);
                                }


[a-zA-Z]([a-zA-Z0-9])*          {   yylval.str=strdup(yytext);
                                    return (id);
                                }


\(           {yylval.operator='(';return LEFTBRACE;}
\)           {yylval.operator=')';return LEFTBRACE;}

,     {yylval.operator=',';return COMMA;}
;     {yylval.operator=';';return SEMICOLON;}
[ \t\n]     ;


.               {yyerror("invalid character");}

%%
int yywrap(void) { 
    return 1;
}
