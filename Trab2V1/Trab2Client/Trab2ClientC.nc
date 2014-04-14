#include <Timer.h>
#include "Trab2Client.h"
#include "printf.h"

module Trab2ClientC {
  uses interface Boot;
  uses interface Leds;
  uses interface Timer<TMilli> as Timer0;
  uses interface Packet;
  uses interface AMPacket;
  uses interface AMSend;
  uses interface Receive;
  uses interface SplitControl as AMControl;
}
implementation {

  uint8_t remoteTime = 0;
  message_t pkt;
  uint8_t rcvdServerID;
  uint8_t rcvdMsgID;
  uint8_t serverID[N_SERVERS] = { 1, 2 }; //Array com id dos clientes
  uint8_t sMsgCount[N_SERVERS]; // Array com o contador de mensagens recebidas de cada cliente
  bool busy = FALSE;
  uint8_t i;

  void setLeds(uint16_t val) {
    if (val == 0)
      call Leds.led1On();
    else
    if (val == 1)
      call Leds.led2On();
  }

  event void Boot.booted() {
    call AMControl.start();
  }

  event void AMControl.startDone(error_t err) {
    if (err == SUCCESS) {
      call Timer0.startPeriodicAt(3000, TIMER_PERIOD_MILLI_C);
    }
    else {
      call AMControl.start();
    }
  }

  event void AMControl.stopDone(error_t err) {
  }

  event void Timer0.fired() {
    for(i=0; i < N_SERVERS; i++){
      if (!busy) {
              Trab2msg* pktsend = (Trab2msg*)(call Packet.getPayload(&pkt, sizeof(Trab2msg)));
              call Leds.led0Off();
              call Leds.led1Off();
              call Leds.led2Off();
              if (pktsend == NULL) {
	        return;
              }
              pktsend->src = TOS_NODE_ID;
              pktsend->counter = 0;
              pktsend->msgID = sMsgCount[i];
              if (call AMSend.send(serverID[i], &pkt, sizeof(Trab2msg)) == SUCCESS) {
                busy = TRUE;
              }
      }
    } 
  }


  event void AMSend.sendDone(message_t* msg, error_t err) {
    if (&pkt == msg) {
      busy = FALSE;
    }
  }

  event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len){
    if (len == sizeof(Trab2msg)) {
      Trab2msg* btrpkt = (Trab2msg*)payload;

      call Leds.led0On();

      rcvdServerID = btrpkt->src;
      rcvdMsgID = btrpkt->msgID;

      for(i=0;i<N_SERVERS;i++){
        if (rcvdServerID == serverID[i]){
          setLeds(i);
        }
        sMsgCount[i]++;
      }
    }
    return msg;
  }
    
}
