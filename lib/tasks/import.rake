namespace :import do
  desc "Import tomatoes from csv (assumes export format)"
  task :tomatoes, [:email, :path] => :environment do |_task, args|
    email = args.fetch(:email)
    path = args.fetch(:path)
    user = User.find_by!(email: email)

    CSV.open(path).each do |row|
      user.tomatoes.create!(
        created_at: row[0],
        tags: row[1].split(",")
      )
    end
  end
end
