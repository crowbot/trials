class ClinicalTrialsController < ApplicationController
  
  def index
    @trials = ClinicalTrial.completed.searched.unpublished.paginate(:all, :page => params[:current_page], 
                 :conditions => ['completion_date_as_date < ?', Time.now.beginning_of_month - 3.years])
  end
  
  def show
    @trial = ClinicalTrial.find(params[:id])
  end

end
