img_path = '/SCRIPTS/TELEMETRY/BMP/'
percent = 0
settings = getGeneralSettings()

-- define your gauge scala here, currently setup for lipo cells
batteryminv = 3.46
batterymaxv = 4.26

liposensor1 = "Cels"
receiverVoltage = "RxBt"
--transmitterVoltage =  "tx-voltage" --Currently broken in OpenTX 2.1.7 OpenTX Issue #1836
transmitterVoltage = receiverVoltage -- So let us display th receiverVoltage instead
rssi = "RSSI"
armswitch = "sh"

local function init()
	
end

local function background()
  -- GetData from RxBt
  RxBt = getValue(getTelemetryId(receiverVoltage))
  -- GetData from tx-voltage
  TxBt = getValue(getTelemetryId(transmitterVoltage))
  -- GetData from RSSI
  RSSI = getValue(getTelemetryId(rssi))
  -- GetData from Lipo Sensor 1 - Cells 1-6
  cellResult1 = getValue(getTelemetryId(liposensor1))
  -- GetData flightmode from model
  flightmode, flightmodename = getFlightMode()
  -- GetData from timer 1
  timer1 = model.getTimer(0);
  -- GetData from SH switch (ARM Status)
  armstatus = getValue(armswitch)
end

local function run(event)
	background()
	lcd.clear()
	
-- Battery Voltage
	lcd.drawPixmap(6, 1, img_path .. 'battery.bmp')	
	FLV1voltage = 0
	FLV1cellcount = 0
	  if (type(cellResult1) == "table") then
		for i, v in ipairs(cellResult1) do
		  FLV1voltage = FLV1voltage + v
		  FLV1cellcount = FLV1cellcount + 1
		end
		lcd.drawText(4, 55, round(FLV1voltage,1) .. 'V') -- Voltage of liposensor 1
		lcd.drawText(lcd.getLastPos() + 1, 55, ' | ' .. FLV1cellcount .. 'S', 0)
	  end
		
	-- Calculate low & high voltage of battery pack
	celminv = FLV1cellcount * batterymaxv
	celmaxv = FLV1cellcount * batteryminv	
	percent = setGaugeFill(FLV1voltage, celminv, celmaxv)
		
	if percent > 0 then
		local myPxX = math.floor(percent * 0.37)
		local myPxY = 11 + 37 - myPxX
		lcd.drawFilledRectangle(13, myPxY, 21, myPxX, FILL_WHITE)
	end
	
	for i = 36, 2, -2 do
		lcd.drawLine(14, 11 + i, 32, 11 + i, SOLID, GREY_DEFAULT)
	end
	
	-- Draw percent on battery picture
	if percent == 100 then
		lcd.drawText(16, 25, percent, INVERS)
	elseif percent > 40 then
		lcd.drawText(19, 25, percent, INVERS)
	else
		lcd.drawText(19, 25, percent, 0)		
	end
	
-- Flight Mode
	lcd.drawPixmap(52, 3, img_path .. 'fm.bmp')
	if flightmode == 0 then
		lcd.drawText(72, 5, flightmodename, MIDSIZE)
	elseif flightmode == 1 then
		lcd.drawText(72, 5, flightmodename, MIDSIZE)
	elseif flightmode == 2 then
		lcd.drawText(72, 5, flightmodename, MIDSIZE)
	elseif flightmode == 3 then
		lcd.drawText(72, 5, flightmodename, MIDSIZE)
	else
		lcd.drawText(72, 5, 'Not defined', MIDSIZE)
	end

-- Flight Timer
	lcd.drawPixmap(110, 24, img_path .. 'timer.bmp')
	lcd.drawTimer(130, 26, timer1.value , LEFT + MIDSIZE)

-- Arm Status
	if armstatus > 0 then
		lcd.drawText(80, 45, 'ARMED', MIDSIZE)
	else
		lcd.drawText(70, 45, 'DISARMED', MIDSIZE)
	end

-- Transmitter Voltage
	lcd.drawChannel(75, 26, "TxBt", LEFT + MIDSIZE)
	percent = (TxBt - settings['battMin']) * 100 / (settings['battMax'] - settings.battMin)	
	lcd.drawFilledRectangle(53, 29, 13, 6, GREY_DEFAULT) --Battery inline
	lcd.drawRectangle(52, 28, 15, 8) --Battery outline
	lcd.drawLine(67, 29, 67, 33, SOLID, 0) --Battery header
	
	-- Battery voltage indicator lines
	if (percent > 14) then lcd.drawLine(54, 30, 54, 33, SOLID, 0) end
	if (percent > 29) then lcd.drawLine(56, 30, 56, 33, SOLID, 0) end
	if (percent > 43) then lcd.drawLine(58, 30, 58, 33, SOLID, 0) end
	if (percent > 57) then lcd.drawLine(60, 30, 60, 33, SOLID, 0) end
	if (percent > 71) then lcd.drawLine(62, 30, 62, 33, SOLID, 0) end
	if (percent > 86) then lcd.drawLine(64, 30, 64, 33, SOLID, 0) end

	-- RSSI Data
	if RSSI then
		if RSSI >= 0 then
		   percent = round(((math.log(RSSI-28, 10)-1)/(math.log(72, 10)-1))*100)
		  if percent > 90 then
			lcd.drawPixmap(164, 1, img_path .. 'rssi_100.bmp')
		  elseif percent > 80 then
			lcd.drawPixmap(164, 1, img_path .. 'rssi_90.bmp')
		  elseif percent > 70 then
			lcd.drawPixmap(164, 1, img_path .. 'rssi_80.bmp')
		  elseif percent > 60 then
			lcd.drawPixmap(164, 1, img_path .. 'rssi_70.bmp')
		  elseif percent > 50 then
			lcd.drawPixmap(164, 1, img_path .. 'rssi_60.bmp')
		  elseif percent > 40 then
			lcd.drawPixmap(164, 1, img_path .. 'rssi_50.bmp')
		  elseif percent > 30 then
			lcd.drawPixmap(164, 1, img_path .. 'rssi_40.bmp')
		  elseif percent > 20 then
			lcd.drawPixmap(164, 1, img_path .. 'rssi_30.bmp')
		  elseif percent > 10 then
			lcd.drawPixmap(164, 1, img_path .. 'rssi_20.bmp')
		  elseif percent > 0 then
			lcd.drawPixmap(164, 1, img_path .. 'rssi_10.bmp')
		  else
			lcd.drawPixmap(164, 1, img_path .. 'rssi_0.bmp')
		  end
		end
	end
end

function getTelemetryId(name)
  field = getFieldInfo(name)
  if getFieldInfo(name) then return field.id end
  return -1
end

function round(num, idp)
		local mult = 10 ^ (idp or 0)
		return math.floor(num * mult + 0.5) / mult
end

function setGaugeFill(voltage, minv, maxv)
  -- to get a good scale at the drawn gauge we have to do this 
  -- by example we want to have the gauge displaying 0 percent if the voltage drops below celminv
  -- the complete scala goes from celminv = 0% to celmaxv = 100%
  local percent = 100 - (voltage - minv) * (100 / (maxv - minv))
  if percent <= 0 then
    percent = 0
  elseif percent >= 100 then
    percent = 100
  else
    percent = percent
  end  
  percent = round(percent, 0)
  return percent
end

return { init=init, background=background, run=run }