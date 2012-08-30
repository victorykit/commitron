module Commitron
  class BuildChecker
    def initialize(rof_user, rof_password)
      @rof_user = rof_user
      @rof_password = rof_password
      @previous_build_state = nil
    end

    def run
      build_message = nil
      begin
        driver = Selenium::WebDriver.for :chrome
        rof = RailsOnFire.new driver, @rof_user, @rof_password
        rof.log_in

        current_build_state = rof.current_build
        @previous_build_state ||= current_build_state
        puts "build state is #{current_build_state[:status]}; previous build state was #{@previous_build_state[:status]}"
        build_message = generate_build_message(@previous_build_state, current_build_state)
        @previous_build_state = current_build_state
      rescue => ex
        puts ex
        puts ex.backtrace.join
      ensure
        driver.quit
      end
      build_message
    end

    private

    def generate_build_message(previous_build = {}, current_build = {})
      if(current_build[:status] == 'error' && previous_build[:status] == 'success')
        "#{current_build[:builder]} broke the build"
      elsif (current_build[:status] == 'success' && previous_build[:status] == 'error')
        "#{current_build[:builder]} has fixed the build"
      end
    end
  end
end