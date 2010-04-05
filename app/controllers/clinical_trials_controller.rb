class ClinicalTrialsController < ApplicationController
  
  def index
    @trials = ClinicalTrial.paginate(:all, :page => params[:page], :order => 'updated_at DESC')
  end
  
  def show
    @trial = ClinicalTrial.find(params[:id])
  end

end
