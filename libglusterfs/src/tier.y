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
#include <stdlib.h>
#include <list.h>
#include <dict.h> 
#include <tier.h>

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
        tier_group_t *tier_group = NULL;
        dict_t  *tier_dict = NULL;
        tier_group = create_tier_group();
        printf("volume %x %s\n", tier_group, $2);
        tier_group->name = strdup($2);
        set_cur_tier_group(tier_group);
        tier_dict = get_tier_dict();
        dict_add(tier_dict, tier_group->name, int_to_data((int64_t)tier_group));
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
        tier_group_t *tier_group = get_cur_tier_group();
        tier_group->type = GF_COMBINE;
        printf("     subvolumes ");
        display_list();
        init_list();
}

ID_LIST:           ID_ITEM | ID_ITEM ID_LIST;

ID_ITEM:           ID
{
        tier_group_t *tier_group = NULL;
        tier_group_t *head_tier_group = NULL;
        data_t *value = NULL;
        dict_t *tier_dict = NULL;

        tier_dict = get_tier_dict();
        value = dict_get(tier_dict, $1);
        if (value == NULL) {
                tier_group = create_tier_group();
                dict_add(tier_dict, strdup($1), int_to_data((int64_t)tier_group));
                tier_group->name = strdup($1);
                printf("not found %s\n",$1);
        } else {
                tier_group = (tier_group_t *) data_to_uint64(value);
                printf("found %x\n",tier_group);
        }

        head_tier_group = get_cur_tier_group();
        tier_group->parent = head_tier_group;
        list_del(&tier_group->root_candidates); 
        list_add(&tier_group->children, &head_tier_group->children);
        add_list($1);
}

%%

int parse_tier()
{
        yyparse();
        return 0;
}


