/*
  Copyright (c) 2008-2012 Red Hat, Inc. <http://www.redhat.com>
  This file is part of GlusterFS.

  This file is licensed to you under your choice of the GNU Lesser
  General Public License, version 3 or any later version (LGPLv3 or
  later), or the GNU General Public License, version 2 (GPLv2), in all
  cases as published by the Free Software Foundation.
*/

#ifndef _TIER_H

typedef enum {
        GF_COMBINE = 1,
        GF_SPLIT   = 2
} tier_grouptype_t;

struct _tier_group {
        tier_grouptype_t type;
        char *name;
        struct list_head children;
};

typedef struct _tier_group tier_group_t;

#endif /* _TIER_H */
