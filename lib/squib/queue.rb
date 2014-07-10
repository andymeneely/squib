module Squib
	#Global queue of commands
	CMDS = []

	def queue_command(cmd)
		unless cmd.instance_of? Squib::Commands::Command
    		raise ArgumentError, "Only RockDeck::Commands allowed here"
  		end
  		CMDS << cmd
	end
end