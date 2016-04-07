module FeatureHelpers
  def resize_window_width(width, heigth)
    page.driver.browser.manage.window.resize_to(width, heigth)
  end
end
