/*
   Copyright (c) 2010-2012 Red Hat, Inc. <http://www.redhat.com>
   This file is part of GlusterFS.

   This file is licensed to you under your choice of the GNU Lesser
   General Public License, version 3 or any later version (LGPLv3 or
   later), or the GNU General Public License, version 2 (GPLv2), in all
   cases as published by the Free Software Foundation.
*/
#ifndef __TIERTEST_MEM_TYPES_H__
#define __TIERTEST_MEM_TYPES_H__

#include "mem-types.h"

#define TIERTEST_MEM_TYPE_START (gf_common_mt_end + 1)

enum teirtest_mem_types_ {
        tiertest_mt_end = TIERTEST_MEM_TYPE_START
};

#endif // __TIERTEST_MEM_TYPES_H__
