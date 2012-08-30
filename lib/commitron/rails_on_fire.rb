module Commitron
  class RailsOnFire
    def initialize driver, user, password
      @driver = driver
      @user = user
      @password = password
    end

    def log_in
      @driver.navigate.to 'http://railsonfire.com'
      login_link = @driver.find_element(id: 'login')
      login_link.click
      emails = @driver.find_elements(id: 'user_email')
      emails[1].send_keys @user
      passwords = @driver.find_elements(id: 'user_password')
      passwords[1].send_keys @password
      sign_in_button = @driver.find_element(id: 'signin')
      sign_in_button.click
      dashboard_link = @driver.find_element(link_text: 'Dashboard')
      dashboard_link.click
    end

    def current_build
      @driver.navigate.refresh

      all_builds = @driver.find_elements(xpath: "//a[contains(@class, 'build last')]")

      latest_build = all_builds.find do |b|
        status = b.attribute("class").split(" ")[1].split("-").last
        status == 'success' || status == 'error'
      end

      status_class = latest_build.attribute("class").split(" ")[1]
      build_status = status_class.split("-").last
      user_text = latest_build.find_element(class: 'build_user').text
      builder = user_text.split(' ')[0]

      {status: build_status, builder: builder}
    end
  end
end