# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

dante = User.create(:name=>"dante", :surname=>"alighieri", :username=>"dante", :email=>"dante@gmail.com", :password=>"minimo", :role=>"superadmin")
giorgio = User.create(:name=>"giorgio", :surname=>"dema", :username=>"giorgio", :email=>"giorgio@gmail.com", :password=>"minimo", :role=>"admin")
vincenzo = User.create(:name=>"vincenzo", :surname=>"cas", :username=>"vincenzo", :email=>"vincenzo@gmail.com", :password=>"minimo", :role=>"admin")
flavia = User.create(:name=>"flavia", :surname=>"mon", :username=>"flavia", :email=>"flavia@gmail.com", :password=>"minimo", :role=>"admin")

c01 = Chat.create(:owner=>giorgio,:guest=>vincenzo)
Message.create(:chat=>c01, :text=>"Ciao vincenzo", :from=>:o, :read=>true)
Message.create(:chat=>c01, :text=>"Ciao giorgio, tutto bene?", :from=>:g, :read=>true)

c02 = Chat.create(:owner=>giorgio,:guest=>flavia)
Message.create(:chat=>c02, :text=>"Ciao Fla, come stai?", :from=>:o, :read=>true)
Message.create(:chat=>c02, :text=>"Ciao Gio, bene tu? stai studiando?", :from=>:g, :read=>true)