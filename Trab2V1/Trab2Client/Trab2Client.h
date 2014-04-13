#ifndef TRAB2CLIENT_H
#define TRAB2CLIENT_H

enum {
  AM_TRAB2 = 6,
  TIMER_PERIOD_MILLI_C = 250,
  N_SERVERS = 2
};

typedef nx_struct Trab2msg {
  nx_uint8_t src;
  nx_uint8_t counter;
  nx_uint8_t msgID;
} Trab2msg;

#endif
