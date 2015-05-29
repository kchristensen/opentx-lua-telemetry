local function run(event)
	function round(num, idp)
		local mult = 10 ^ (idp or 0)
		return math.floor(num * mult + 0.5) / mult
	end

	local batt_s = getValue('a2')
	local batt_v = {}
	local img_path = '/SCRIPTS/BMP/'
	local percent = 0
	local settings = getGeneralSettings()

	-- Draw LiPo Battery Info
	lcd.drawPixmap(6, 1, img_path .. 'battery.bmp')
	batt_v[2] = { low = 7.4, high = 8.4 }
	batt_v[3] = { low = 11.1, high = 12.6 }
	batt_v[4] = { low = 14.8, high = 16.8 }
	batt_v[5] = { low = 18.5, high = 21.0 }
	batt_v[6] = { low = 22.2, high = 25.2 }

	if batt_s > 3 then
		-- Only show voltage and cell count if battery is connected
		batt_t = math.ceil(batt_s / 4.25)
		percent = (batt_s - batt_v[batt_t]['low']) * (100 / (batt_v[batt_t]['high'] - batt_v[batt_t]['low']))
		lcd.drawChannel(4, 55, 'a2', LEFT)
		lcd.drawText(lcd.getLastPos() + 1, 55, batt_t .. 'S', 0)
	end

	if percent > 0 then
		local myPxX = math.floor(percent * 0.37)
		local myPxY = 11 + 37 - myPxX
		lcd.drawFilledRectangle(13, myPxY, 21, myPxX, FILL_WHITE)
	end

	for i = 36, 2, -2 do
		lcd.drawLine(14, 11 + i, 32, 11 + i, SOLID, GREY_DEFAULT)
	end

	-- Flight Mode
	lcd.drawPixmap(52, 3, img_path .. 'fm.bmp')

	if getValue(MIXSRC_SE) > 0 then
		lcd.drawText(72, 5, 'Horizon Mode', MIDSIZE)
	elseif getValue(MIXSRC_SE) == 0 then
		lcd.drawText(72, 5, 'Rate Mode', MIDSIZE)
	elseif getValue(MIXSRC_SE) < 0 then
		lcd.drawText(72, 5, 'Angle Mode', MIDSIZE)
	end

	-- Flight Timer
	lcd.drawPixmap(110, 24, img_path .. 'timer.bmp')
	lcd.drawTimer(130, 26, getValue('timer2'), LEFT + MIDSIZE)

	-- Arm Status
	if getValue(MIXSRC_SA) < 0 then
		lcd.drawText(80, 45, 'ARMED', MIDSIZE)
	else
		lcd.drawText(70, 45, 'DISARMED', MIDSIZE)
	end

	-- Tx Voltage
	lcd.drawChannel(75, 26, 'tx-voltage', LEFT + MIDSIZE)

	-- Draw Tx Battery Icon
	percent = (getValue('tx-voltage') - settings.battMin) * 100 / (settings.battMax - settings.battMin)
	lcd.drawRectangle(52, 28, 15, 8)
	lcd.drawFilledRectangle(53, 29, 13, 6, GREY_DEFAULT)
	lcd.drawLine(67, 29, 67, 33, SOLID, 0)

	if (percent > 14) then lcd.drawLine(54, 30, 54, 33, SOLID, 0) end
	if (percent > 29) then lcd.drawLine(56, 30, 56, 33, SOLID, 0) end
	if (percent > 43) then lcd.drawLine(58, 30, 58, 33, SOLID, 0) end
	if (percent > 57) then lcd.drawLine(60, 30, 60, 33, SOLID, 0) end
	if (percent > 71) then lcd.drawLine(62, 30, 62, 33, SOLID, 0) end
	if (percent > 86) then lcd.drawLine(64, 30, 64, 33, SOLID, 0) end

	-- RSSI Data
	if getValue('rssi') > 0 then
		percent = round(((math.log(getValue('rssi') - 28, 10) - 1) / (math.log(72, 10) - 1)) * 100, -1)
	else
		percent = 0
	end
	lcd.drawPixmap(164, 1, img_path .. 'rssi_' .. percent .. '.bmp')
	lcd.drawChannel(178, 55, 'rssi', LEFT)
	lcd.drawText(lcd.getLastPos(), 56, 'dB', SMLSIZE)
end

return { run=run }
