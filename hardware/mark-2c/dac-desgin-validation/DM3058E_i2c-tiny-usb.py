import usbtmc
import smbus
import time
import numpy
import math

instr =  usbtmc.Instrument(6833, 1416)

dac0_addr = 0x0d
dac1_addr = 0x0c

dac_a = 0x01
dac_b = 0x02

i2c_bus = smbus.SMBus(0)

for i in range(0,256):
	it = numpy.uint8(i)
	higher = numpy.uint8(it >> 4)
	lower  = numpy.uint8(it << 4)
	#add the first 4 bits to 1st data DAC data byte
	higher = numpy.uint8( higher + 0x20)
	#print "in: 0x%X higher: 0x%X lower: 0x%X" % (it,numpy.int_(higher),numpy.int_(lower))
	dac_data = [numpy.int_(higher),numpy.int_(lower)]
	i2c_bus.write_i2c_block_data(dac0_addr,0x01,dac_data)
	time.sleep(5)
	dc_volt = float(instr.ask_raw("MEASure:VOLTage:DC?"))
	dB = dc_volt / 0.0061
	dB_round = round(dB,2)
	print "DAC: %d 0x%X V: %f dB: %f %3.1f" % (i,i,dc_volt,dB,dB_round)
