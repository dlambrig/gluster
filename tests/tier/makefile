INCLUDES = -I. -I/root/gluster/libglusterfs/src -I/root/gluster -I/root/gluster/contrib/uuid

LIBS = -lglusterfs

tiertest: tiertest.c
	gcc -g -o tiertest tiertest.c $(INCLUDES) $(LIBS)

clean:
	rm -f core* tiertest
