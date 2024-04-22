class Message < ApplicationRecord
  belongs_to :user
  
  def whatsapp_link
    "https://wa.me/#{whatsapp_number}?text=#{text.gsub(' ', '%20')}"
  end
end
