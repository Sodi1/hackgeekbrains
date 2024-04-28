class SubmitsController < ApplicationController
  def show
    submit = Submit.find(params[:id])
    send_data submit.file_content,
              type: 'text/csv; charset=utf-8; header=present',
              disposition: "attachment; filename=Submit report #{submit.created_at}.csv"
  end
end

