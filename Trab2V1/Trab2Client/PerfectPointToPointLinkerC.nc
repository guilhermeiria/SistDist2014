/**
 * Interface and properties of perfect pont-to-point links.
 *
 * PROPERTIES:
 * PL1: Reliable delivery: Let Pi be any process that sends a message m to a process Pj.
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

generic configuration PerfectPointToPointLinkerC (am_id_t AMId) {
  provides {
    interface PerfectPointToPointLink;
    interface Init;
  }
}

implementation {
   components new AMSenderC(AMId), new AMReceiverC(AMId), new TimerMilliC(), new QueueC(pp2pMsg_t, NQUEUE);
   components new PerfectPointToPointLinkerP() as pp2p;
   components MainC, LedsC;
   
   MainC.SoftwareInit -> pp2p; 
   PerfectPointToPointLink = pp2p;
   Init = pp2p;
   pp2p.Receive -> AMReceiverC;
   pp2p.AMSend -> AMSenderC;
   pp2p.Timer -> TimerMilliC;
   pp2p.AMPacket -> AMSenderC;
   pp2p.Acks -> AMSenderC;
   pp2p.Queue -> QueueC;
   pp2p.Leds -> LedsC;
}
