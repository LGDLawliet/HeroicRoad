LinkLuaModifier("modifier_item_new_bottle_heal", "items/item_new_bottle", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_new_bottle_invisibility", "items/item_new_bottle", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_phoenix_2_buff", "heroTalent/heroTalent_npc_dota_hero_phoenix_2", LUA_MODIFIER_MOTION_NONE )


item_new_bottle = item_new_bottle or class({})

function item_new_bottle:Spawn()
	if not IsServer() then
		return
	end
	self:SetCurrentCharges(3)
	self.max_charge = 3
end

HERO_USED_BOTTLE_MUSIC = {
    "soundboard.lai_ni_da ",
    "soundboard.lian_dou_xiu_wai_la",
    "soundboard.oy_oy_bezhat",
    "announcer_dlc_bastion_announcer_event_store_bottle",  --sometime u just need to drink
}
_G.GAME_PLAY_MUSIC_BOTTLE = 0


function item_new_bottle:OnSpellStart()
	if not IsServer() then
		return
	end

	local caster = self:GetCaster()
	local charges = self:GetCurrentCharges()
	local duration = self:GetSpecialValueFor("duration")
	
	if charges > 0 then
		local target = self:GetCursorTarget()
		---print("adasfrgoiwfneod"..tostring(self:GetCaster():FindModifierByName(self.modifiername)))
		--魔瓶系列5
		local bottle_5 = self:GetCaster():FindModifierByName("modifier_item_new_bottle_5")
		if bottle_5 then
			target:AddNewModifier(caster, self, "modifier_item_new_bottle_5_active", {duration = duration})
		end
		--魔瓶系列4
		local bottle_4 = self:GetCaster():FindModifierByName("modifier_item_new_bottle_4")
		if bottle_4 then
			duration = 6
			target:AddNewModifier(caster, self, "modifier_item_new_bottle_4_active", {duration = duration})
		end
		--魔瓶系列3
		local bottle_3 = self:GetCaster():FindModifierByName("modifier_item_new_bottle_3")
		if bottle_3 then
			target:AddNewModifier(caster, self, "modifier_item_new_bottle_3_active", {duration = duration})
		end
		--魔瓶系列2
		local bottle_2 = self:GetCaster():FindModifierByName("modifier_item_new_bottle_2")
		if bottle_2 then
			duration = 20
		end
		--魔瓶系列1
		local bottle_1 = self:GetCaster():FindModifierByName("modifier_item_new_bottle_1")
		if bottle_1 then
			duration = 2
		end


		--施加恢复
		self.bottle_heal_modifier = target:AddNewModifier(caster, self, "modifier_item_new_bottle_heal", {duration = duration})

		RunModelModify(self,"OnSpellStart")





		if target==caster and caster:HasModifier("modifier_item_hd_bottle_invisibility") then
			caster:AddNewModifier(caster, self, "modifier_item_new_bottle_invisibility", {duration = 2})
		end

		local modifier = caster:FindModifierByName("modifier_heroTalent_npc_dota_hero_phoenix_2")
		if modifier then
			local ability = modifier:GetAbility()
			if ability then
				target:AddNewModifier(ability:GetCaster(), ability, "modifier_heroTalent_npc_dota_hero_phoenix_2_buff", {duration = 90})
			end
			
		end

		self:SetCurrentCharges(charges - 1)

		caster:EmitSound("Bottle.Drink")

		if  _G.GAME_PLAY_MUSIC_BOTTLE == 0 then
			_G.GAME_PLAY_MUSIC_BOTTLE = 1
			caster:EmitSound(HERO_USED_BOTTLE_MUSIC[RandomInt(1, 3)])
			Timers:CreateTimer(7, function()
				_G.GAME_PLAY_MUSIC_BOTTLE = 0
			end)
		end
	end
	
end



function item_new_bottle:GetAbilityTextureName()
	local charge = self:GetCurrentCharges()
	local texture = "item_bottle"
	if  charge==0 then
		texture = "item_bottle_empty"
    elseif charge==1 then
		texture = "item_bottle_small"
	elseif charge==2 then
		texture = "item_bottle_medium"
	end
	return texture
end

function item_new_bottle:GetBottleMaxCharge()
	return self.max_charge
end


--------------------------------------------------------------------------------------------------
modifier_item_new_bottle_heal = modifier_item_new_bottle_heal or advanced_modifier({})

function modifier_item_new_bottle_heal:IsPurgable()return false end
function modifier_item_new_bottle_heal:IsPurgeException()return false end
function modifier_item_new_bottle_heal:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_new_bottle_heal:GetEffectAttachType()return PATTACH_ABSORIGIN_FOLLOW end
function modifier_item_new_bottle_heal:GetTexture()return "item_bottle" end


function modifier_item_new_bottle_heal:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:SafeDestroy() end
    end
	if not IsServer() then
		return 
	end

	local parent = self:GetParent()
	local caster = self:GetCaster()
	self.heal = self:GetAbility():GetSpecialValueFor("health_restore_pct")
	self.mana = self:GetAbility():GetSpecialValueFor("mana_restore_pct")
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
	self.mul = self.mul or 1
	--魔瓶系列5
	local bottle_5 = self:GetCaster():FindModifierByName("modifier_item_new_bottle_5")
	if bottle_5 then
		self.heal = 20
		self.mana = 10
	end
	--魔瓶系列4
	local bottle_4 = self:GetCaster():FindModifierByName("modifier_item_new_bottle_4")
	if bottle_4 then
		self.duration = 6
	end
	--魔瓶系列3
	local bottle_3 = self:GetCaster():FindModifierByName("modifier_item_new_bottle_3")
	if bottle_3 then
		self.heal = 20
		self.mana = 10
	end
	--魔瓶系列2
	local bottle_2 = self:GetCaster():FindModifierByName("modifier_item_new_bottle_2")
	if bottle_2 then
		self.heal = 60
		self.mana = 40
		self.duration = 20
	end
	--魔瓶系列1
	local bottle_1 = self:GetCaster():FindModifierByName("modifier_item_new_bottle_1")
	if bottle_1 then
		self.heal = 30
		self.mana = 15
		self.duration = 2
	end
	--恢复数值
	self.health_restore = self.heal *parent:GetMaxHealth()*0.01*self.mul/ self.duration
	self.mana_restore = self.mana *parent:GetMaxMana()*0.01*self.mul/ self.duration


	--装备效果 魔瓶充盈
	if caster.hd_bottle_water then
		self.health_restore = self.health_restore*caster.hd_bottle_water
		self.mana_restore = self.mana_restore*caster.hd_bottle_water
	end

	self:SetHasCustomTransmitterData( true )

	local particle = "particles/items_fx/bottle.vpcf"
	if caster:HasModifier("modifier_item_hd_phoenix_ring") or caster:HasModifier("modifier_item_hd_phoenix_ring_active") then
		particle = "particles/econ/events/fall_2022/bottle/bottle_fall2022.vpcf"
	end
	self.pfx = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, parent)
end

function modifier_item_new_bottle_heal:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		advanced_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT

    }
end
function modifier_item_new_bottle_heal:AdvancedGetModifierConstantHealthRegen() return self.health_restore end
function modifier_item_new_bottle_heal:AdvancedGetModifierConstantManaRegen() return self.mana_restore end


function modifier_item_new_bottle_heal:OnDestroy()
	if not IsServer() then return end
	ParticleManager:DestroyParticle(self.pfx, false)
	ParticleManager:ReleaseParticleIndex(self.pfx)
end


function modifier_item_new_bottle_heal:AddCustomTransmitterData( )
	return
	{
		health_restore = self.health_restore,
		mana_restore = self.mana_restore
	}
end

function modifier_item_new_bottle_heal:HandleCustomTransmitterData( data )
	self.health_restore = data.health_restore
	self.mana_restore = data.mana_restore
end

















------------------------------------------
modifier_item_new_bottle_invisibility = class({})

function modifier_item_new_bottle_invisibility:IsDebuff() return false end
function modifier_item_new_bottle_invisibility:IsHidden() return false end
function modifier_item_new_bottle_invisibility:IsPurgable() return false end
function modifier_item_new_bottle_invisibility:GetTexture()return "item_bottle" end



function modifier_item_new_bottle_invisibility:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
		-- MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,     --移动速度百分比
	}
end


function modifier_item_new_bottle_invisibility:GetModifierInvisibilityLevel()return 1 end

function modifier_item_new_bottle_invisibility:CheckState()
	local state = {
		[MODIFIER_STATE_INVISIBLE] = true,
		-- [MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
	return state
end

-- function modifier_item_new_bottle_invisibility:GetModifierMoveSpeedBonus_Percentage()		return 20	end

function modifier_item_new_bottle_invisibility:OnAttack(params)
	if IsServer() then
		if params.attacker == self:GetParent() then
			self:SafeDestroy()
		end
	end
end

function modifier_item_new_bottle_invisibility:OnAbilityExecuted( keys )
	if IsServer() then
		local parent =	self:GetParent()
		if keys.unit == parent then
			self:SafeDestroy()
		end
	end
end
