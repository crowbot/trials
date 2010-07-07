class ClinicalTrialsController < ApplicationController
  
  def index
    @trials = ClinicalTrial.completed.searched.unpublished.paginate(:all, :page => params[:page], 
                 :conditions => ['completion_date_as_date < ?', Time.now.beginning_of_month - 3.years])
    @total_trials_count = ClinicalTrial.count
  end
   
  def show
    @trial = ClinicalTrial.find(params[:id])
  end
  
  def search
    if params[:q]
      @trials_found = ClinicalTrial.search(params[:q])
      @trials_found_count = @trials_found.count
      @trials_published_count = 0
      @trials_searched_count = 0
      for @trial_found in @trials_found
        if @trial_found.searched 
            @trials_searched_count += 1
        end           
        if not @trial_found.articles.empty? 
            @trials_published_count += 1
        end
      end
      @query = params[:q]
    else
      @trials_found = []
    end
    respond_to do |wants|
      wants.html
      wants.js
    end
  end

end
