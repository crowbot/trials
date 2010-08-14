# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def trial_text trial
    text = "#{trial.brief_title}"
    if !trial.completion_date.blank?
      text += " (completed #{trial.completion_date})"
    end
    text
  end 
  
end
