/*
 * Mote To Mote v0.0 DEWI Project
 * Copyright (C) 2017 Pedro Santos (pjsol@isep.ipp.pt)
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#include <UserButton.h>
#include <Timer.h>
#include <stdio.h>
#include <string.h>
#include "MoteToMote.h"

module MoteToMoteC{
	uses{ //General interface
		interface Boot;
		interface Leds;
		interface Timer<TMilli> as Timer0;
	}
	
	uses{ // UserButtons
		interface Get<button_state_t>;
		interface Notify<button_state_t>;
	} 
	
	uses{ //Radio
		interface Packet;
		interface AMPacket;
		interface AMSend;
		interface SplitControl as AMControl;
		interface Receive;
	}
	
	uses{ //Others interfaces
		interface Random;
	} 
}

implementation{
	
	bool _radioBusy = FALSE;
	message_t _packet;
	
	void debug_logger(uint8_t type, const char* function, const char* text){
		if (PRINT_DEBUG_MSG){
			switch (type) {
				case DEBUG_MSG_CRITICAL_ERROR_TYPE:
					if(PRINT_DEBUG_CRITICAL_ERROR_MSG)
						printf("[DEBUG][CRITICAL_ERROR][%s] %s\r\n", function, text);
				break;
				case DEBUG_MSG_ERROR_TYPE:
					if(PRINT_DEBUG_ERROR_MSG)
						printf("[DEBUG][ERROR][%s] %s\r\n", function, text);
				break;
				case DEBUG_MSG_WARNING_TYPE:
					if(PRINT_DEBUG_WARNING_MSG)
						printf("[DEBUG][WARNING][%s] %s\r\n", function, text);
				break;
				case DEBUG_MSG_INFO_TYPE:
					if(PRINT_DEBUG_INFO_MSG)
						printf("[DEBUG][INFO][%s] %s\r\n", function, text);
				break;
				default:
					break;
			}
		}		
	}
	
	event void Boot.booted(){
		debug_logger(DEBUG_MSG_INFO_TYPE, "Boot.booted", "Initing Button event...");
		call Notify.enable(); //Button event
		debug_logger(DEBUG_MSG_INFO_TYPE, "Boot.booted", "Initing Radio...");
		call AMControl.start(); //Start Radio
	}
	
	event void Notify.notify(button_state_t val){
		if (_radioBusy == FALSE){
			//Creating the packet
			MoteToMoteMsg_t* msg = call Packet.getPayload(& _packet, sizeof(MoteToMoteMsg_t));
			msg->NodeId = TOS_NODE_ID;
			msg->Data = (uint8_t) val;		
			
			//Sending the packet
			if (call AMSend.send(AM_BROADCAST_ADDR, & _packet, sizeof(MoteToMoteMsg_t)) == SUCCESS){
				_radioBusy = TRUE;
			}
		}		
	}

	event void AMSend.sendDone(message_t *msg, error_t error){
		if(msg == &_packet){
			_radioBusy = FALSE;
		}
	}
	
	event void AMControl.startDone(error_t error){
		if(error == SUCCESS){
			call Leds.led0On();
			if (MOTE_TYPE == SENDER){
				call Timer0.startPeriodic(TIMER_PERIOD_MILLI);	
			}
		} else {
			call AMControl.start();
		}
		// TODO Auto-generated method stub
	}
	event void AMControl.stopDone(error_t error){
		// TODO Auto-generated method stub
	}
		

	event message_t * Receive.receive(message_t *msg, void *payload, uint8_t len){
		char debug_text[50];			
		// TODO Auto-generated method stub
		if(len == sizeof(MoteToMoteMsg_t)){
			MoteToMoteMsg_t * incomingPacket = (MoteToMoteMsg_t*) payload;
			
			//incomingPacket->NodeId == 2
			uint16_t node_id = incomingPacket->NodeId;
			uint8_t data = incomingPacket->Data;
			sprintf(debug_text, "Message received from [Node:%d] Data:%d", node_id, data);					
			debug_logger(DEBUG_MSG_INFO_TYPE, "Receive.receive", debug_text);
			
									
			if(data == 1){
				call Leds.led2On();
			} 
			if(data == 0){
				call Leds.led2Off();
			}
		}
		return msg;
	}

	event void Timer0.fired(){
		if (_radioBusy == FALSE){
			//Creating the packet
			MoteToMoteMsg_t* msg = call Packet.getPayload(& _packet, sizeof(MoteToMoteMsg_t));
			msg->NodeId = TOS_NODE_ID;
			msg->Data = (uint8_t) ( call Random.rand16() % 2);
			
			//Sending the packet
			if (call AMSend.send(AM_BROADCAST_ADDR, & _packet, sizeof(MoteToMoteMsg_t)) == SUCCESS){
				_radioBusy = TRUE;
			}	
		}	
	}
}