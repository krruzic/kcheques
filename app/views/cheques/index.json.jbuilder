json.array!(@cheques) do |cheque|
  json.extract! cheque, :id, :name, :creation, :money
  json.url cheque_url(cheque, format: :json)
end
