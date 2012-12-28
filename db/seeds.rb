# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

if Rails.env.production?
  %w[testing staging production].each do |name|
    namespace = Namespace.find_or_create_by_name(
      name: name,
      description: "#{name.humanize} namespace for our projects"
    )
    %w[main cms admin api workers].each do |pname|
      namespace.projects.create(
        name: pname,
        host: "#{name}.#{pname}.com",
        description: "#{name.humanize} project for #{name.humanize} namespace"
      )
    end
  end
end

if Rails.env.development?
  %w[google github pinterest].each do |name|
    Namespace.find_or_create_by_name(
      name: name,
      description: "Some #{name.humanize} projects monitoring"
    )
  end

  google = Namespace.find_by_name("google")
  google.projects.find_or_create_by_name( name: "Google Search", host: "http://www.google.com/", description: "Main Google page")
  google.projects.find_or_create_by_name( name: "Google Maps", host: "http://maps.google.com/", description: "Google Maps service")
  google.projects.find_or_create_by_name( name: "Youtube", host: "http://youtube.com/", description: "Google video service")

  github = Namespace.find_by_name("github")
  github.projects.find_or_create_by_name( name: "Github Main", host: "http://github.com/", description: "Github Social Coding")
  github.projects.find_or_create_by_name( name: "Gist", host: "http://gist.github.com/", description: "Github code fragments sharing service")

  pinterest = Namespace.find_by_name("pinterest")
  pinterest.projects.find_or_create_by_name( name: "Pinterest Main", host: "http://pinterest.com/", description: "Pinterest images and videos sharing social service")
end
