local buff = {
	48517, --Solar
	48518 --Lunar

function PQR_Eclipse(unit)
	for i=1,#buff do
		local direction = select(11,UnitBuffID(unit, buff[i]))
		if direction == 48517 then
			return Solar
		elseif direction ==48518
			return Lunar
		end
	end
	return false
end