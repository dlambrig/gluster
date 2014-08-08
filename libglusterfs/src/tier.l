/*
   Copyright (c) 2006-2012 Red Hat, Inc. <http://www.redhat.com>
   This file is part of GlusterFS.

   This file is licensed to you under your choice of the GNU Lesser
   General Public License, version 3 or any later version (LGPLv3 or
   later), or the GNU General Public License, version 2 (GPLv2), in all
   cases as published by the Free Software Foundation.
*/

%x STRING
%x COMMENT
%option yylineno
%option noinput
%option noyywrap

%{
#include "tier.tab.h"
%}

GROUP                  [g][r][o][u][p]
END                    [e][n][d]
ENDGROUP               {END}[-]{GROUP}
SPLIT                  [s][p][l][i][t]
COMBINE                [c][o][m][b][i][n][e]
TYPE                   [t][y][p][e]
OPTION                 [o][p][t][i][o][n]
INCLUDE                [i][n][c][l][u][d][e]
COMMA                  [,]

%%

"#"                    { BEGIN(COMMENT); }
<COMMENT>"\n"          { BEGIN(INITIAL); }
<COMMENT>.             { }

{GROUP}                return GROUP_BEGIN;
{ENDGROUP}             return GROUP_END;
{INCLUDE}              return INCLUDE;
{SPLIT}                return SPLIT;
{COMBINE}              return COMBINE;
{TYPE}                 return TYPE;
{OPTION}               return OPTION;
{COMMA}                return COMMA;
\"                     BEGIN(STRING);
<STRING>{
       \"         {
                       if (0) {
                              yyunput (0, NULL);
                       }
                       BEGIN (INITIAL);
                       yylval.strval = yytext;
                       return STRING_TOK;
       }
}
[^ ,\t\r\n\"\\]+ {    yylval.strval = strdup (yytext) ; return ID; }
[ \t\r\n]+             ;
%%


