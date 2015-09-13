------------------------------------------------------------------------------
-- IR send module
--
-- LICENCE: http://opensource.org/licenses/MIT
-- Vladimir Dronnikov <dronnikov@gmail.com>
--
-- Modified by Arne Meeuw
-- Works with Mitsubishi HVAC Machines
------------------------------------------------------------------------------
local M
do
  -- const
  local NEC_PULSE_US   = 1000000 / 38000
  
  local HVAC_MITSUBISHI_HDR_MARK   = 3400
  local HVAC_MITSUBISHI_HDR_SPACE  = 1750
  local HVAC_MITSUBISHI_BIT_MARK   = 450
  local HVAC_MITSUBISHI_ONE_SPACE  = 1300
  local HVAC_MITSUBISHI_ZERO_SPACE = 420
  local HVAC_MITSUBISHI_RPT_MARK   = 440
  local HVAC_MITSUBISHI_RPT_SPACE  = 17100 -- Above original iremote limit
  
  -- cache
  local gpio, bit = gpio, bit
  local mode, write = gpio.mode, gpio.write
  local waitus = tmr.delay
  local isset = bit.isset
  -- NB: poorman 38kHz PWM with 1/3 duty. Touch with care! )
  local carrier = function(pin, c)
    c = c / NEC_PULSE_US
    while c > 0 do
      write(pin, 1)
      write(pin, 0)
      c = c + 0
      c = c + 0
      c = c + 0
      c = c + 0
      c = c + 0
      c = c + 0
      c = c * 1
      c = c * 1
      c = c * 1
      c = c - 1
    end
  end
  -- tsop signal simulator
  local pull = function(pin, c)
    write(pin, 0)
    waitus(c)
    write(pin, 1)
  end
  -- NB: tsop mode allows to directly connect pin
  --     inplace of TSOP input
  local mitsubishi = function(pin, code, tsop)
    local pulse = tsop and pull or carrier
    -- setup transmitter
    mode(pin, 1)
    write(pin, tsop and 1 or 0)
    -- header
    pulse(pin, HVAC_MITSUBISHI_HDR_MARK)
    waitus(HVAC_MITSUBISHI_HDR_SPACE)
    -- sequence, lsb first
	
	-- Repeat whole command two times
	for j = 0, 1, 1 do
		-- Send bytes 1 to 18 in correct order
		for i = 1, 18, 1 do
			-- Send bits 1 to 8 in reverse order
			for bitpos = 0, 7, 1 do
				if bit.isset(code[i], bitpos) then
					pulse(pin, HVAC_MITSUBISHI_BIT_MARK)
					waitus(HVAC_MITSUBISHI_ONE_SPACE)
					--print(1)
				else
					pulse(pin, HVAC_MITSUBISHI_BIT_MARK)
					waitus(HVAC_MITSUBISHI_ZERO_SPACE)
					--print(0)
				end
			end
		end
		pulse(pin, HVAC_MITSUBISHI_RPT_MARK)
		waitus(HVAC_MITSUBISHI_RPT_SPACE)
	end
  end
  -- expose
  M = {
    mitsubishi = mitsubishi,
  }
end
return M
