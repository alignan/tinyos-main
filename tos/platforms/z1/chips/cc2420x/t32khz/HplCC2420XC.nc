/*
 * Copyright (c) 2011, Vanderbilt University
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE VANDERBILT UNIVERSITY BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE VANDERBILT
 * UNIVERSITY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE VANDERBILT UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE VANDERBILT UNIVERSITY HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
 *
 * Author: Janos Sallai
 */ 

/*
 * @author Marcin K Szczodrak <msz@cs.columbia.edu> (support for Zolertia Z1)
 */

configuration HplCC2420XC {
	provides {
		interface Resource as SpiResource;
		interface FastSpiByte;
		interface GeneralIO as CCA;
		interface GeneralIO as CSN;
		interface GeneralIO as FIFO;
		interface GeneralIO as FIFOP;
		interface GeneralIO as RSTN;
		interface GeneralIO as SFD;
		interface GeneralIO as VREN;
		interface GpioCapture as SfdCapture;
		interface GpioInterrupt as FifopInterrupt;

		interface LocalTime<TRadio> as LocalTimeRadio;
		interface Init;
		interface Alarm<TRadio,uint16_t>;
	}
}
implementation {

	components HplMsp430GeneralIOC as IO, new Msp430SpiB0C() as SpiC;

	components HplCC2420PinsC;
	CCA = HplCC2420PinsC.CCA;
	CSN = HplCC2420PinsC.CSN;
	FIFO = HplCC2420PinsC.FIFO;
	FIFOP = HplCC2420PinsC.FIFOP;
	RSTN = HplCC2420PinsC.RSTN;
	SFD = HplCC2420PinsC.SFD;
	VREN = HplCC2420PinsC.VREN;

	// spi	
	SpiResource = SpiC.Resource;
	FastSpiByte = SpiC;

	// capture
	components Msp430TimerC as TimerC;
	components new GpioCaptureC();
	GpioCaptureC.Msp430TimerControl -> TimerC.ControlB1;
	GpioCaptureC.Msp430Capture -> TimerC.CaptureB1;
	GpioCaptureC.GeneralIO -> IO.Port41;
	SfdCapture = GpioCaptureC;

  	components new Msp430InterruptC() as FifopInterruptC, HplMsp430InterruptC;
	FifopInterruptC.HplInterrupt -> HplMsp430InterruptC.Port10;
	FifopInterrupt = FifopInterruptC.Interrupt; 

	// alarm
	components new Alarm32khz16C() as AlarmC;
	Alarm = AlarmC;
	Init = AlarmC;

	// localTime
	components LocalTime32khzC;
	LocalTimeRadio = LocalTime32khzC.LocalTime;

}
