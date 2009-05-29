class Integrity::App < Sinatra::Default
  get '/projects.xml' do
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

  # Move route definition with the literal routes where it won't be hidden behind any general matchers
  xml_route = routes['GET'].pop
  first_literal_route = routes['GET'].find { |route| route.first.inspect.include? 'integrity' }
  routes['GET'].insert(routes['GET'].index(first_literal_route), xml_route)
  
  private
    def xml_opts_for_project(project)
      opts = {}
      opts['name']     = project.name
      opts['category'] = project.branch
      opts['activity'] = project.building? ? 'Building' : 'Sleeping'
      opts['webUrl']   = project_url(project)
      if project.last_commit
        opts['lastBuildStatus'] = project.last_commit.status.to_s.capitalize
        opts['lastBuildLabel']  = project.last_commit.short_identifier
        opts['lastBuildTime']   = project.last_commit.build.completed_at if project.last_commit.build
      end
      opts
    end
end