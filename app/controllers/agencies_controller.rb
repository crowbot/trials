class AgenciesController < ApplicationController 

  def index
    @agencies = Agency.paginate(:all, :page => params[:page], :order => 'name')
    @total_agencies = Agency.count
  end
  
  def show
    @agency = Agency.find(params[:id])
  end
  
end