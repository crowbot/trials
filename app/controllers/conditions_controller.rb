class ConditionsController < ApplicationController

  def index
    @conditions = Condition.paginate(:all, :page => params[:page], :order => 'name')
    @total_conditions = Condition.count
  end
  
  def show
    @condition = Condition.find(params[:id])
  end
end