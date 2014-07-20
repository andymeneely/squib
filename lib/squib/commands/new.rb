module Squib
  module Commands
    class New

      def process(args)
        raise ArgumentError.new('Please specify a path.') if args.empty?

        new_project_path = File.expand_path(args.join(" "), Dir.pwd)
        template_path = File.expand_path('../project_template', File.dirname(__FILE__))

        FileUtils.mkdir_p new_project_path
        if !Dir["#{new_project_path}/**/*"].empty?
          $stderr.puts "#{new_project_path} exists and is not empty. Doing nothing and quitting."
        else
          Dir.chdir(new_project_path) do
            FileUtils.cp_r template_path + '/.', new_project_path
          end
        end
      end

    end
  end
end