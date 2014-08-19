/*
  Copyright (c) 2008-2012 Red Hat, Inc. <http://www.redhat.com>
  This file is part of GlusterFS.

  This file is licensed to you under your choice of the GNU Lesser
  General Public License, version 3 or any later version (LGPLv3 or
  later), or the GNU General Public License, version 2 (GPLv2), in all
  cases as published by the Free Software Foundation.
*/

#ifndef _TIER_H

extern int parse_tier_file(char *file);

typedef enum {
        GF_COMBINE = 1,
        GF_SPLIT   = 2,
        GF_BRICK   = 3
} tier_grouptype_t;

struct _tier_group {
        xlator_t         *xl;
        tier_grouptype_t group_type;
        char             *name;
        char             *type;
        dict_t           *options;
        struct list_head siblings;
        struct list_head children_head;
        struct list_head root_candidates;
        struct _tier_group *parent;
};

typedef struct _tier_group tier_group_t;

tier_group_t *cur_tier_group;
dict_t *cur_tier_dict;
tier_group_t root_list;

void set_cur_tier_group(tier_group_t *tier_group);

void set_cur_tier_dict();

dict_t *get_tier_dict();

void init_tier();

void display_tier();

tier_group_t *get_tier_root();

tier_group_t *create_tier_group();

tier_group_t *get_cur_tier_group();

#endif /* _TIER_H */
