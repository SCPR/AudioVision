json.array! billboards do |billboard|
  json.partial! "api/public/v1/billboards/billboard", billboard: billboard
end
