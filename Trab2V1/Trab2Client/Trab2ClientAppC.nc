#include <Timer.h>
#include "Trab2Client.h"

configuration Trab2ClientAppC {
}
implementation {
  components MainC;
  components LedsC;
  components Trab2ClientC as App;
  components new TimerMilliC() as Timer0;
  components ActiveMessageC;
  components new AMSenderC(AM_TRAB2);
  components new AMReceiverC(AM_TRAB2);

  App.Boot -> MainC;
  App.Leds -> LedsC;
  App.Timer0 -> Timer0;
  App.Packet -> AMSenderC;
  App.AMPacket -> AMSenderC;
  App.AMControl -> ActiveMessageC;
  App.AMSend -> AMSenderC;
  App.Receive -> AMReceiverC;
}
