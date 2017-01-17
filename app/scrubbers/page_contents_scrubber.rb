class PageContentsScrubber < Rails::Html::PermitScrubber
  def initialize
    super
    self.tags = %w(h1 h2 h3 h4 h5 p br strong s em ul ol li pre code a span p)
  end
end
