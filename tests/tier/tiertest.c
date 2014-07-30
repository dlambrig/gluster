#include <stdio.h>
#include <glusterfs.h>
#include <tiertest.h>
#include <globals.h>
#include <tiertest-memtypes.h>
/*
glusterd_op_create_volume
  volname
  type
  count
  port (?)
  bricks
  transport
  volume-id
  internal-username
  internal-password
  
*/

static int
glusterfs_ctx_defaults_init (glusterfs_ctx_t *ctx)
{
        cmd_args_t    *cmd_args = NULL;
        call_pool_t   *pool = NULL;

        xlator_mem_acct_init (THIS, tiertest_mt_end);

        ctx->process_uuid = generate_glusterfs_ctx_id ();
        if (!ctx->process_uuid)
                return -1;

        ctx->page_size  = 128 * GF_UNIT_KB;

        ctx->iobuf_pool = iobuf_pool_new ();
        if (!ctx->iobuf_pool)
                return -1;

        ctx->event_pool = event_pool_new (DEFAULT_EVENT_POOL_SIZE);
        if (!ctx->event_pool)
                return -1;

        pool = GF_CALLOC (1, sizeof (call_pool_t),
                          cli_mt_call_pool_t);
        if (!pool)
                return -1;

        /* frame_mem_pool size 112 * 64 */
        pool->frame_mem_pool = mem_pool_new (call_frame_t, 32);
        if (!pool->frame_mem_pool)
                return -1;

        /* stack_mem_pool size 256 * 128 */
        pool->stack_mem_pool = mem_pool_new (call_stack_t, 16);

        if (!pool->stack_mem_pool)
                return -1;

        ctx->stub_mem_pool = mem_pool_new (call_stub_t, 16);
        if (!ctx->stub_mem_pool)
                return -1;

        ctx->dict_pool = mem_pool_new (dict_t, 32);
        if (!ctx->dict_pool)
                return -1;

        ctx->dict_pair_pool = mem_pool_new (data_pair_t, 512);
        if (!ctx->dict_pair_pool)
                return -1;

        ctx->dict_data_pool = mem_pool_new (data_t, 512);
        if (!ctx->dict_data_pool)
                return -1;

        INIT_LIST_HEAD (&pool->all_frames);
        LOCK_INIT (&pool->lock);
        ctx->pool = pool;

        pthread_mutex_init (&(ctx->lock), NULL);

        cmd_args = &ctx->cmd_args;

        INIT_LIST_HEAD (&cmd_args->xlator_options);

        return 0;
}


int main()
{
        int ret = 0;
        glusterfs_ctx_t *ctx = NULL;
        ctx = glusterfs_ctx_new();
        if (!ctx)
                return -1;
        
        ret = glusterfs_globals_init(ctx);
        if (ret)
                return ret;

        THIS->ctx = ctx;

        ret = glusterfs_ctx_defaults_init(ctx);
        if (ret)
                return ret;

        parse_tier();
        
}
