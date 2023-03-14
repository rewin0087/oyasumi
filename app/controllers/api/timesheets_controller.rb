class Api::TimesheetsController < ApplicationController

  def clock_in
    ClockIn.new.call(user: current_user)

    render json: {}, status: :no_content
  end

  def clock_out
    ClockOut.new.call(user: current_user)

    render json: {}, status: :no_content
  end
end
