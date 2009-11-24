require 'sinatra/base'

module Integrity
  module Integritray
    module Helpers

      def xml_opts_for_project(project)
        opts = {}
        opts['name']     = project.name
        opts['category'] = project.branch
        opts['activity'] = activity(project.last_commit.status) if project.last_commit
        opts['webUrl']   = project_url(project)
        if project.last_commit
          opts['lastBuildStatus'] = build_status(project.last_commit.status)
          opts['lastBuildLabel']  = project.last_commit.short_identifier
          opts['lastBuildTime']   = project.last_commit.build.completed_at if project.last_commit.build
        end
        opts
      end

      def activity(status)
        case status
        when :success, :failed then 'Sleeping'
        when :pending then 'Building'
        else 'Sleeping'
        end
      end

      def build_status(status)
        case status
        when :success, :pending then 'Success'
        when :failed then 'Failure'
        else 'Unknown'
        end
      end

    end


    def self.registered(app)
      app.helpers Integritray::Helpers

      app.get '/projects.xml' do
        builder do |xml|
          @projects = authorized? ? Project.all : Project.all(:public => true)
          response["Content-Type"] = "application/xml; charset=utf-8"
          xml.Projects do
            @projects.each do |project|
              xml.Project xml_opts_for_project(project)
            end
          end
        end
      end

    end

  end # Integritray
end # Integrity
