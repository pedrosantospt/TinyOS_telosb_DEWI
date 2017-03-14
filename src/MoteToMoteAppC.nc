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
configuration MoteToMoteAppC{
}
implementation{
	
	//General
	components MoteToMoteC as App;
	components MainC;
	components LedsC;
			
	App.Boot -> MainC;
	App.Leds -> LedsC;
	
	//Timer
	components new TimerMilliC() as Timer0;
	App.Timer0 -> Timer0;

	//UserButton
	components UserButtonC;
	App.Get -> UserButtonC;
	App.Notify -> UserButtonC;
	
	//Serial printf
	components SerialPrintfC;
	
	//Radio Communication
	
	components ActiveMessageC;
	components new AMSenderC(AM_RADIO);
	components new AMReceiverC(AM_RADIO);
	
	App.Packet -> AMSenderC;
	App.AMPacket -> AMSenderC;
	App.AMSend -> AMSenderC;
	App.AMControl -> ActiveMessageC;
	App.Receive -> AMReceiverC;
	
	//Random
	
	components RandomC;
	
	App.Random -> RandomC;
	
}