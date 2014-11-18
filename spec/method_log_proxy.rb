class MethodLogProxy
  def initialize(strio, client)
    @strio = strio
    @client = client
  end

  # Any method called on the client will just be logged and passed through
  def method_missing(m, *args, &block)
  	@strio << "#{method}(#{args})\n"
  	client.send(m,args)
  end

end