require_relative "../cli_helper"

module CLI
  module Disposables
    class GenerateTeamLogos < Thor

      desc "generate", "save generated logos for teams without logos"
      def generate
        i = 0

        Team.where("logo_data = 'null'").find_each do |team|
          Team::Logo::AttachGeneratedLogo.call(team: team)
          team.save
          i += 1
        end

        puts "Successfully generated logos for #{i} teams"
      end

    end
  end
end

CLI::Disposables::GenerateTeamLogos.start(ARGV)
