class InterventionsController < ApplicationController

  def index
    condition_string = ''
    condition_params = []
    
    if params[:intervention_type_id]
      condition_string += "intervention_type_id = ?"
      condition_params << params[:intervention_type_id]
    end
    condition_params = [condition_string] + condition_params
    
    @interventions = Intervention.paginate(:all, 
                                           :conditions => condition_params,
                                           :page => params[:page],
                                           :order => 'name')
    @total_interventions = Intervention.count
  end
  
  def show
    @intervention = Intervention.find(params[:id])
  end
end