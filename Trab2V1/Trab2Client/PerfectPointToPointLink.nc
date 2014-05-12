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

#include <message.h>
#include <AM.h>

interface  PerfectPointToPointLink {
   /**
   * Used to request the transmission of messagem msg to process dest.
   * @param dest process destination    
   * @param msg  message to send
   * @param len  the length of the packet payload
   * @return       SUCCESS if the request to send succeeded, 
   *               or FAIL if the message queue is full.
   */
   command error_t pp2pSend (am_addr_t dest, message_t msg, uint8_t len);

   /**
   * Used to deliver  messagem msg sent by process src.
   * @param src process source    
   * @param msg message received
   * @param len the length of the packet payload
   * @return      must return the message delivered or a new message 
   */
   event message_t* pp2pDeliver (am_addr_t src, message_t* msg, void* payload, uint8_t len);
}
