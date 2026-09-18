enigma_challenge_split = class({})
LinkLuaModifier( "modifier_enigma_challenge_split", "creeps_spell/enigma_challenge_split", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_enigma_challenge_split_buff", "creeps_spell/enigma_challenge_split", LUA_MODIFIER_MOTION_NONE )

function enigma_challenge_split:GetIntrinsicModifierName()
	return "modifier_enigma_challenge_split"
end



modifier_enigma_challenge_split = class({})

function modifier_enigma_challenge_split:IsDebuff()			return false end
function modifier_enigma_challenge_split:IsHidden() 			return true end
function modifier_enigma_challenge_split:IsPurgable() 		return false end
function modifier_enigma_challenge_split:IsPurgeException() 	return false end

function modifier_enigma_challenge_split:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK} end

function modifier_enigma_challenge_split:OnCreated(keys)
	if IsServer() then
		self.count = 0
		self.split_count = 0
	end

end

function modifier_enigma_challenge_split:OnAttack(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() or keys.target:IsBuilding() then
		return
	end
	if self.stop then
		return	
	end
	self:IncrementStackCount()

	local ability = self:GetAbility()
	local caster = self:GetCaster()
	local count = 15
	local modifier = self:GetCaster():FindModifierByName("modifier_enigma_challenge_split_buff")
	if modifier then
		count = 30
	end

	if self:GetStackCount() % count == 0 then
		-- self:GetParent():SetHealth(self:GetParent():GetMaxHealth())
		local unit = caster:SummonUnit("npc_monster_challenge_003",-1,keys.attacker:GetAbsOrigin(),nil,ability,0,caster:GetMaxHealth()*0.5,0,caster:GetDamageMax()*0.5,caster:GetPhysicalArmorValue(false)*0.5,0,0)
		unit:AddNewModifier(caster, ability, "modifier_enigma_challenge_split_buff",{})
		_G.GAME_MONSTER_TABLE[(#_G.GAME_MONSTER_TABLE )+ 1]= unit
        _G.GAME_MONSTER_TABLE_number = _G.GAME_MONSTER_TABLE_number + 1
		self.split_count = self.split_count +1
		if self.split_count>=4 then
			self.stop = true
		end
	end
end






modifier_enigma_challenge_split_buff= class({})

function modifier_enigma_challenge_split_buff:IsDebuff()			return false end
function modifier_enigma_challenge_split_buff:IsHidden() 			return false end
function modifier_enigma_challenge_split_buff:IsPurgable() 		return false end
function modifier_enigma_challenge_split_buff:IsPurgeException() 	return false end
function modifier_enigma_challenge_split_buff:DeclareFunctions() 
	return {
	MODIFIER_PROPERTY_MODEL_SCALE,
} 
end

function modifier_enigma_challenge_split_buff:GetModifierModelScale()    return -30 end