/*
  Copyright (c) 2008-2012 Red Hat, Inc. <http://www.redhat.com>
  This file is part of GlusterFS.

  This file is licensed to you under your choice of the GNU Lesser
  General Public License, version 3 or any later version (LGPLv3 or
  later), or the GNU General Public License, version 2 (GPLv2), in all
  cases as published by the Free Software Foundation.
*/
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <list.h>
#include <dict.h> 
#include <tier.h>

void set_cur_tier_group(tier_group_t *tier_group)
{
        cur_tier_group = tier_group;
}

tier_group_t *create_tier_group()
{
        tier_group_t *tier_group = NULL;
        tier_group = (tier_group_t *) malloc(sizeof(tier_group_t));
        INIT_LIST_HEAD(&tier_group->children);
        return tier_group;
}

void set_cur_tier_dict()
{
        cur_tier_dict = get_new_dict();
}

tier_group_t *get_cur_tier_group()
{
        return cur_tier_group;
}

dict_t *get_tier_dict()
{
        return cur_tier_dict;
}

void display_tier()
{
        printf("Display!\n");
}
