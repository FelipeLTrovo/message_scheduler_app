json.array! @messages do |message|
  json.id message.id
  json.text message.text
  json.whatsapp_number message.whatsapp_number
  json.scheduled_date message.scheduled_date
  json.whatsapp_link message.whatsapp_link
end