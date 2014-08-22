class PersonHandler
  def create(channel_proxy)
    puts "#{self.class.name}: #{channel_proxy.payload}"
  end
end

class AssetHandler
  def create(channel_proxy)
    puts "#{self.class.name}: #{channel_proxy.payload}"
  end
end
