# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

5.times do
  merchant = Merchant.create!(
    name: Faker::Company.name
    )
end

10.times do
  item = Item.create!(
    name: Faker::Commerce.product_name,
    description: Faker::Lorem.sentence,
    unit_price: Faker::Commerce.price,
    merchant_id: Merchant.all.sample.id
  )
end

cmd = "pg_restore --verbose --clean --no-acl --no-owner -h localhost -U $(whoami) -d rails_engine_development db/data/rails-engine-development.pgdump"
puts "Loading PostgreSQL Data dump into local database with command:"
puts cmd
system(cmd)
