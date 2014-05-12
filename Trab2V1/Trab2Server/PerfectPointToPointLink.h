#ifndef PP2P_H
#define PP2P_H

#include <message.h>
#include <AM.h>

enum {
  NQUEUE = 10,
};

typedef struct pp2pMsg {
   uint8_t len;
   am_addr_t dest;
   message_t msg;
} pp2pMsg_t;

#endif
