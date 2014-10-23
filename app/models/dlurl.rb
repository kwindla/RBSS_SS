class Dlurl < ActiveRecord::Base
	def self.deliver_url(response, artist)
		download_url = Dlurl.where(:artist => artist.to_s, :used => false).first
		download_url.used = true
		download_url.save
		data = {"stamp_serial" => response["stamp"]["serial"], "download_url" => download_url.address}
  end
end
