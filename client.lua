local data = {0x23, 0xCB, 0x26, 0x01, 0x00, 0x20, 0x08, 0x05, 0x30, 0x45, 0x67, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0B}
      --         1     2     3     4     5     6     7     8     9    10    11    12    13    14    15    16    17    18
      --      ####       HEADER       ####    ON  MODE  TEMP  MODE   FAN  CLCK  STME  ETME   TMR  CNST  CNST  CNST  CHKS
local fields = {'HDR0', 'HDR1', 'HDR2', 'HDR3', 'HDR4', 'ONOF', 'MODE', 'TEMP', 'MODE', 'FANN', 'CLCK', 'STME', 'ETME', 'TMRR', 'CNST', 'CNST', 'CNST', 'CHKS'}
local HVAC_HOT  = 0
local HVAC_COLD = 1
local HVAC_DRY  = 2
local HVAC_AUTO = 3

local FAN_SPEED_1      = 0
local FAN_SPEED_2      = 1
local FAN_SPEED_3      = 2
local FAN_SPEED_4      = 3
local FAN_SPEED_5      = 4
local FAN_SPEED_AUTO   = 5
local FAN_SPEED_SILENT = 6

local VANNE_AUTO      = 0
local VANNE_H1        = 1
local VANNE_H2        = 2
local VANNE_H3        = 3
local VANNE_H4        = 4
local VANNE_H5        = 5
local VANNE_AUTO_MOVE = 6

local OFF = false
local HVAC_Mode      = HVAC_HOT
local HVAC_TEMP      = 23
local HVAC_FanMode   = FAN_SPEED_1
local HVAC_VanneMode = VANNE_AUTO_MOVE

-- ON/OFF
if OFF then	data[6] = 0xFF
else        data[6] = 0x20
end

-- HVAC MODE
if     HVAC_Mode == HVAC_HOT  then data[7] = 0x08
elseif HVAC_Mode == HVAC_COLD then data[7] = 0x18
elseif HVAC_Mode == HVAC_DRY  then data[7] = 0x10
elseif HVAC_Mode == HVAC_AUTO then data[7] = 0x20
end

-- Temperature setting
if     HVAC_TEMP > 31 then Temp = 31
elseif HVAC_TEMP < 16 then Temp = 16	
else 
	Temp = HVAC_TEMP
	data[8] = Temp - 16
end

-- Fan setting
if     HVAC_FanMode == FAN_SPEED_1      then data[10] = 0x01
elseif HVAC_FanMode == FAN_SPEED_2      then data[10] = 0x02
elseif HVAC_FanMode == FAN_SPEED_3      then data[10] = 0x03
elseif HVAC_FanMode == FAN_SPEED_4      then data[10] = 0x04
elseif HVAC_FanMode == FAN_SPEED_5      then data[10] = 0x04
elseif HVAC_FanMode == FAN_SPEED_AUTO   then data[10] = 0x80
elseif HVAC_FanMode == FAN_SPEED_SILENT then data[10] = 0x05
end

-- Vanne setting
if     HVAC_VanneMode == VANNE_AUTO      then data[10] = bit.bor(data[10], 0x40)
elseif HVAC_VanneMode == VANNE_H1        then data[10] = bit.bor(data[10], 0x48)
elseif HVAC_VanneMode == VANNE_H2        then data[10] = bit.bor(data[10], 0x28)
elseif HVAC_VanneMode == VANNE_H3        then data[10] = bit.bor(data[10], 0x58)
elseif HVAC_VanneMode == VANNE_H4        then data[10] = bit.bor(data[10], 0x60)
elseif HVAC_VanneMode == VANNE_H5        then data[10] = bit.bor(data[10], 0x68)
elseif HVAC_VanneMode == VANNE_AUTO_MOVE then data[10] = bit.bor(data[10], 0x78)
end

-- Calculate checksum (actually sum over all previous bytes)
local CHECKSUM = 0
for i=1, 17 do
  CHECKSUM = CHECKSUM + data[i]
end
data[18] = bit.band(CHECKSUM, 0xFF)

-- Print for debugging
for i=1, 18 do
	print(fields[i]..' : '..string.format('0x%02X',data[i]))
end

-- Send infrared signals
dofile("irsend.lua").mitsubishi(4, data)