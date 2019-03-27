module BackgroundJobHelpers
  def execute_background_jobs
    Delayed::Worker.new.work_off
  end
end
