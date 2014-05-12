#define NEW_PRINTF_SEMANTICS
#include <Timer.h>
#include "Trab2Client.h"
#include "printf.h"

configuration Trab2ClientAppC {
}
implementation {
  components MainC;
  components LedsC;
  components PrintfC;
  components Trab2ClientC as App;
  components new TimerMilliC() as Timer0;
  components ActiveMessageC;
  components new PerfectPointToPointLinkerC(AM_TRAB2) as pp2p;
  components SerialStartC;

  App.Boot -> MainC;
  App.Leds -> LedsC;
  App.Timer0 -> Timer0;
  App.Packet -> ActiveMessageC;
  App.pp2p -> pp2p;
  App.AMControl -> ActiveMessageC;

}
