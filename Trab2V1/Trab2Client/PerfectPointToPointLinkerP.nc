/**
 * Interface and properties of perfect pont-to-point links.
 *
 * PROPERTIES:
 * PL1: Reliable delivery: Let Pi be ny process that sends a message m to a process Pj.
 *      If neither Pi nor Pj crashes, then Pj eventually delivers m.
 * PL2: No duplication: No message is delivered by a process more than once.
 * PL3: No creation: If a message m is delivered by some process Pj, then m was previously
 *      sent to Pj by some process Pi.
 *
 * @author Silvana Rossetto
 * @date   April 24, 2012
 * @see    R. Guerraoui and L. Rodrigues, "Introduction to Reliable Distributed Programming", Springer, 2006.
 */

#include "PerfectPointToPointLink.h"

generic module PerfectPointToPointLinkerP() {
  provides {
    interface PerfectPointToPointLink as pp2p;
    interface Init;
  }
  uses {
    interface Receive;
    interface AMSend;
    interface Timer<TMilli>;
    interface AMPacket;
    interface PacketAcknowledgements as Acks;
    interface Queue<pp2pMsg_t>;
    interface Leds;
  }
}

implementation {
   pp2pMsg_t m;
   message_t *packet; 

   command error_t Init.init() {
     call Timer.startPeriodic(1000); 
     return SUCCESS;
   }

   task void send() {
      bool vazia = call Queue.empty();
      if (!vazia) {
         m = call Queue.head();
         packet = &(m.msg);
         if(call Acks.requestAck(packet) == SUCCESS) {  
            call AMSend.send(m.dest, packet, m.len);
         }
      }
   }

   event void Timer.fired() {
      post send();
   }

   command error_t pp2p.pp2pSend (am_addr_t dest, message_t msg, uint8_t len) {
      pp2pMsg_t m1; m1.dest=dest; m1.len=len; m1.msg = msg; 
      if (call Queue.enqueue(m1) == SUCCESS) {
          post send(); return SUCCESS;
      } else return FAIL;
   }

   event void AMSend.sendDone(message_t* msg, error_t err) {
      if (call Acks.wasAcked(msg)) { 
         call Queue.dequeue();
      }
   }

   event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len){
      am_addr_t src = call AMPacket.source(msg);
      return signal pp2p.pp2pDeliver(src, msg, payload, len);
   }
}
