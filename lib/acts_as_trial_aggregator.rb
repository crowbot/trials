module Acts
  module TrialAggregator
    def self.included(base) # :nodoc:
      base.extend ClassMethods
    end

    module ClassMethods

      def acts_as_trial_aggregator(options={})
        include Acts::TrialAggregator::InstanceMethods
      end
      
      def by_unpublished_completed(limit=10)
        find(:all, :order => "percent_unpublished_complete desc, count_unpublished_complete desc", 
                   :limit => limit)
      end
      
    end
    
    module InstanceMethods

      def calculate_percent_unpublished_complete
        old_complete_searched = clinical_trials.completed.searched.three_years_old
        searched_count = old_complete_searched.size
        unpublished_count = old_complete_searched.unpublished.size                                                       
        if searched_count == 0 
          return 0
        end
        return ( unpublished_count.to_f / searched_count.to_f ) * 100
      end

      def update_cached_stats
        update_attributes({:percent_unpublished_complete => calculate_percent_unpublished_complete, 
                           :count_unpublished_complete => clinical_trials.completed.searched.three_years_old.size})
      end
    end
  end
end