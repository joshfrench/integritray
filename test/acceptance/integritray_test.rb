# Unclear how to get ahold of Integrity's test helpers externally. For now,
# I've been copying this into an unpacked version of Integrity and running it
# there.

require File.dirname(__FILE__) + "/../helpers/acceptance"
require 'integrity/integritray'

class IntegritrayTest < Test::Unit::AcceptanceTestCase
  include Integrity::Helpers::Urls

  story <<-EOS
    As a user,
    I want an XML representation of my projects
    So I can use CCMenu with Integrity
  EOS

  scenario "projects.xml has a tag representing my project" do
    project = Project.gen(:integrity, :public => true, :commits => 2.of { Commit.gen(:successful)})
    commit = project.last_commit
    visit "/projects.xml"

    assert_have_tag("projects")
    assert_have_tag("projects/project[@name='Integrity']")
    assert_have_tag("projects/project[@lastbuildlabel='#{commit.short_identifier}']")
    assert_have_tag("projects/project[@weburl='#{project_url(project)}']")
    assert_have_tag("projects/project[@category='#{project.branch}']")
    assert_have_tag("projects/project[@activity='Sleeping']")
    assert_have_tag("projects/project[@lastbuildstatus='#{commit.status}']")
  end
end