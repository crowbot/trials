class ClinicalTrialsController < ApplicationController
  
  def index
    condition_string = ''
    condition_params = []
    
    if params[:agency_id]
      condition_string += "sponsors.agency_id = ?"
      condition_params << params[:agency_id]
    end
    
    if params[:official_agency_id]
      condition_string += "overall_officials.agency_id = ?"
      condition_params << params[:official_agency_id]
    end
    
    if params[:intervention_id]
      condition_string += "trial_interventions.intervention_id = ?"
      condition_params << params[:intervention_id]
    end
    
    if params[:condition_id]
      condition_string += "condition_trials.condition_id = ?"
      condition_params << params[:condition_id]
    end
    
    
    if params[:unpublished]
      clazz = ClinicalTrial.searched.completed.three_years_old.unpublished
    else
      clazz = ClinicalTrial
    end
    
    condition_params = [condition_string] + condition_params
    
    @trials = clazz.paginate(:all, :page => params[:page], 
                                   :conditions => condition_params, 
                                   :include => [:sponsors, :trial_interventions, :overall_official, :condition_trials])
    @total_trials_count = ClinicalTrial.count
  end
   
  def show
    @trial = ClinicalTrial.find(params[:id])
  end
  
  def statistics
    @agencies = Agency.by_unpublished_completed
    @conditions = Condition.by_unpublished_completed
    @interventions = Intervention.by_unpublished_completed
  end
  
  def search
    if params[:q]
      @trials_found = ClinicalTrial.search(params[:q])
      @trials_found_count = @trials_found.size
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
      wants.html{ @trials_found = @trials_found.paginate(:page => params[:page], :per_page => 20) }
      wants.js
    end
  end

end
