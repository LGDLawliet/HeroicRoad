modifier_record_system_dummy = advanced_modifier({})

function modifier_record_system_dummy:IsHidden() return true end
function modifier_record_system_dummy:IsDebuff() return false end
function modifier_record_system_dummy:IsPurgable() return false end
function modifier_record_system_dummy:IsPurgeException() return false end
function modifier_record_system_dummy:AllowIllusionDuplicate() return false end
function modifier_record_system_dummy:GetPriority() return MODIFIER_PRIORITY_LOW end
function modifier_record_system_dummy:OnCreated(params)
	self:GetParent().ATTACK_SYSTEM = {}
	if IsServer() then
		self:GetParent().iLastRecord = 0
	end
end
function modifier_record_system_dummy:OnDestroy()
	if IsServer() then
		UTIL_Remove(self:GetParent())
	end
end
function modifier_record_system_dummy:CheckState()
	return {
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_NO_TEAM_MOVE_TO] = true,
		[MODIFIER_STATE_NO_TEAM_SELECT] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
	}
end
function modifier_record_system_dummy:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_RECORD,
		MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
end
function modifier_record_system_dummy:OnAttackRecord(params)
	self:GetParent().iLastRecord = params.record

	self:GetParent().ATTACK_SYSTEM[params.record] = 0

	if IsValid(params.attacker) and params.attacker.tSourceModifierEvents and params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_ATTACK_RECORD] then
		local tModifiers = params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_ATTACK_RECORD]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.attacker) and IsValid(hModifier) and hModifier.OnAttackRecord then
				hModifier:OnAttackRecord(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if IsValid(params.target) and params.target.tTargetModifierEvents and params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ATTACK_RECORD] then
		local tModifiers = params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ATTACK_RECORD]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.target) and IsValid(hModifier) and hModifier.OnAttackRecord then
				hModifier:OnAttackRecord(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_ATTACK_RECORD] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_ATTACK_RECORD]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnAttackRecord then
				hModifier:OnAttackRecord(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function modifier_record_system_dummy:OnAttackRecordDestroy(params)
	-- print("delll")
	if IsValid(params.attacker) and params.attacker.tSourceModifierEvents and params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY] then
		local tModifiers = params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.attacker) and IsValid(hModifier) and hModifier.OnAttackRecordDestroy then
				hModifier:OnAttackRecordDestroy(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if IsValid(params.target) and params.target.tTargetModifierEvents and params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY] then
		local tModifiers = params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.target) and IsValid(hModifier) and hModifier.OnAttackRecordDestroy then
				hModifier:OnAttackRecordDestroy(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnAttackRecordDestroy then
				hModifier:OnAttackRecordDestroy(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if self:GetParent().ATTACK_SYSTEM ~= nil then
		self:GetParent().ATTACK_SYSTEM[params.record] = nil
	end
end
function modifier_record_system_dummy:OnTakeDamage(params)
	local hAttacker = params.attacker
	local hTarget = params.unit

	-- if IsValid(hAttacker) and hAttacker.tSourceModifierEvents and hAttacker.tSourceModifierEvents[MODIFIER_EVENT_ON_TAKEDAMAGE] then
	-- 	local tModifiers = hAttacker.tSourceModifierEvents[MODIFIER_EVENT_ON_TAKEDAMAGE]
	-- 	for i = #tModifiers, 1, -1 do
	-- 		local hModifier = tModifiers[i]
	-- 		if IsValid(hAttacker) and IsValid(hModifier) and hModifier.OnTakeDamage then
	-- 			hModifier:OnTakeDamage(params)
	-- 		else
	-- 			table.remove(tModifiers, i)
	-- 		end
	-- 	end
	-- end
	if IsValid(hTarget) then
		if DamageFilter(params.record, EOM_DAMAGE_FLAG_SHOW_DAMAGE_NUMBER) then
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, hTarget, params.damage, nil)
		end
		if DamageFilter(params.record, EOM_DAMAGE_FLAG_SPELL_CRIT) and params.damage > 0 then
			local iNumber = math.floor(params.damage)
			local sNumber = tostring(iNumber)
			-- local fDuration = 3
			-- local vColor = Vector(0, 191, 255)
			-- FireGameEvent("custom_crit_msg", {
			-- 	victim = hTarget:entindex(),
			-- 	attacker = hAttacker:entindex(),
			-- 	damage_type = params.damage_type,
			-- 	damage = sNumber,
			-- 	scale = hTarget:GetModelScale(),
			-- })
		end
		-- if hTarget.tTargetModifierEvents and hTarget.tTargetModifierEvents[MODIFIER_EVENT_ON_TAKEDAMAGE] then
		-- 	local tModifiers = hTarget.tTargetModifierEvents[MODIFIER_EVENT_ON_TAKEDAMAGE]
		-- 	for i = #tModifiers, 1, -1 do
		-- 		local hModifier = tModifiers[i]
		-- 		if IsValid(hTarget) and IsValid(hModifier) and hModifier.OnTakeDamage then
		-- 			hModifier:OnTakeDamage(params)
		-- 		else
		-- 			table.remove(tModifiers, i)
		-- 		end
		-- 	end
		-- end
	end
	-- if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_TAKEDAMAGE] then
	-- 	local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_TAKEDAMAGE]
	-- 	for i = #tModifiers, 1, -1 do
	-- 		local hModifier = tModifiers[i]
	-- 		if IsValid(hModifier) and hModifier.OnTakeDamage then
	-- 			hModifier:OnTakeDamage(params)
	-- 		else
	-- 			table.remove(tModifiers, i)
	-- 		end
	-- 	end
	-- end

end