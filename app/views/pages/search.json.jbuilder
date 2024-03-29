json.array! @pages do |page|
  json.id page.id
  json.score page.search_hit["_score"]

  json.space do
    json.id page.space.id
    json.name page.space.name
  end

  json.title page.search_highlights[:title] || page.title
  json.contents sanitize(page.search_highlights[:contents], tags: %w(em))
  json.url page_path(page, search_id: @pages.search.id)
  json.extract! page, :created_at, :updated_at
end
