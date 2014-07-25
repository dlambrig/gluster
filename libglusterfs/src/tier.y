/*
   Copyright (c) 2006-2012 Red Hat, Inc. <http://www.redhat.com>
   This file is part of GlusterFS.

   This file is licensed to you under your choice of the GNU Lesser
   General Public License, version 3 or any later version (LGPLv3 or
   later), or the GNU General Public License, version 2 (GPLv2), in all
   cases as published by the Free Software Foundation.
*/

%token  GROUP_BEGIN GROUP_END INCLUDE SPLIT COMBINE TYPE OPTION COMMA <strval> STRING_TOK <strval> ID
%union {
  int   ival;
  char *strval;
}


%{
#include <stdio.h>
#include <string.h>

int size_list=0;
char str_list[10][30];

int yylex();

void
yyerror (char const *s)
{
  fprintf (stderr, "%s\n", s);
}

void init_list()
{
  size_list = 0;
}

void add_list(char *item)
{
  strcpy(str_list[size_list], item);
  size_list++;
}

void display_list()
{
  int i=0;
 
  for (i=0; i<size_list; i++) 
    printf("%s ",str_list[i]);

  printf("\n");
}


  %}

%%

GROUPS:            GROUP | GROUP GROUPS;

GROUP:             HEADER GROUP_DESCRIPTORS TERMINATOR;

HEADER :           GROUP_BEGIN ID
{
  printf("volume %s\n", $2);
}

TERMINATOR:        GROUP_END
{
  printf("end-volume\n");
}

GROUP_DESCRIPTORS: GROUP_DESCRIPTOR | GROUP_DESCRIPTOR GROUP_DESCRIPTORS;

GROUP_DESCRIPTOR:  GROUP_INCLUDE | GROUP_OPTION | GROUP_TYPE | GROUP_SPLIT | GROUP_COMBINE;

GROUP_INCLUDE:     INCLUDE ID
{
  printf("     include %s\n", $2);
}

GROUP_OPTION:      OPTION ID ID
{
  printf("     option %s %s\n", $2, $3);
}

GROUP_TYPE:        TYPE ID
{
  printf("     type %s\n", $2);
}

GROUP_SPLIT:       SPLIT ID ID ID;

GROUP_COMBINE:     COMBINE ID_LIST
{
  printf("     subvolumes ");
  display_list();
  init_list();
}

ID_LIST:           ID_ITEM | ID_ITEM ID_LIST;

ID_ITEM:           ID
{
  add_list($1);
}

%%

int main()
{
  //  yydebug=1;
  yyparse();
  return 0;
}


