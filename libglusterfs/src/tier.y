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
#include <xlator.h>
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


  %}

%%

GROUPS:            GROUP | GROUP GROUPS;

GROUP:             HEADER GROUP_DESCRIPTORS TERMINATOR;

HEADER :           GROUP_BEGIN ID
{
        tier_group_t *tier_group = NULL;
        dict_t  *tier_dict = NULL;
        tier_group = create_tier_group();
        gf_log("glusterd",GF_LOG_INFO,"volume %x %s", tier_group, $2);
        tier_group->name = strdup($2);
        set_cur_tier_group(tier_group);
        tier_dict = get_tier_dict();
        dict_add(tier_dict, tier_group->name, int_to_data((int64_t)tier_group));
}

TERMINATOR:        GROUP_END
{
        gf_log("glusterd",GF_LOG_INFO,"end-volume");
}

GROUP_DESCRIPTORS: GROUP_DESCRIPTOR | GROUP_DESCRIPTOR GROUP_DESCRIPTORS;

GROUP_DESCRIPTOR:  GROUP_INCLUDE | GROUP_OPTION | GROUP_TYPE | GROUP_SPLIT | GROUP_COMBINE;

GROUP_INCLUDE:     INCLUDE ID
{
        tier_group_t *tier_group = get_cur_tier_group();
        gf_log("glusterd",GF_LOG_INFO,"     include %s", $2);
        tier_group->group_type = GF_BRICK;
}

GROUP_OPTION:      OPTION ID ID
{        
        tier_group_t *tier_group = get_cur_tier_group();
        gf_log("glusterd",GF_LOG_INFO,"     option %s %s", $2, $3);
        dict_add(tier_group->options, $2, str_to_data($3));
}

GROUP_TYPE:        TYPE ID
{
        tier_group_t *tier_group = get_cur_tier_group();
        gf_log("glusterd",GF_LOG_INFO,"     type %s", $2);
        tier_group->type = strdup($2);
}

GROUP_SPLIT:       SPLIT ID ID ID;

GROUP_COMBINE:     COMBINE ID_LIST
{
        tier_group_t *tier_group = get_cur_tier_group();
        tier_group->group_type = GF_COMBINE;
        gf_log("glusterd",GF_LOG_INFO,"     subvolumes ");
}

ID_LIST:           ID_ITEM | ID_ITEM COMMA ID_LIST;

ID_ITEM:           ID
{
        tier_group_t *tier_group = NULL;
        tier_group_t *head_tier_group = NULL;
        data_t *value = NULL;
        dict_t *tier_dict = NULL;

        tier_dict = get_tier_dict();
        head_tier_group = get_cur_tier_group();

        value = dict_get(tier_dict, $1);
        if (value == NULL) {
                tier_group = create_tier_group();
                dict_add(tier_dict, strdup($1), int_to_data((int64_t)tier_group));
                tier_group->name = strdup($1);
                gf_log("glusterd",GF_LOG_INFO,"not found %s",$1);
        } else {
                tier_group = (tier_group_t *) data_to_uint64(value);
                gf_log("glusterd",GF_LOG_INFO,"found %x cur %x",tier_group, head_tier_group);
        }

        tier_group->parent = head_tier_group;
        list_del(&tier_group->root_candidates); 
        list_add(&tier_group->siblings, &head_tier_group->children_head);
}

%%

int parse_tier()
{
        yyparse();
        return 0;
}

int parse_tier_file(char *file)
{
        extern FILE *yyin;
        init_tier();
        yyin = fopen(file, "r");
        if (!yyin)
                return errno;

        yyparse();
        return 0;
}

