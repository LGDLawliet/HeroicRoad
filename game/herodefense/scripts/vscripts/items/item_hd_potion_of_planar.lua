
LinkLuaModifier("modifier_item_hd_potion_of_planar", "items/item_hd_potion_of_planar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_potion_of_planar_debuff", "items/item_hd_potion_of_planar", LUA_MODIFIER_MOTION_NONE)


item_hd_potion_of_planar = class({})


function item_hd_potion_of_planar:OnSpellStart()
	if IsServer() then
		-- local mana_restore_pct = self:GetSpecialValueFor( "mana_restore_pct" )
		self:GetCaster():EmitSoundParams( "Bottle.Drink", 0, 0.5, 0 )
		-- local target = self:GetCursorTarget()
		
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_hd_potion_of_planar", {duration = 15})

	end
end

--------------------------------------------------------------------------------


modifier_item_hd_potion_of_planar = advanced_modifier({})

function modifier_item_hd_potion_of_planar:IsDebuff() return false end
function modifier_item_hd_potion_of_planar:IsHidden() return false end
function modifier_item_hd_potion_of_planar:IsPurgable() return false end
function modifier_item_hd_potion_of_planar:IsPurgeException() return false end
function modifier_item_hd_potion_of_planar:GetTexture()return "item_potion_of_planar_infusion" end
function modifier_item_hd_potion_of_planar:RemoveOnDeath() return false end
function modifier_item_hd_potion_of_planar:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end


function modifier_item_hd_potion_of_planar:Advanced_GetModifierSpellAmplifyBonus()	return self:GetStackCount()*30 end
function modifier_item_hd_potion_of_planar:OnCreated(params)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
	end
end
function modifier_item_hd_potion_of_planar:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()
		if self:GetStackCount()>= 5 then
			return
		else
			--当叠加乘数没达到最高时
			table.insert(self.tData, {dieTime = dieTime })
			self:IncrementStackCount()
		end
	end
end

function modifier_item_hd_potion_of_planar:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:DecrementStackCount()
				self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_hd_potion_of_planar_debuff", {duration = 25})

			end
		end
	end
end


modifier_item_hd_potion_of_planar_debuff = advanced_modifier({})

function modifier_item_hd_potion_of_planar_debuff:IsDebuff() return true end
function modifier_item_hd_potion_of_planar_debuff:IsHidden() return false end
function modifier_item_hd_potion_of_planar_debuff:IsPurgable() return false end
function modifier_item_hd_potion_of_planar_debuff:IsPurgeException() return false end
function modifier_item_hd_potion_of_planar_debuff:GetTexture()return "item_potion_of_planar_infusion" end
function modifier_item_hd_potion_of_planar_debuff:RemoveOnDeath() return false end
function modifier_item_hd_potion_of_planar_debuff:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end
function modifier_item_hd_potion_of_planar_debuff:Advanced_GetModifierSpellAmplifyBonus()	return -self:GetStackCount()*60 end
function modifier_item_hd_potion_of_planar_debuff:OnCreated(params)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
	end
end
function modifier_item_hd_potion_of_planar_debuff:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()
		table.insert(self.tData, {dieTime = dieTime })
		self:IncrementStackCount()
	end
end

function modifier_item_hd_potion_of_planar_debuff:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:DecrementStackCount()


			end
		end
	end
end



