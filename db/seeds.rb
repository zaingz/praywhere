# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'json'

file = File.read('db/pray.json')
data = JSON.parse(file)
counti = 0

data.each do |my_d|
	if my_d['post_content'] != "" && my_d['post_title'] != "About" && my_d['post_title'] != "Logo" && my_d['post_type'] != "page"
		if Version.find_by_name(my_d['post_title'])

		else
			room = Room.create(user_id: 1)
			post_content = ActionController::Base.helpers.strip_tags(my_d['post_content'])
			version = Version.create(name: my_d['post_title'], street: "", floor: "", city: "", country: "", description: post_content , direction: "Please refer to the description", created_at: my_d['post_date'] , room_id: room.id, status: 1, typ: 0 )
			regex_an = "<a\shref=[^>]*[>]"
			regex_hre = 'http[^"]*'
			mat = my_d['post_content'].scan(/<a\shref=[^>]*[>]/)
			if mat.count < 1
				photoo = Photo.create(photo_url: my_d['guid'] , cloud: false , version_id: version.id)
			else
				mat.each do |im|
					ms = im.match(regex_hre)
					photoo = Photo.create(photo_url: ms , cloud: false , version_id: version.id)		
				end
				p "Bingoo"
			end

			counti += 1
			data.each do |second_lop|
				if room.versions.count < 2
					if second_lop['post_content'] != "" && second_lop['post_title'] != "About" && second_lop['post_type'] != "page"
						if second_lop['post_parent'] == my_d['ID']
							post_contenti = ActionController::Base.helpers.strip_tags(second_lop['post_content'])
							versioni = Version.create(name: second_lop['post_title'], street: "", floor: "", city: "", country: "", description: post_contenti , direction: "Please refer to the description", created_at: second_lop['post_date'] , room_id: room.id, status: 1, typ: 1 )
							
							mat_s = second_lop['post_content'].scan(/<a\shref=[^>]*[>]/)
							if mat_s.count < 1
								photoo = Photo.create(photo_url: second_lop['guid'] , cloud: false , version_id: versioni.id)
							else
								mat_s.each do |imk|
									mas = imk.match(regex_hre)
									photoo = Photo.create(photo_url: mas , cloud: false , version_id: versioni.id)		
								end
								p "Bingoo"
							end
							#photoo = Photo.create(photo_url: second_lop['guid'] , cloud: false , version_id: versioni.id)
							counti += 1

							descri = second_lop['post_content'].gsub(regex_an,"")
							descri = second_lop['post_content'].gsub(regex_hre,"")

							versioni.update(description: descri)
						end
					end
				end
			end

			descrip = my_d['post_content'].gsub(regex_an,"")
			descrip = my_d['post_content'].gsub(regex_hre,"")

			version.update(description: descrip)
		end
	end
end
p counti