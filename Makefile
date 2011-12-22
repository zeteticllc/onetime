## $Id: Makefile.in,v 1.5 2001/08/21 13:36:27 lombards Exp $

YKPDIR = yubikey-personalization
APP = totpy
TARGET = $(APP)

LIBS = /usr/local/lib/libyubikey.a
INCS = -I$(YKPDIR) -I$(YKPDIR)/ykcore -I$(YKPDIR)/rfc4634
CFLAGS = -g -O2  
#DEFS = 
LDFLAGS = -framework IOKit -framework CoreFoundation 
CC = gcc 

SRC = $(APP).c \
	$(YKPDIR)/ykcore/ykcore_osx.c \
	$(YKPDIR)/ykcore/ykcore.c \
	$(YKPDIR)/ykcore/ykstatus.c \
	$(YKPDIR)/rfc4634/sha1.c \
	$(YKPDIR)/rfc4634/sha224-256.c \
	$(YKPDIR)/rfc4634/sha384-512.c \
	$(YKPDIR)/rfc4634/usha.c \
	$(YKPDIR)/rfc4634/hmac.c \
	$(YKPDIR)/ykpers.c \
	$(YKPDIR)/ykpbkdf2.c

OBJS = ${SRC:.c=.o}

%.o: %.c
	$(CC) $(INCS) $(CFLAGS) -c -o $@ $<

#$(OBJS): $(SRC)
#	$(CC) $(INCS) $(DEFS) $(LIBS) $(LDFLAGS) $(CFLAGS) -o $@ $^

$(TARGET): $(OBJS) 
	$(CC) $(INCS) $(DEFS) $(LIBS) $(CFLAGS) $(LDFLAGS) $(OBJS) -o $@

all: $(TARGET)

clean:
	rm -rf $(OBJS) $(TARGET) $(OBJS) *.o 
