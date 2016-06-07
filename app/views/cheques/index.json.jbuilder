json.array!(@cheques) do |cheque|
  json.extract! cheque, :id, :name, :creation, :value
  json.url cheque_url(cheque, format: :json)
end
