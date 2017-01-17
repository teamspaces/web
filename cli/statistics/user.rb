require "thor"
require "terminal-table"

ENV["RAILS_ENV"] = ENV["RAILS_ENV"] || "development"
require File.expand_path("../../config/environment.rb", __FILE__)

module CLI
  module Statistics
    class User < Thor
      desc "total", "Show total users"
      def total
        total_users = ::User.count
        say "There is a total of #{total_users} users.", :magenta
      end

      desc "latest", "Show latest created users"
      long_desc <<~LONGDESC
        Show the latest created users in our database.

        With --limit option, you can specify how many users to show.
      LONGDESC
      option :limit, type: :numeric, default: 25
      def latest
        limit = options[:limit]

        headings = ["ID", "Name", "Email", "Created at"]
        rows = []
        ::User.last(limit).each do |user|
          rows << [user.id, user.name, user.email, user.created_at]
        end

        table = Terminal::Table.new(title: "Show latest #{limit} created users",
                                    headings: headings,
                                    rows: rows)

        say table, :magenta
      end
    end
  end
end

CLI::User.start(ARGV)
