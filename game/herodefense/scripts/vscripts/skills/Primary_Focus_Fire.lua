
-- Primary_Focus_Fire = class({})
-- LinkLuaModifier("modifier_Primary_Focus_Fire_attack", "tg/tg_heros/hero_tg_windrunner/TG_focusfire.lua", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Primary_Focus_Fire_attackspeed", "tg/tg_heros/hero_tg_windrunner/TG_focusfire.lua", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Primary_Focus_Fire_bonus_attspeed", "tg/tg_heros/hero_tg_windrunner/TG_focusfire.lua", LUA_MODIFIER_MOTION_NONE)

Primary_Focus_Fire = class({})
LinkLuaModifier( "modifier_Primary_Focus_Fire", "skills/Primary_Focus_Fire", LUA_MODIFIER_MOTION_NONE )

function Primary_Focus_Fire:GetCastRange(vLocation, hTarget)
	return self:GetCaster():Script_GetAttackRange()
end
--------------------------------------------------------------------------------
-- Ability Start
function Primary_Focus_Fire:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then return end  --触发林肯
	-- this version of Focus Fire allows multiple target
	-- check existing modifiers
	local modifiers = caster:FindAllModifiersByName( "modifier_Primary_Focus_Fire" )
	for _,modifier in pairs(modifiers) do
		modifier:SafeDestroy()
	end


	local ent = target:entindex()
	-- add modifier to new targets

	local ModifierStatusGain = caster:GetModifierDurationGainIndex(0.5)
	caster:AddNewModifier(caster, self, "modifier_Primary_Focus_Fire", {duration = self:GetSpecialValueFor("duration")*ModifierStatusGain,target = ent,})
	
	-- Play effects
	local sound_cast = "Ability.Focusfire"
	EmitSoundOn( sound_cast, caster )
end
function Primary_Focus_Fire:OnProjectileHit_ExtraData(target, location, kv)
	-- print("1")
	if target~=nil then
		local caster = self:GetCaster()
		local modifier_keys = {
			duration = 0.1,
			iSpecialAttack = 1,
			iDisableApplyModifier = 0,
			iDisableCleave =1,
			iDisableSplit = 1,
	
		}
	
		local attackEffectRecord =caster:AddAttackEffectModifier(self,modifier_keys)
		caster:PerformAttack(target, false, true, true, true, false, false, true)
		if IsValid(attackEffectRecord) then
			attackEffectRecord:Destroy()
		end

	end
	-- return true
end

modifier_Primary_Focus_Fire = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Primary_Focus_Fire:IsDebuff()			return false end
function modifier_Primary_Focus_Fire:IsHidden() 			return false end
function modifier_Primary_Focus_Fire:IsPurgable() 			return false end
function modifier_Primary_Focus_Fire:IsPurgeException() 	return false end
-- function modifier_Primary_Focus_Fire:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
--------------------------------------------------------------------------------
-- Initializations
function modifier_Primary_Focus_Fire:OnCreated( kv )
	self.bonus = self:GetAbility():GetSpecialValueFor( "attack_speed" )
	self.reduction = self:GetAbility():GetSpecialValueFor( "focusfire_damage_reduction" )-100
	if not IsServer() then return end
	-- references	

	self.target = EntIndexToHScript( kv.target )  

	self:StartIntervalThink( 0 )
	self:OnIntervalThink()
end
function modifier_Primary_Focus_Fire:OnRefresh( kv )
	if not IsServer() then return end
	-- references
	self.bonus = self:GetAbility():GetSpecialValueFor( "attack_speed" )
	self.reduction = self:GetAbility():GetSpecialValueFor( "focusfire_damage_reduction" )-100
end

function modifier_Primary_Focus_Fire:OnRemoved() end
function modifier_Primary_Focus_Fire:OnDestroy() end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Primary_Focus_Fire:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_EVENT_ON_ATTACK_LANDED,}
	 end

function modifier_Primary_Focus_Fire:GetModifierAttackSpeedBonus_Constant()	
	if IsServer() then 
		local aggro = self:GetParent():GetAggroTarget()
		if aggro and aggro~=self.target then return end
	end
	return self.bonus 
end
function modifier_Primary_Focus_Fire:GetModifierDamageOutgoing_Percentage()
	if not IsServer() then return end
	local aggro = self:GetParent():GetAggroTarget()
	if aggro and aggro~=self.target then return end

	return self.reduction
end
--------------------------------------------------------------------


-------------------------------------------------------------------

function modifier_Primary_Focus_Fire:OnOrder( params )   --停止攻击
	if not IsServer() then return end
	if params.unit~=self:GetParent() then return end

	-- if ordered to attack target, move to target instead
	if params.order_type==DOTA_UNIT_ORDER_ATTACK_TARGET and params.target==self.target then
		-- chase instead
		self.follow = true
	else
		self.follow = false
	end

	-- specific order to stop autoattack
	if params.order_type==DOTA_UNIT_ORDER_ATTACK_TARGET and params.target~=self.target then
		self.attacking = false
	elseif params.order_type==DOTA_UNIT_ORDER_HOLD_POSITION then
		self.attacking = false
	elseif params.order_type==DOTA_UNIT_ORDER_CONTINUE then
		self.attacking = false
	elseif params.order_type==DOTA_UNIT_ORDER_STOP then
		self.attacking = false
	elseif params.order_type==DOTA_UNIT_ORDER_MOVE_TO_DIRECTION then
		self.attacking = false
	-- other order resumes attack
	else
		if self:GetParent():IsDisarmed() or self:GetParent():IsStunned() or self:GetParent():IsFrozen() or self:GetParent():IsHexed() or self:GetParent():IsOutOfGame() or self:GetParent():IsInvulnerable() then
			self.attacking = false
		else
			self.attacking = true
		end
	end
end
--------------------------------------------------------------------------------
-- Interval Effects
function modifier_Primary_Focus_Fire:OnIntervalThink()
	if not IsServer() then return end


	if self.target:IsNull() or not self.target:IsAlive() then
		-- if dead and not respawn, just stop
		self:StartIntervalThink(-1)
		return
	end

	-- check target within range
	local distance = (self.target:GetOrigin()-self:GetParent():GetOrigin()):Length2D()
	local range = self:GetParent():Script_GetAttackRange(  )
	--这是个全图射程，以后可以激活
	-- if IsServer() and self:GetParent():HasAbility("pathfinder_special_windranger_focusfire_global") then   
	-- 	range = range / 100 * self:GetParent():FindAbilityByName("pathfinder_special_windranger_focusfire_global"):GetSpecialValueFor("range_mult")
	-- end
	self.inRange = distance<=range
	if self.inRange and self.attacking and self.target:IsAlive() then
		-- if self.follow then
		-- 	-- TODO: not immediately follow target
		-- 	self:GetParent():MoveToNPC( self.target )
		-- end

		-- bombard target, but respect attack speed cooldown
		self:GetParent():PerformAttack(
			self.target,
			true,
			true,
			false,
			false,
			true,
			false,
			false
		)
		
	end
end




