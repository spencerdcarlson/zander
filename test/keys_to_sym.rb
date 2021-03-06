h = {"action"=>nil, "action_type"=>"click_element", "identifier"=>{"id"=>"gb_70"}}

class Hash
	def change_keys(hash)
		hash.each do |key,value|
			if !key.is_a?(Hash) && !value.is_a?(Hash)
				hash = hash.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
			else
				hash.map{ |k,v|  hash[k] = change_keys(v) if v.is_a?(Hash) }
			end
		end
		hash = hash.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
	end
	
	
	def keys_to_sym
		change_keys(self)
	end
end
p h
p h.keys_to_sym