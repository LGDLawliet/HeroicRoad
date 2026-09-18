
Middle_Haunt = class({})


LinkLuaModifier("modifier_Middle_Haunt_illusion", "skills/Middle_Haunt", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Haunt_damage", "skills/Middle_Haunt", LUA_MODIFIER_MOTION_NONE)

function Middle_Haunt:IsHiddenWhenStolen() 		return false end
function Middle_Haunt:IsRefreshable() 			return true end
function Middle_Haunt:IsStealable() 				return true end
function Middle_Haunt:IsNetherWardStealable()		return false end


function Middle_Haunt:OnSpellStart()
	local caster = self:GetCaster()
	--spe 音效
	caster:EmitSound("Hero_Spectre.HauntCast")
	--获取全地图敌人位置和视野
	local heroes = GetAllRealHeroes()
	-- local modifierKeys = {}
	-- modifierKeys.outgoing_damage = -100
	-- modifierKeys.incoming_damage = 0
	-- modifierKeys.duration = self:GetSpecialValueFor("duration")
	for _, hero in pairs(heroes) do
		-- local illusion = CreateIllusions( caster, caster, modifierKeys, 1, 100, true, true)
		-- illusion[1]:SetControllableByPlayer(-1, true)	
		local illusion =  caster:MakeCustomIllusion()
		illusion:AddNewModifier(hero, self, "modifier_Middle_Haunt_illusion", {duration =self:GetSpecialValueFor("duration") })
	end

end


modifier_Middle_Haunt_illusion = class({})

function modifier_Middle_Haunt_illusion:IsDebuff()			return false end
function modifier_Middle_Haunt_illusion:IsHidden() 			return false end
function modifier_Middle_Haunt_illusion:IsPurgable() 		return false end
function modifier_Middle_Haunt_illusion:IsPurgeException() 	return false end
function modifier_Middle_Haunt_illusion:CheckState() return 
	{[MODIFIER_STATE_INVULNERABLE] = true,
	 [MODIFIER_STATE_NO_HEALTH_BAR] = true,
	 [MODIFIER_STATE_UNSELECTABLE] = true, 
	 [MODIFIER_STATE_NOT_ON_MINIMAP] = true, 
	 [MODIFIER_STATE_NO_UNIT_COLLISION] = true, 
	 [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
	 [MODIFIER_STATE_NO_UNIT_COLLISION] = true} end

function modifier_Middle_Haunt_illusion:DeclareFunctions() return {
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
	MODIFIER_PROPERTY_ATTACKSPEED_BASE_OVERRIDE


	} 
end
function modifier_Middle_Haunt_illusion:GetModifierMoveSpeedBonus_Percentage() return 1000 end

function modifier_Middle_Haunt_illusion:GetModifierIgnoreMovespeedLimit() return 1 end
function modifier_Middle_Haunt_illusion:GetModifierAttackSpeedBaseOverride(keys)
	return self:GetCaster():GetAttackSpeed(false)
end

function modifier_Middle_Haunt_illusion:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(1)

	end
end


function modifier_Middle_Haunt_illusion:OnIntervalThink()
	if not IsServer() then
		return
	end
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		-- local parent = self:GetParent()
		self:SafeDestroy()
		-- parent:ForceKill(false)
		
		return
	end
	local caster = self:GetAbility():GetCaster()  --技能的拥有者
	local parent = self:GetCaster()               --幻象跟随者
	local parent_pos = parent:GetAbsOrigin()      --幻象跟随者位置
	local self_pos = self:GetParent():GetAbsOrigin()--幻象位置
	local distance = (parent_pos - self_pos):Length2D()
	--距离太远就走进跟随者
	if distance >1500 then 
		self:GetParent():SetForceAttackTarget(nil) 
		self:GetParent():MoveToPosition(parent_pos)
		return
	end
	local enemy = FindUnitsInRadius(caster:GetTeamNumber(), parent:GetAbsOrigin(), nil, 1500,
	 DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	 if #enemy>0 and enemy[1]:IsAlive() then
		  self:GetParent():SetForceAttackTarget(enemy[1])
	 else
		self:GetParent():SetForceAttackTarget(nil)
	 end
end



function modifier_Middle_Haunt_illusion:OnAttackLanded(keys)
	if not IsServer() or keys.attacker ~= self:GetParent() then
		return
	end
	local target = keys.target
	local ability = self:GetAbility()
	if not ability then
		return
	end
	local caster = ability:GetCaster()  --这里获取到的是技能拥有者
	local damage = ability:GetSpecialValueFor( "damage" ) * caster:HDGetPrimaryStatValue()
	local damage_type = ability:GetAbilityDamageType()
	target:EmitSound("Hero_Terrorblade.Reflection")

	-- local damageTable = {
	-- 	victim = target,
	-- 	attacker = caster,
	-- 	damage = damage,
	-- 	damage_type = damage_type,
	-- 	damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	-- 	ability = ability, --Optional.
	-- 	}
	-- local damage2 = ApplyDamage(damageTable)

	target:AddNewModifier(caster, ability, "modifier_Middle_Haunt_damage", {stack = damage})
			
end



function modifier_Middle_Haunt_illusion:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()
		UTIL_Remove( parent )
	end
end



modifier_Middle_Haunt_damage = class({})

function modifier_Middle_Haunt_damage:IsDebuff() return true end
function modifier_Middle_Haunt_damage:IsHidden() return false end
function modifier_Middle_Haunt_damage:IsPurgable() return false end
function modifier_Middle_Haunt_damage:IsPurgeException() return false end
function modifier_Middle_Haunt_damage:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
		self:StartIntervalThink(0.5)
	end
end

function modifier_Middle_Haunt_damage:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+ keys.stack)

	end
end
function modifier_Middle_Haunt_damage:OnIntervalThink()
	local ability = self:GetAbility()
	if not ability then
		self:SafeDestroy()
		return
	end

	self:GetParent():EmitSound("Hero_Terrorblade.Reflection")
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage =  self:GetStackCount(),
		damage_type = ability:GetAbilityDamageType(),
		damage_flags = DOTA_UNIT_TARGET_FLAG_NONE, 
		ability = ability,
		}
	ApplyDamage(damageTable)

	self:SetStackCount(0)
	self:SafeDestroy()
end
