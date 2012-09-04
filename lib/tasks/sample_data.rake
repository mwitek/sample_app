#rake task
namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    make_users
    make_micropost
    make_relationships
    puts "task complete!"
  end
end

def make_users
  puts "creating admin user..."
  admin = User.create!(:name => "Matt Witek",
               :email => "matt@mwitekdesign.com",
               :password => "foobar",
               :password_confirmation => "foobar")
  
  #set admin user as admin using toggle() since default is false
  admin.toggle!(:admin)

  puts("creating 99 more users...")
  99.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@sample.com"
    password  = "password"
    User.create!(:name => name,
                 :email => email,
                 :password => password,
                 :password_confirmation => password)
  end
end

def make_micropost
  puts "creating micropost..."
  users = User.all(:limit => 15)
  
  50.times do
    content = Faker::Lorem.sentence(5)
    users.each { |user| user.microposts.create!(:content => content) }
  end 
end

def make_relationships
  puts "creating followers / user_followed relationships..."
  user = User.first
  users = User.all
  followed_users = users[2..40]
  followers = users[1..20]
  followed_users.each { |follow| user.follow!(follow) }
  followed_users.each { |follower| follower.follow!(user) }
end