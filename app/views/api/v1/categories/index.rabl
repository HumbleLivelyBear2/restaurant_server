collection @categories
attributes :id, :name

child (:second_categories) do
  attributes :id, :name
end