#ifndef TRAB2SERVER_H
#define TRAB2SERVER_H

enum {
  AM_TRAB2 = 6,
  TIMER_PERIOD_MILLI = 1000,
  N_CLIENTS = 3
};

typedef nx_struct Trab2msg {
  nx_uint8_t src;
  nx_uint8_t counter;
  nx_uint8_t msgID;
} Trab2msg;

#endif
