json.array! @pages do |page|
  json.id page.id
  json.score page.search_hit["_score"]

  # json.space do
  #   json.id page.space.id
  #   json.name page.space.name
  #   json.access_control page.space.access_control
  # end

  json.space do
    json.id page.space.id
    json.name page.space.name
  end

  json.title page.search_highlights[:title] || page.title
  json.contents page.search_highlights[:contents]
  json.url page_path(page, search_id: @pages.search.id)
  json.extract! page, :created_at, :updated_at
end
