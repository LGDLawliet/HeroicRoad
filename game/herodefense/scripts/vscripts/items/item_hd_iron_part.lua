item_hd_iron_part = class({})

LinkLuaModifier("modifier_item_hd_iron_part", "items/item_hd_iron_part", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_iron_part_already", "items/item_hd_iron_part", LUA_MODIFIER_MOTION_NONE)

require('internal/timers')   --计时器功能
function item_hd_iron_part:GetIntrinsicModifierName()
	return "modifier_item_hd_iron_part"
end

function item_hd_iron_part:OnSpellStart()
	if not IsServer() then
		return
	end
	local already = self:GetCaster():FindModifierByName("modifier_item_hd_iron_part_already")
	if already then
		return
	end
	local caster =  self:GetCaster()
	local pos = caster:GetAbsOrigin()
	local item_10,item_11,item_12-------------至高唤风强弩
	local item_20,item_21,item_22-------------至高血斧·地狱威吓
	local item_30,item_31,item_32-------------至高风暴狂潮之戟
	local item_40,item_41,item_42-------------至高野客芳草项链

	local current_item_0 = caster:GetItemInSlot(0)
	local current_item_1 = caster:GetItemInSlot(1)
	local current_item_2 = caster:GetItemInSlot(2)
	if current_item_0 and current_item_1 and current_item_2 then
		local name_0 = current_item_0:GetAbilityName()
		local name_1 = current_item_1:GetAbilityName()
		local name_2 = current_item_2:GetAbilityName()

		if name_0 == "item_hd_ballista" then-------------至高唤风强弩
			item_10 = true
			if name_1 =="item_hd_bfury_plus" then-------------至高唤风强弩
				item_11 = true
				if name_2 =="item_hd_wind_waker" then-------------至高唤风强弩
					item_12 = true
				end
			end
		end

		if name_0 == "item_hd_blood_bug_barrier" then-------------至高血斧·地狱威吓
			item_20 = true
			if name_1 =="item_hd_remnant_sun_prison_garb" then-------------至高血斧·地狱威吓
				item_21 = true
				if name_2 =="item_hd_reaver" then-------------至高血斧·地狱威吓
					item_22 = true
				end
			end
		end

		if name_0 == "item_hd_thunder" then-------------至高风暴狂潮之戟
			item_30 = true
			if name_1 =="item_hd_shisui" then-------------至高风暴狂潮之戟
				item_31 = true
				if name_2 =="item_hd_trident" then-------------至高风暴狂潮之戟
					item_32 = true
				end
			end
		end

		if name_0 == "item_hd_rose_scepter" then-------------至高野客芳草项链
			item_40 = true
			if name_1 =="item_hd_holy_locket" then-------------至高野客芳草项链
				item_41 = true
				if name_2 =="item_hd_remnant_spirit_of_the_ancient_tree" then-------------至高野客芳草项链
					item_42 = true
				end
			end
		end
	end
	----------------------------------------------------------------------------------------------------------------------------出货分割线--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	if item_10 and item_11 and item_12 then-------------至高唤风强弩
		local particle_main_fx = ParticleManager:CreateParticle("particles/rebuild/iron_part/active.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(particle_main_fx, 0, pos)
		ParticleManager:SetParticleControlEnt(particle_main_fx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", pos, true)
		ParticleManager:SetParticleControlEnt(particle_main_fx, 2, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", pos, true)
		ParticleManager:ReleaseParticleIndex(particle_main_fx)
		for i = 1, 10, 1 do
			Timers:CreateTimer(RandomFloat(0.1, 0.5), function()
				local vDir = Vector(RandomFloat(-1, 1),RandomFloat(-1, 1),0)
				vDir.z = 0
				vDir = vDir:Normalized()
				local pos_0 = caster:GetAbsOrigin() +Vector(RandomInt(-200, 200),RandomInt(-200, 200),0)
				local particle_main_fx = ParticleManager:CreateParticle("particles/rebuild/iron_part/active.vpcf", PATTACH_ABSORIGIN, caster)
				ParticleManager:SetParticleControl(particle_main_fx, 0, pos_0)
				ParticleManager:SetParticleControlEnt(particle_main_fx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", pos_0, true)
				ParticleManager:SetParticleControlEnt(particle_main_fx, 2, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", pos_0, true)
				ParticleManager:ReleaseParticleIndex(particle_main_fx)
				caster:EmitSoundParams("Hero_Sven.GodsStrength", 0, 0.2, 0 )
			end)
		end

		caster:GameTimer(0.6,function ()
			UTIL_RemoveImmediate(current_item_0) 
			UTIL_RemoveImmediate(current_item_1) 
			UTIL_RemoveImmediate(current_item_2) 
			self:GetCaster():AddItemByName("item_hd_wind_blaster")-------------至高唤风强弩
			caster:AddNewModifier(caster,self,"modifier_item_hd_iron_part_already",{})
			UTIL_RemoveImmediate(self)
		end)
	end



	if item_20 and item_21 and item_22 then-------------至高血斧·地狱威吓
		local particle_main_fx = ParticleManager:CreateParticle("particles/rebuild/iron_part/active.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(particle_main_fx, 0, pos)
		ParticleManager:SetParticleControlEnt(particle_main_fx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", pos, true)
		ParticleManager:SetParticleControlEnt(particle_main_fx, 2, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", pos, true)
		ParticleManager:ReleaseParticleIndex(particle_main_fx)
		for i = 1, 10, 1 do
			Timers:CreateTimer(RandomFloat(0.1, 0.5), function()
				local vDir = Vector(RandomFloat(-1, 1),RandomFloat(-1, 1),0)
				vDir.z = 0
				vDir = vDir:Normalized()
				local pos_0 = caster:GetAbsOrigin() +Vector(RandomInt(-200, 200),RandomInt(-200, 200),0)
				local particle_main_fx = ParticleManager:CreateParticle("particles/rebuild/iron_part/active.vpcf", PATTACH_ABSORIGIN, caster)
				ParticleManager:SetParticleControl(particle_main_fx, 0, pos_0)
				ParticleManager:SetParticleControlEnt(particle_main_fx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", pos_0, true)
				ParticleManager:SetParticleControlEnt(particle_main_fx, 2, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", pos_0, true)
				ParticleManager:ReleaseParticleIndex(particle_main_fx)
				caster:EmitSoundParams("Hero_Sven.GodsStrength", 0, 0.2, 0 )
			end)
		end

		caster:GameTimer(0.6,function ()
			UTIL_RemoveImmediate(current_item_0) 
			UTIL_RemoveImmediate(current_item_1) 
			UTIL_RemoveImmediate(current_item_2) 
			self:GetCaster():AddItemByName("item_hd_infernal_menace")-------------至高血斧·地狱威吓
			caster:AddNewModifier(caster,self,"modifier_item_hd_iron_part_already",{})
			UTIL_RemoveImmediate(self)
		end)
	end
	

	if item_30 and item_31 and item_32 then-------------至高风暴狂潮之戟
		local particle_main_fx = ParticleManager:CreateParticle("particles/rebuild/iron_part/active.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(particle_main_fx, 0, pos)
		ParticleManager:SetParticleControlEnt(particle_main_fx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", pos, true)
		ParticleManager:SetParticleControlEnt(particle_main_fx, 2, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", pos, true)
		ParticleManager:ReleaseParticleIndex(particle_main_fx)
		for i = 1, 10, 1 do
			Timers:CreateTimer(RandomFloat(0.1, 0.5), function()
				local vDir = Vector(RandomFloat(-1, 1),RandomFloat(-1, 1),0)
				vDir.z = 0
				vDir = vDir:Normalized()
				local pos_0 = caster:GetAbsOrigin() +Vector(RandomInt(-200, 200),RandomInt(-200, 200),0)
				local particle_main_fx = ParticleManager:CreateParticle("particles/rebuild/iron_part/active.vpcf", PATTACH_ABSORIGIN, caster)
				ParticleManager:SetParticleControl(particle_main_fx, 0, pos_0)
				ParticleManager:SetParticleControlEnt(particle_main_fx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", pos_0, true)
				ParticleManager:SetParticleControlEnt(particle_main_fx, 2, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", pos_0, true)
				ParticleManager:ReleaseParticleIndex(particle_main_fx)
				caster:EmitSoundParams("Hero_Sven.GodsStrength", 0, 0.2, 0 )
			end)
		end

		caster:GameTimer(0.6,function ()
			UTIL_RemoveImmediate(current_item_0) 
			UTIL_RemoveImmediate(current_item_1) 
			UTIL_RemoveImmediate(current_item_2) 
			self:GetCaster():AddItemByName("item_hd_the_trident_of_the_sunken_treasure_house")-------------至高风暴狂潮之戟
			caster:AddNewModifier(caster,self,"modifier_item_hd_iron_part_already",{})
			UTIL_RemoveImmediate(self)
		end)
	end


	if item_40 and item_41 and item_42 then-------------至高野客芳草项链
		local particle_main_fx = ParticleManager:CreateParticle("particles/rebuild/iron_part/active.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(particle_main_fx, 0, pos)
		ParticleManager:SetParticleControlEnt(particle_main_fx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", pos, true)
		ParticleManager:SetParticleControlEnt(particle_main_fx, 2, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", pos, true)
		ParticleManager:ReleaseParticleIndex(particle_main_fx)
		for i = 1, 10, 1 do
			Timers:CreateTimer(RandomFloat(0.1, 0.5), function()
				local vDir = Vector(RandomFloat(-1, 1),RandomFloat(-1, 1),0)
				vDir.z = 0
				vDir = vDir:Normalized()
				local pos_0 = caster:GetAbsOrigin() +Vector(RandomInt(-200, 200),RandomInt(-200, 200),0)
				local particle_main_fx = ParticleManager:CreateParticle("particles/rebuild/iron_part/active.vpcf", PATTACH_ABSORIGIN, caster)
				ParticleManager:SetParticleControl(particle_main_fx, 0, pos_0)
				ParticleManager:SetParticleControlEnt(particle_main_fx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", pos_0, true)
				ParticleManager:SetParticleControlEnt(particle_main_fx, 2, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", pos_0, true)
				ParticleManager:ReleaseParticleIndex(particle_main_fx)
				caster:EmitSoundParams("Hero_Sven.GodsStrength", 0, 0.2, 0 )
			end)
		end

		caster:GameTimer(0.6,function ()
			UTIL_RemoveImmediate(current_item_0) 
			UTIL_RemoveImmediate(current_item_1) 
			UTIL_RemoveImmediate(current_item_2) 
			self:GetCaster():AddItemByName("item_hd_flower_locket")-------------至高野客芳草项链
			caster:AddNewModifier(caster,self,"modifier_item_hd_iron_part_already",{})
			UTIL_RemoveImmediate(self)
		end)
	end
end

-------------------------------------
modifier_item_hd_iron_part = advanced_modifier({})

function modifier_item_hd_iron_part:IsDebuff() return false end
function modifier_item_hd_iron_part:IsHidden() return true end
function modifier_item_hd_iron_part:IsPurgable() return false end 

function modifier_item_hd_iron_part:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_atb = self.ability:GetSpecialValueFor("bonus_atb")
end

function modifier_item_hd_iron_part:OnRefresh(keys)
	self.ability = self:GetAbility()
	self.bonus_atb = self.ability:GetSpecialValueFor("bonus_atb")
end

function modifier_item_hd_iron_part:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
end

--基础属性
function modifier_item_hd_iron_part:Advanced_GetModifierBonusStats_Strength()
	return self.bonus_atb 
end
function modifier_item_hd_iron_part:Advanced_GetModifierBonusStats_Agility()
	return self.bonus_atb
end
function modifier_item_hd_iron_part:Advanced_GetModifierBonusStats_Intellect()
	return self.bonus_atb 
end

-------------------------------------
modifier_item_hd_iron_part_already = advanced_modifier({})

function modifier_item_hd_iron_part_already:IsDebuff() return false end
function modifier_item_hd_iron_part_already:IsHidden() return true end
function modifier_item_hd_iron_part_already:IsPurgable() return false end 
function modifier_item_hd_iron_part_already:RemoveOnDeath() return false end 