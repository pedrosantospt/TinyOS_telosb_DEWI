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
#ifndef MOTE_TO_MOTE_H
#define MOTE_TO_MOTE_H

typedef nx_struct MoteToMoteMsg{
	nx_uint16_t NodeId;
	nx_uint8_t Data;
} MoteToMoteMsg_t;

enum{
	AM_RADIO = 6
};

enum {
   TIMER_PERIOD_MILLI = 1000
 };


//DEBUG MSG types
enum {
	DEBUG_MSG_CRITICAL_ERROR_TYPE,
	DEBUG_MSG_ERROR_TYPE,
	DEBUG_MSG_WARNING_TYPE,
	DEBUG_MSG_INFO_TYPE	
};

//MOTE types
enum {
	RECEIVER,
	SENDER
};

#define MOTE_TYPE		RECEIVER


//DEBUG Preferences
#define PRINT_DEBUG_MSG 				1
#define PRINT_DEBUG_CRITICAL_ERROR_MSG 	1
#define PRINT_DEBUG_ERROR_MSG 			1
#define PRINT_DEBUG_WARNING_MSG 		1
#define PRINT_DEBUG_INFO_MSG 			1



#endif /* MOTE_TO_MOTE_H */
