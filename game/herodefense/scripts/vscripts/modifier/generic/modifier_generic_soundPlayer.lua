
modifier_generic_soundPlayer = class({})
function modifier_generic_soundPlayer:OnCreated(keys)
	if IsServer() then
		if keys.attach_caster then
			self:GetParent():SetParent(self:GetCaster(), "")
		end
	end

end
function modifier_generic_soundPlayer:OnDestroy(keys)
	if IsServer() then
		UTIL_Remove(self:GetParent())
	end
end



